import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(const VidyaBridgeApp());
}

class VidyaBridgeApp extends StatelessWidget {
  const VidyaBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "VidyāBridge",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const OnboardingScreen(),
    );
  }
}
