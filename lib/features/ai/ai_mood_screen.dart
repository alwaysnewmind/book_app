import 'package:flutter/material.dart';

class AIMoodScreen extends StatelessWidget {
  const AIMoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moods = ["Motivated", "Calm", "Anxious", "Focused", "Spiritual"];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Text("Choose Your Mood"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: moods
              .map(
                (mood) => Chip(
                  label: Text(mood),
                  backgroundColor: const Color(0xFF1E293B),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
