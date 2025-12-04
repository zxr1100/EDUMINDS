import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(const VidyaBridgeApp());
}

class VidyaBridgeApp extends StatelessWidget {
  const VidyaBridgeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VidyāBridge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        fontFamily: 'Roboto',
      ),
      home: const OnboardingScreen(),
    );
  }
}