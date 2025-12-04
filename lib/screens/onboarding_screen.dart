import 'package:flutter/material.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String selectedClass = '9';
  String selectedLanguage = 'English';

  final List<String> classes = ['8', '9', '10'];
  final List<String> languages = ['English', 'हिंदी (Hindi)', 'ಕನ್ನಡ (Kannada)'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Logo/Title
              const Text(
                '🎓 VidyāBridge',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C63FF),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Welcome to STEM Learning',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF9E9E9E),
                ),
              ),
              const SizedBox(height: 60),

              // Select Class
              const Text(
                'Select Your Class',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  value: selectedClass,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: classes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text('Class $value'),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedClass = newValue!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Select Language
              const Text(
                'Select Your Language',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  value: selectedLanguage,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: languages.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLanguage = newValue!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 48),

              // Start Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Let's Start Learning! 🚀",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}