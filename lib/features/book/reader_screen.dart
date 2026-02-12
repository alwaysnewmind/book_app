import 'package:flutter/material.dart';
import 'package:book_app/subscription/reader_subscription_screen.dart';

class ReaderScreen extends StatelessWidget {
  final bool isLocked;

  const ReaderScreen({super.key, required this.isLocked});

  @override
  Widget build(BuildContext context) {
    if (isLocked) {
      // 🚫 Locked → redirect to subscription
      return const SubscriptionScreen();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Reader')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          '📖 Book content starts here...\n\n'
          'This is reader screen.\n'
          'Later API / PDF / text will load here.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
