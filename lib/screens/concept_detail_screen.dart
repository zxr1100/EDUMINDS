import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class ConceptDetailScreen extends StatelessWidget {
  final String subjectName;

  const ConceptDetailScreen({
    Key? key,
    required this.subjectName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample localized content (in real app, this comes from backend)
    final concepts = {
      'Physics': {
        'title': 'Newton\'s Laws of Motion',
        'content': '''
Newton's First Law (Law of Inertia):
An object at rest stays at rest, and an object in motion stays in motion unless acted upon by an external force.

Example: When a cricket ball is hit by a bat, it moves because force is applied. When no force acts on it, it continues moving in the same direction.

Newton's Second Law:
Force = Mass × Acceleration (F = ma)

Example: A heavier cricket ball requires more force to achieve the same speed as a lighter ball.

Newton's Third Law:
For every action, there is an equal and opposite reaction.

Example: When you jump, you push the ground down (action), and the ground pushes you up (reaction).
        ''',
      },
      'Chemistry': {
        'title': 'Electrochemistry Basics',
        'content': '''
Electrochemistry is the study of chemical reactions that produce electricity.

Key Concepts:
- Oxidation: Loss of electrons
- Reduction: Gain of electrons
- Electrode: A conductor through which electricity enters or leaves

Example: In a battery, chemical energy is converted to electrical energy through redox reactions.

The Nernst Equation helps calculate cell potential under non-standard conditions.
        ''',
      },
      'Biology': {
        'title': 'Cell Structure and Function',
        'content': '''
The cell is the basic unit of life. All living organisms are made of cells.

Parts of a Cell:
- Cell Membrane: Controls what enters and exits
- Nucleus: Contains genetic material (DNA)
- Cytoplasm: Jelly-like substance where reactions occur
- Mitochondria: Powerhouse of the cell (produces energy)

Example: Just like your home has rooms for different activities, a cell has organelles for different functions.
        ''',
      },
      'Mathematics': {
        'title': 'Quadratic Equations',
        'content': '''
A quadratic equation is in the form: ax² + bx + c = 0

Methods to Solve:
1. Factorization
2. Quadratic Formula: x = [-b ± √(b²-4ac)] / 2a
3. Completing the square

Example: If x² - 5x + 6 = 0
We can factorize: (x-2)(x-3) = 0
Solutions: x = 2 or x = 3

Real-life use: Calculating the trajectory of a thrown ball, designing bridges, etc.
        ''',
      },
    };

    final concept = concepts[subjectName] ?? concepts['Physics']!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        elevation: 0,
        title: Text(
          subjectName,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF6C63FF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    concept['title'] as String,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '📚 Localized Content',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      concept['content'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizScreen(
                                  subjectName: subjectName,
                                  conceptTitle: concept['title'] as String,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.quiz, color: Colors.white),
                          label: const Text(
                            'Take Quiz',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Navigate to chat screen (we'll create this later)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Doubt-solving feature coming soon!'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text(
                            'Ask Doubt',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF6C63FF),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(
                              color: Color(0xFF6C63FF),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}