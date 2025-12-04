import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_model.dart';

class QuizService {
  static final _db = FirebaseFirestore.instance;

  /// Fetch quizzes for a concept in a given language
  static Future<List<QuizModel>> getQuizzesForConcept({
    required String conceptId,
    required String lang,
  }) async {
    // 1) Get quiz metadata (which quizzes belong to this concept)
    final quizMetaSnap = await _db
        .collection('quizzes')
        .where('conceptId', isEqualTo: conceptId)
        .orderBy('order')
        .get();

    final List<QuizModel> quizzes = [];

    for (final metaDoc in quizMetaSnap.docs) {
      final quizId = metaDoc.id;

      // 2) For each quiz, get the localization for the requested language
      final locSnap = await _db
          .collection('quiz_localizations')
          .where('quizId', isEqualTo: quizId)
          .where('lang', isEqualTo: lang)
          .limit(1)
          .get();

      if (locSnap.docs.isEmpty) continue; // no localization found

      final loc = locSnap.docs.first.data();

      final question = loc['question'] as String;
      final options =
          (loc['options'] as List<dynamic>).map((e) => e.toString()).toList();
      final answerIndex = loc['answerIndex'] as int;

      quizzes.add(
        QuizModel(
          id: quizId,
          conceptId: conceptId,
          question: question,
          options: options,
          answerIndex: answerIndex,
          lang: lang,
        ),
      );
    }

    return quizzes;
  }
}
