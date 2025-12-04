import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'quiz_screen.dart';
import 'chat_screen.dart';

class ConceptScreen extends StatefulWidget {
  final String concept;
  final String language;

  const ConceptScreen({
    super.key,
    required this.concept,
    required this.language,
  });

  @override
  State<ConceptScreen> createState() => _ConceptScreenState();
}

class _ConceptScreenState extends State<ConceptScreen> {
  bool loading = true;
  String explanation = "";

  @override
  void initState() {
    super.initState();
    loadContent();
  }

  void loadContent() async {
    await Future.delayed(const Duration(seconds: 2)); // fake load
    setState(() {
      explanation =
          "${widget.concept} explained in simple ${widget.language}.\n\nThis content will be AI localized later.";
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.concept)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: loading
            ? Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 25, width: 200, color: Colors.grey),
                    const SizedBox(height: 16),
                    Container(height: 18, width: double.infinity, color: Colors.grey),
                    const SizedBox(height: 10),
                    Container(height: 18, width: double.infinity, color: Colors.grey),
                    const SizedBox(height: 10),
                    Container(height: 18, width: 250, color: Colors.grey),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Chip(label: Text(widget.language)),
                    const SizedBox(height: 14),
                    Text(explanation, style:
                      const TextStyle(fontSize: 16)),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.chat),
                label: const Text("Ask Doubt"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        concept: widget.concept,
                        language: widget.language,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.quiz),
                label: const Text("Take Quiz"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(
                        concept: widget.concept,
                        language: widget.language,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
