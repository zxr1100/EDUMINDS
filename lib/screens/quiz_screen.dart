import 'package:flutter/material.dart';
import 'dart:math' as math;

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

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  bool showResult = false;
  int correctAnswers = 0;
  
  late AnimationController _questionController;
  late AnimationController _optionController;
  late AnimationController _progressController;
  late AnimationController _confettiController;
  late AnimationController _pulseController;

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

  @override
  void initState() {
    super.initState();
    
    _questionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _optionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _questionController.dispose();
    _optionController.dispose();
    _progressController.dispose();
    _confettiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void submitAnswer() {
    if (selectedAnswer == null) return;

    final currentQuestion = questions[currentQuestionIndex];
    final selectedIndex = currentQuestion['options'].indexOf(selectedAnswer);
    final isCorrect = selectedIndex == currentQuestion['correct'];

    if (isCorrect) {
      correctAnswers++;
      _confettiController.forward(from: 0);
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
      
      _questionController.forward(from: 0);
      _optionController.forward(from: 0);
      _progressController.animateTo(
        (currentQuestionIndex + 1) / questions.length,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    final percentage = (correctAnswers / questions.length * 100).round();
    final isPerfect = correctAnswers == questions.length;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              contentPadding: const EdgeInsets.all(32),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Trophy animation
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.elasticOut,
                    builder: (context, double val, child) {
                      return Transform.scale(
                        scale: val,
                        child: Transform.rotate(
                          angle: math.sin(val * math.pi * 2) * 0.1,
                          child: Text(
                            isPerfect ? '🏆' : correctAnswers >= 2 ? '⭐' : '💪',
                            style: const TextStyle(fontSize: 80),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Text(
                    isPerfect ? 'Perfect Score!' : 'Quiz Complete!',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF667eea).withOpacity(0.1),
                          const Color(0xFF764ba2).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$correctAnswers / ${questions.length}',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF667eea),
                          ),
                        ),
                        Text(
                          '$percentage% Correct',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Text(
                    isPerfect
                        ? "Outstanding! You've mastered this topic! 🌟"
                        : correctAnswers >= 2
                            ? "Great job! Keep practicing! 💪"
                            : "Keep learning, you're improving! 📚",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Done button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667eea).withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Done',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Confetti effect
              if (showResult && isCorrect)
                ...List.generate(20, (index) {
                  return AnimatedBuilder(
                    animation: _confettiController,
                    builder: (context, child) {
                      final progress = _confettiController.value;
                      final size = MediaQuery.of(context).size;
                      return Positioned(
                        left: size.width * (index / 20),
                        top: -50 + (progress * size.height * 1.2),
                        child: Opacity(
                          opacity: 1 - progress,
                          child: Transform.rotate(
                            angle: progress * math.pi * 4,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: [
                                  Colors.red,
                                  Colors.blue,
                                  Colors.green,
                                  Colors.yellow,
                                  Colors.pink,
                                ][index % 5],
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),

              Column(
                children: [
                  // Header with glassmorphism
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Question ${currentQuestionIndex + 1}/${questions.length}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF4CAF50).withOpacity(0.5),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                '$correctAnswers/${questions.length}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Animated progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: TweenAnimationBuilder(
                            tween: Tween<double>(
                              begin: currentQuestionIndex / questions.length,
                              end: (currentQuestionIndex + 1) / questions.length,
                            ),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                            builder: (context, double value, child) {
                              return LinearProgressIndicator(
                                value: value,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                minHeight: 8,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Question card
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Question
                          FadeTransition(
                            opacity: _questionController,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.3),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: _questionController,
                                curve: Curves.easeOut,
                              )),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(28),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '❓',
                                      style: const TextStyle(fontSize: 40),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      currentQuestion['question'] as String,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2D3142),
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Options
                          ...(currentQuestion['options'] as List).asMap().entries.map((entry) {
                            final index = entry.key;
                            final option = entry.value as String;
                            final isSelected = selectedAnswer == option;
                            
                            Color? backgroundColor;
                            Color? borderColor;
                            IconData? icon;
                            
                            if (showResult) {
                              if (index == correctIndex) {
                                backgroundColor = const Color(0xFF4CAF50).withOpacity(0.1);
                                borderColor = const Color(0xFF4CAF50);
                                icon = Icons.check_circle;
                              } else if (isSelected && !isCorrect) {
                                backgroundColor = const Color(0xFFFF6584).withOpacity(0.1);
                                borderColor = const Color(0xFFFF6584);
                                icon = Icons.cancel;
                              }
                            } else if (isSelected) {
                              backgroundColor = const Color(0xFF667eea).withOpacity(0.1);
                              borderColor = const Color(0xFF667eea);
                            }

                            return FadeTransition(
                              opacity: _optionController,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(0, 0.2 * (index + 1)),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: _optionController,
                                  curve: Interval(
                                    index * 0.15,
                                    1.0,
                                    curve: Curves.easeOut,
                                  ),
                                )),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: GestureDetector(
                                    onTap: showResult ? null : () {
                                      setState(() {
                                        selectedAnswer = option;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: backgroundColor ?? Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: borderColor ?? Colors.grey[300]!,
                                          width: 2.5,
                                        ),
                                        boxShadow: isSelected || (showResult && index == correctIndex)
                                            ? [
                                                BoxShadow(
                                                  color: (borderColor ?? Colors.grey[300]!).withOpacity(0.3),
                                                  blurRadius: 15,
                                                  offset: const Offset(0, 5),
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: borderColor?.withOpacity(0.2) ?? Colors.grey[200],
                                            ),
                                            child: Center(
                                              child: Text(
                                                String.fromCharCode(65 + index),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
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
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          if (icon != null)
                                            Icon(icon, color: borderColor, size: 28),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),

                          // Gap Analysis Result
                          if (showResult)
                            TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.elasticOut,
                              builder: (context, double value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: isCorrect
                                            ? [
                                                const Color(0xFF4CAF50).withOpacity(0.1),
                                                const Color(0xFF4CAF50).withOpacity(0.05),
                                              ]
                                            : [
                                                const Color(0xFFFF6584).withOpacity(0.1),
                                                const Color(0xFFFF6584).withOpacity(0.05),
                                              ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isCorrect
                                            ? const Color(0xFF4CAF50)
                                            : const Color(0xFFFF6584),
                                        width: 2,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: isCorrect
                                                    ? const Color(0xFF4CAF50)
                                                    : const Color(0xFFFF6584),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                isCorrect ? Icons.check : Icons.close,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              isCorrect ? 'Correct! 🎉' : 'Incorrect',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: isCorrect
                                                    ? const Color(0xFF4CAF50)
                                                    : const Color(0xFFFF6584),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (!isCorrect) ...[
                                          const SizedBox(height: 16),
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.orange.withOpacity(0.3),
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.psychology, color: Colors.orange, size: 24),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    'Gap Type: ${currentQuestion['gapType']} misunderstanding',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.orange,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                        const SizedBox(height: 16),
                                        Text(
                                          currentQuestion['explanation'] as String,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF2D3142),
                                            height: 1.6,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                          const SizedBox(height: 24),

                          // Submit/Next Button
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeOut,
                            builder: (context, double value, child) {
                              return Transform.scale(
                                scale: value,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF667eea).withOpacity(0.4),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: showResult ? nextQuestion : submitAnswer,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 18),
                                        child: Text(
                                          showResult
                                              ? (currentQuestionIndex < questions.length - 1
                                                  ? 'Next Question →'
                                                  : 'Finish Quiz 🎉')
                                              : 'Submit Answer',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}