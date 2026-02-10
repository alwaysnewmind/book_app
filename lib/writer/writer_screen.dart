import 'package:flutter/material.dart';
import 'widgets/writer_header.dart';
import 'widgets/writer_stats.dart';
import 'widgets/writer_actions.dart';

class WriterScreen extends StatelessWidget {
  const WriterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Writer'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            WriterHeader(),
            SizedBox(height: 24),
            WriterStats(),
            SizedBox(height: 32),
            WriterActions(),
          ],
        ),
      ),
    );
  }
}
