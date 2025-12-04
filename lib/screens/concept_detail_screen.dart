import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'quiz_screen.dart';

class ConceptDetailScreen extends StatefulWidget {
  final String subjectName;

  const ConceptDetailScreen({
    Key? key,
    required this.subjectName,
  }) : super(key: key);

  @override
  State<ConceptDetailScreen> createState() => _ConceptDetailScreenState();
}

class _ConceptDetailScreenState extends State<ConceptDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _contentController;
  late AnimationController _floatingController;
  late ScrollController _scrollController;
  
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _headerController.dispose();
    _contentController.dispose();
    _floatingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getConceptData() {
    final concepts = {
      'Physics': {
        'title': 'Newton\'s Laws of Motion',
        'subtitle': 'Understanding Force & Motion',
        'gradient': [const Color(0xFF667eea), const Color(0xFF764ba2)],
        'icon': '⚛️',
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
        'subtitle': 'Chemical Reactions & Electricity',
        'gradient': [const Color(0xFFf093fb), const Color(0xFFf5576c)],
        'icon': '⚗️',
        'content': '''
Electrochemistry is the study of chemical reactions that produce electricity.

Key Concepts:
• Oxidation: Loss of electrons
• Reduction: Gain of electrons
• Electrode: A conductor through which electricity enters or leaves

Example: In a battery, chemical energy is converted to electrical energy through redox reactions.

The Nernst Equation helps calculate cell potential under non-standard conditions.
        ''',
      },
      'Biology': {
        'title': 'Cell Structure and Function',
        'subtitle': 'Building Blocks of Life',
        'gradient': [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
        'icon': '🧬',
        'content': '''
The cell is the basic unit of life. All living organisms are made of cells.

Parts of a Cell:
• Cell Membrane: Controls what enters and exits
• Nucleus: Contains genetic material (DNA)
• Cytoplasm: Jelly-like substance where reactions occur
• Mitochondria: Powerhouse of the cell (produces energy)

Example: Just like your home has rooms for different activities, a cell has organelles for different functions.
        ''',
      },
      'Mathematics': {
        'title': 'Quadratic Equations',
        'subtitle': 'Solving Polynomial Problems',
        'gradient': [const Color(0xFFfa709a), const Color(0xFFfee140)],
        'icon': '📐',
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

    return concepts[widget.subjectName] ?? concepts['Physics']!;
  }

  @override
  Widget build(BuildContext context) {
    final concept = _getConceptData();
    final headerOpacity = (1 - (_scrollOffset / 200)).clamp(0.0, 1.0);
    final headerScale = (1 - (_scrollOffset / 500)).clamp(0.8, 1.0);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: concept['gradient'] as List<Color>,
          ),
        ),
        child: Stack(
          children: [
            // Floating particles in background
            ...List.generate(6, (index) {
              return AnimatedBuilder(
                animation: _floatingController,
                builder: (context, child) {
                  return Positioned(
                    left: 30.0 + (index * 60),
                    top: 100.0 + (math.sin(_floatingController.value * math.pi * 2 + index) * 50),
                    child: Opacity(
                      opacity: 0.15,
                      child: Container(
                        width: 40 + (index * 10.0),
                        height: 40 + (index * 10.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),

            // Main scrollable content
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Animated Header
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: AnimatedBuilder(
                      animation: _headerController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: headerOpacity,
                          child: Transform.scale(
                            scale: headerScale,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 60),
                                  
                                  // Animated icon
                                  TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 0, end: 1),
                                    duration: const Duration(milliseconds: 800),
                                    curve: Curves.elasticOut,
                                    builder: (context, double value, child) {
                                      return Transform.scale(
                                        scale: value,
                                        child: Transform.rotate(
                                          angle: (1 - value) * math.pi * 2,
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.2),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white.withOpacity(0.4),
                                                width: 3,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white.withOpacity(0.3),
                                                  blurRadius: 20,
                                                  spreadRadius: 5,
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                concept['icon'] as String,
                                                style: const TextStyle(fontSize: 50),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  // Title with slide animation
                                  SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.5),
                                      end: Offset.zero,
                                    ).animate(CurvedAnimation(
                                      parent: _headerController,
                                      curve: Curves.easeOut,
                                    )),
                                    child: FadeTransition(
                                      opacity: _headerController,
                                      child: Text(
                                        concept['title'] as String,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 8),
                                  
                                  // Subtitle
                                  FadeTransition(
                                    opacity: _headerController,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        concept['subtitle'] as String,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.95),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Content section
                SliverToBoxAdapter(
                  child: AnimatedBuilder(
                    animation: _contentController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _contentController,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.3),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: _contentController,
                            curve: Curves.easeOut,
                          )),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Drag indicator
                                  Center(
                                    child: Container(
                                      width: 50,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 32),
                                  
                                  // Progress indicators
                                  Row(
                                    children: [
                                      _buildStatCard('📚', 'Topics', '12/15', const Color(0xFF667eea)),
                                      const SizedBox(width: 12),
                                      _buildStatCard('⭐', 'Score', '85%', const Color(0xFFf093fb)),
                                      const SizedBox(width: 12),
                                      _buildStatCard('🔥', 'Streak', '7 days', const Color(0xFF4facfe)),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 32),
                                  
                                  // Content card with glassmorphism
                                  Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: concept['gradient'] as List<Color>,
                                                ),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: const Icon(
                                                Icons.menu_book_rounded,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            const Text(
                                              'Lesson Content',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF2D3142),
                                              ),
                                            ),
                                          ],
                                        ),
                                        
                                        const SizedBox(height: 20),
                                        
                                        Text(
                                          concept['content'] as String,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            height: 1.8,
                                            color: Color(0xFF2D3142),
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  // Action buttons with animation
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: _buildActionButton(
                                          'Take Quiz',
                                          Icons.quiz_rounded,
                                          concept['gradient'] as List<Color>,
                                          true,
                                          () {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context, animation, secondaryAnimation) =>
                                                    QuizScreen(
                                                  subjectName: widget.subjectName,
                                                  conceptTitle: concept['title'] as String,
                                                ),
                                                transitionsBuilder:
                                                    (context, animation, secondaryAnimation, child) {
                                                  var scaleAnimation = Tween<double>(
                                                    begin: 0.8,
                                                    end: 1.0,
                                                  ).animate(CurvedAnimation(
                                                    parent: animation,
                                                    curve: Curves.easeOutCubic,
                                                  ));

                                                  var fadeAnimation = Tween<double>(
                                                    begin: 0.0,
                                                    end: 1.0,
                                                  ).animate(CurvedAnimation(
                                                    parent: animation,
                                                    curve: Curves.easeIn,
                                                  ));

                                                  return ScaleTransition(
                                                    scale: scaleAnimation,
                                                    child: FadeTransition(
                                                      opacity: fadeAnimation,
                                                      child: child,
                                                    ),
                                                  );
                                                },
                                                transitionDuration: const Duration(milliseconds: 500),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _buildActionButton(
                                          'Ask AI',
                                          Icons.chat_bubble_rounded,
                                          [Colors.grey[300]!, Colors.grey[400]!],
                                          false,
                                          () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: const Text('AI Assistant coming soon! 🤖'),
                                                behavior: SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String emoji, String label, String value, Color color) {
    return Expanded(
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
        builder: (context, double val, child) {
          return Transform.scale(
            scale: val,
            child: Opacity(
              opacity: val,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.1),
                      color.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: color.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 8),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    List<Color> gradient,
    bool isPrimary,
    VoidCallback onTap,
  ) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            decoration: BoxDecoration(
              gradient: isPrimary ? LinearGradient(colors: gradient) : null,
              color: isPrimary ? null : gradient[0],
              borderRadius: BorderRadius.circular(16),
              boxShadow: isPrimary
                  ? [
                      BoxShadow(
                        color: gradient[0].withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : [],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: isPrimary ? Colors.white : Colors.grey[700],
                        size: 20,
                      ),
                      if (isPrimary) const SizedBox(width: 8),
                      if (isPrimary)
                        Text(
                          text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}