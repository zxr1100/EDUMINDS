import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final String subjectName;
  final String conceptTitle;

  const QuizScreen({
    Key? key,
    required this.subjectName,
    required this.conceptTitle,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  bool showResult = false;
  int correctAnswers = 0;

  // Sample quiz questions (in real app, these come from backend)
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Which law states: "An object at rest stays at rest unless acted upon by a force"?',
      'options': [
        'Newton\'s First Law',
        'Newton\'s Second Law',
        'Newton\'s Third Law',
        'Law of Gravity',
      ],
      'correct': 0,
      'gapType': 'conceptual',
      'explanation': 'This is Newton\'s First Law, also called the Law of Inertia. It means objects resist changes in their motion.',
    },
    {
      'question': 'If Force = Mass × Acceleration, what happens when mass increases and force stays the same?',
      'options': [
        'Acceleration increases',
        'Acceleration decreases',
        'Acceleration stays same',
        'Mass becomes zero',
      ],
      'correct': 1,
      'gapType': 'conceptual',
      'explanation': 'When mass increases and force is constant, acceleration must decrease. Think: it\'s harder to push a heavy cart than a light one.',
    },
    {
      'question': 'When you push a wall, why don\'t you move the wall?',
      'options': [
        'The wall pushes back with equal force',
        'The wall is too heavy',
        'There is no reaction force',
        'Friction stops movement',
      ],
      'correct': 0,
      'gapType': 'conceptual',
      'explanation': 'According to Newton\'s Third Law, the wall pushes back with equal force. But the wall is attached to the Earth, so you move instead!',
    },
  ];

  void submitAnswer() {
    if (selectedAnswer == null) return;

    final currentQuestion = questions[currentQuestionIndex];
    final selectedIndex = currentQuestion['options'].indexOf(selectedAnswer);
    final isCorrect = selectedIndex == currentQuestion['correct'];

    if (isCorrect) {
      correctAnswers++;
    }

    setState(() {
      showResult = true;
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        showResult = false;
      });
    } else {
      // Quiz finished
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Quiz Complete! 🎉'),
          content: Text(
            'You got $correctAnswers out of ${questions.length} correct!\n\n'
            '${correctAnswers == questions.length ? "Perfect score! 🌟" : "Keep practicing to improve! 💪"}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to concept screen
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];
    final selectedIndex = selectedAnswer != null
        ? currentQuestion['options'].indexOf(selectedAnswer)
        : -1;
    final correctIndex = currentQuestion['correct'] as int;
    final isCorrect = selectedIndex == correctIndex;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        elevation: 0,
        title: Text(
          'Quiz: ${widget.conceptTitle}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress indicator
            Row(
              children: [
                Text(
                  'Question ${currentQuestionIndex + 1}/${questions.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C63FF),
                  ),
                ),
                const Spacer(),
                Text(
                  'Score: $correctAnswers/${questions.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / questions.length,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
            ),
            const SizedBox(height: 32),

            // Question
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                currentQuestion['question'] as String,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3142),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Options
            Expanded(
              child: ListView.builder(
                itemCount: (currentQuestion['options'] as List).length,
                itemBuilder: (context, index) {
                  final option = currentQuestion['options'][index] as String;
                  final isSelected = selectedAnswer == option;
                  
                  Color? backgroundColor;
                  Color? borderColor;
                  
                  if (showResult) {
                    if (index == correctIndex) {
                      backgroundColor = const Color(0xFF4CAF50).withOpacity(0.1);
                      borderColor = const Color(0xFF4CAF50);
                    } else if (isSelected && !isCorrect) {
                      backgroundColor = const Color(0xFFFF6584).withOpacity(0.1);
                      borderColor = const Color(0xFFFF6584);
                    }
                  } else if (isSelected) {
                    backgroundColor = const Color(0xFF6C63FF).withOpacity(0.1);
                    borderColor = const Color(0xFF6C63FF);
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GestureDetector(
                      onTap: showResult ? null : () {
                        setState(() {
                          selectedAnswer = option;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: backgroundColor ?? Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: borderColor ?? Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: borderColor?.withOpacity(0.2) ?? Colors.grey[200],
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index), // A, B, C, D
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: borderColor ?? Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                option,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF2D3142),
                                ),
                              ),
                            ),
                            if (showResult && index == correctIndex)
                              const Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
                            if (showResult && isSelected && !isCorrect)
                              const Icon(Icons.cancel, color: Color(0xFFFF6584)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Gap Analysis Result
            if (showResult)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCorrect 
                      ? const Color(0xFF4CAF50).withOpacity(0.1)
                      : const Color(0xFFFF6584).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFFF6584),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isCorrect ? Icons.check_circle : Icons.error,
                          color: isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFFF6584),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isCorrect ? 'Correct! 🎉' : 'Incorrect',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFFF6584),
                          ),
                        ),
                      ],
                    ),
                    if (!isCorrect) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.psychology, color: Colors.orange, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Gap Type: ${currentQuestion['gapType']} misunderstanding',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Text(
                      currentQuestion['explanation'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF2D3142),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

            // Submit/Next Button
            ElevatedButton(
              onPressed: showResult ? nextQuestion : submitAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                showResult 
                    ? (currentQuestionIndex < questions.length - 1 ? 'Next Question' : 'Finish Quiz')
                    : 'Submit Answer',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}