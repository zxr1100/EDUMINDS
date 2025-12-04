import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Message {
  final String text;
  final bool me;

  Message(this.text, this.me);
}

class ChatScreen extends StatefulWidget {
  final String concept;
  final String language;

  const ChatScreen({
    super.key,
    required this.concept,
    required this.language,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final List<Message> messages = [];
  bool typing = false;

  void send() {
    if (controller.text.trim().isEmpty) return;
    final text = controller.text.trim();
    controller.clear();

    setState(() {
      messages.add(Message(text, true));
      typing = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        typing = false;
        messages.add(Message(
            "This is a simple AI explanation for '${widget.concept}' in ${widget.language}.",
            false));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ask Doubt • ${widget.concept}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: messages.length + (typing ? 1 : 0),
              itemBuilder: (context, i) {
                if (i == messages.length && typing) {
                  return Lottie.asset("assets/lottie/typing.json", height: 40);
                }

                final msg = messages[i];
                return Align(
                  alignment:
                      msg.me ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: msg.me
                          ? const Color(0xFF6C63FF)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                          color: msg.me ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Type your doubt...",
                    border: OutlineInputBorder(),
                  ),
                )),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF6C63FF)),
                  onPressed: send,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
