import 'package:flutter/material.dart';
import 'concept_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subjects = [
      {'name': 'Physics', 'icon': '⚛️', 'color': const Color(0xFF6C63FF)},
      {'name': 'Chemistry', 'icon': '⚗️', 'color': const Color(0xFFFF6584)},
      {'name': 'Biology', 'icon': '🧬', 'color': const Color(0xFF4CAF50)},
      {'name': 'Mathematics', 'icon': '📐', 'color': const Color(0xFFFF9800)},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        elevation: 0,
        title: const Text(
          'VidyāBridge',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '🌐 English',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Choose Your Subject',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Start learning in your language',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF9E9E9E),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return SubjectCard(
                    name: subjects[index]['name'] as String,
                    icon: subjects[index]['icon'] as String,
                    color: subjects[index]['color'] as Color,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConceptDetailScreen(
                            subjectName: subjects[index]['name'] as String,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  final String name;
  final String icon;
  final Color color;
  final VoidCallback onTap;

  const SubjectCard({
    Key? key,
    required this.name,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 36),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}