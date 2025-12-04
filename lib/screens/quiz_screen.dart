import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../services/quiz_service.dart';

class QuizScreen extends StatefulWidget {
  final String concept;
  final String language;

  const QuizScreen({
    super.key,
    required this.concept,
    required this.language,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool loading = true;
  List<QuizModel> quizzes = [];
  int currentIndex = 0;
  int? selectedIndex;
  String? feedback;

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    // Here, we map concept name from UI to conceptId in Firestore
    // For now, we hardcode: "Newton's Laws" -> "physics_9_newton_laws"
    String conceptId = "physics_9_newton_laws";

    final result = await QuizService.getQuizzesForConcept(
      conceptId: conceptId,
      lang: widget.language == "Hindi" ? "hi" : "en",
    );

    setState(() {
      quizzes = result;
      loading = false;
    });
  }

  void checkAnswer(int index) {
    final quiz = quizzes[currentIndex];

    setState(() {
      selectedIndex = index;
      if (index == quiz.answerIndex) {
        feedback = "✅ Correct! Great job.";
      } else {
        feedback = "❌ Incorrect. Let's review this concept again.";
      }
    });
  }

  void nextQuestion() {
    if (currentIndex < quizzes.length - 1) {
      setState(() {
        currentIndex++;
        selectedIndex = null;
        feedback = null;
      });
    } else {
      setState(() {
        feedback = "🎉 Quiz finished!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (quizzes.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Quiz • ${widget.concept}")),
        body: const Center(
          child: Text("No quiz available for this concept in this language."),
        ),
      );
    }

    final quiz = quizzes[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Quiz • ${widget.concept}")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Q${currentIndex + 1}/${quizzes.length}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              quiz.question,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            ...List.generate(quiz.options.length, (i) {
              final isSelected = selectedIndex == i;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.indigo.shade50 : Colors.white,
                  border: Border.all(
                    color: isSelected ? Colors.indigo : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () => checkAnswer(i),
                  child: Text(quiz.options[i]),
                ),
              );
            }),
            if (feedback != null) ...[
              const SizedBox(height: 16),
              Text(
                feedback!,
                style: TextStyle(
                  fontSize: 18,
                  color:
                      feedback!.startsWith("✅") ? Colors.green : Colors.red,
                ),
              ),
            ],
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: nextQuestion,
                child: Text(
                    currentIndex == quizzes.length - 1 ? "Finish" : "Next"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
