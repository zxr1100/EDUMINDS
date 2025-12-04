import 'dart:ui';
import 'package:flutter/material.dart';
import 'concept_screen.dart';

class HomeScreen extends StatelessWidget {
  final String language;
  final String studentClass;

  const HomeScreen({
    super.key,
    required this.language,
    required this.studentClass,
  });

  @override
  Widget build(BuildContext context) {
    final concepts = [
      "Newton's Laws",
      "Electricity",
      "Atoms & Molecules",
      "Motion & Force",
    ];

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6C63FF),
              Color(0xFF00B8D9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome 👋",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Colors.white)),
              Text("Learn in $language!",
                  style: const TextStyle(fontSize: 18, color: Colors.white70)),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: concepts.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: glassTile(context, concepts[i]),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget glassTile(BuildContext context, String title) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ConceptScreen(
                  concept: title,
                  language: language,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.science_outlined,
                    size: 36, color: Colors.white),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
