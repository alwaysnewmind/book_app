import 'package:flutter/material.dart';

class AIVoiceScreen extends StatelessWidget {
  const AIVoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Text("AI Voice Narration"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.headphones, size: 80, color: Colors.amber),
            const SizedBox(height: 20),
            const Text(
              "Listen to this book with AI Voice",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 30),
            Slider(
              value: 0.3,
              onChanged: (_) {},
              activeColor: Colors.amber,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.replay_10, color: Colors.white),
                SizedBox(width: 20),
                Icon(Icons.play_circle_fill,
                    color: Colors.amber, size: 48),
                SizedBox(width: 20),
                Icon(Icons.forward_10, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
