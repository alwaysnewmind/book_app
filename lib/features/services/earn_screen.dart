import 'package:flutter/material.dart';

class EarnPage extends StatelessWidget {
  const EarnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Earn Money")),
      body: const Center(
        child: Text(
          "Track Your Writing Earnings 💰",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
