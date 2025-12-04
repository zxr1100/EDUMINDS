const functions = require("firebase-functions/v1");
const axios = require("axios");
const admin = require("firebase-admin");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");

admin.initializeApp();
const db = getFirestore();

// 🔑 Backend-only Gemini key
const GEMINI_API_KEY = "AIzaSyCdMO6sMm6THG9IVTaLGvygpf4DmPQln74";
const MODEL_ID = "gemini-2.5-flash";

// ---------------------------------------------------------------------------
// 0. Ping (sanity)
// ---------------------------------------------------------------------------
exports.ping = functions.https.onRequest((req, res) => {
  res.send("pong");
});

// ---------------------------------------------------------------------------
// 1. Doubt Solving AI
// ---------------------------------------------------------------------------
exports.solveDoubt = functions.https.onCall(async (data, context) => {
  let payload = data || {};
  if (payload && payload.doubt === undefined && payload.data) {
    payload = payload.data;
  }

  const doubt = payload.doubt;
  const language = payload.language || "en";

  if (!doubt) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "doubt is required"
    );
  }

  const prompt = `
  You are a friendly STEM teacher.
  Explain the student's doubt below in very simple ${language}.
  Use short sentences, everyday Indian examples, and keep it under 6 lines.

  Student's doubt: ${doubt}
  `;

  try {
    const url =
      "https://generativelanguage.googleapis.com/v1beta/models/" +
      MODEL_ID +
      ":generateContent?key=" +
      GEMINI_API_KEY;

    const response = await axios.post(
      url,
      {
        contents: [{ parts: [{ text: prompt }] }],
      },
      { headers: { "Content-Type": "application/json" } }
    );

    const aiText =
      response.data?.candidates?.[0]?.content?.parts?.[0]?.text ||
      "Sorry, I couldn't generate an answer right now.";

    return aiText;
  } catch (err) {
    console.error("Gemini Error:", err.response?.data || err.message);
    throw new functions.https.HttpsError(
      "internal",
      "Gemini failed to generate a response."
    );
  }
});

// ---------------------------------------------------------------------------
// 2. Gap Analysis AI + store attempt in user_attempts
// ---------------------------------------------------------------------------
exports.analyzeGap = functions.https.onCall(async (data, context) => {
  let payload = data || {};
  if (payload && payload.question === undefined && payload.data) {
    payload = payload.data;
  }

  const question = payload.question;
  const studentAnswer = payload.studentAnswer;
  const correctAnswer = payload.correctAnswer;
  const language = payload.language || "en";

  const conceptId = payload.conceptId || null;
  const quizId = payload.quizId || null;

  if (!question || !studentAnswer || !correctAnswer) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "question, studentAnswer, and correctAnswer are required"
    );
  }

  const prompt = `
You are an expert STEM teacher.
Analyze the student's answer for the question below.

Question: ${question}
Correct answer / explanation: ${correctAnswer}
Student's answer: ${studentAnswer}

Your job:
1. Decide what kind of mistake this is, using EXACTLY one of:
   - concept_misunderstanding
   - language_issue
   - calculation_error
   - guessing
   - correct
2. Rate their understanding level as: strong, partial, or weak.
3. Give a short explanation of what went wrong (2–3 lines).
4. Suggest a simple recommended action (what they should revise / practice).

Return STRICT JSON ONLY in this format (no extra text, no markdown):

{
  "errorType": "...",
  "understandingLevel": "...",
  "explanation": "...",
  "recommendedAction": "..."
}

Reply in ${language}.
`;

  try {
    const url =
      "https://generativelanguage.googleapis.com/v1beta/models/" +
      MODEL_ID +
      ":generateContent?key=" +
      GEMINI_API_KEY;

    const response = await axios.post(
      url,
      {
        contents: [{ parts: [{ text: prompt }] }],
      },
      { headers: { "Content-Type": "application/json" } }
    );

    const rawText =
      response.data?.candidates?.[0]?.content?.parts?.[0]?.text || "";

    const cleaned = rawText
      .replace(/```json/gi, "")
      .replace(/```/g, "")
      .trim();

    let parsed;
    try {
      parsed = JSON.parse(cleaned);
    } catch (e) {
      return {
        errorType: "unknown",
        understandingLevel: "weak",
        explanation: "AI returned non-JSON response.",
        recommendedAction:
          cleaned || "Ask teacher to review this attempt manually.",
      };
    }

    // ---------- Store attempt in user_attempts ----------
    const userId = context.auth?.uid || "anonymous";

    await db.collection("user_attempts").add({
      userId,
      conceptId,
      quizId,
      question,
      studentAnswer,
      correctAnswer,
      language,
      errorType: parsed.errorType,
      understandingLevel: parsed.understandingLevel,
      createdAt: FieldValue.serverTimestamp(),
    });
    // ----------------------------------------------------

    return parsed;
  } catch (err) {
    console.error(
      "GapAnalysis Gemini Error:",
      err.response?.data || err.message
    );
    throw new functions.https.HttpsError(
      "internal",
      "Gap analysis failed."
    );
  }
});

// ---------------------------------------------------------------------------
// 3. Firestore trigger: update concept_stats on new user_attempt
// ---------------------------------------------------------------------------
exports.onUserAttemptCreate = functions.firestore
  .document("user_attempts/{attemptId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();

    const conceptId = data.conceptId;
    const language = data.language || "en";
    const errorType = data.errorType || "unknown";
    const understandingLevel = data.understandingLevel || "unknown";

    if (!conceptId || !language) {
      console.log("Missing conceptId or language, skipping stats update");
      return;
    }

    const statsDocId = `${conceptId}_${language}`;
    const statsRef = db.collection("concept_stats").doc(statsDocId);

    await statsRef.set(
      {
        conceptId,
        language,
        totalAttempts: FieldValue.increment(1),
        [`errorCounts.${errorType}`]: FieldValue.increment(1),
        [`understandingCounts.${understandingLevel}`]:
          FieldValue.increment(1),
        lastUpdated: FieldValue.serverTimestamp(),
      },
      { merge: true }
    );

    console.log("Updated concept_stats for", statsDocId);
  });
