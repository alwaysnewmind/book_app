import 'package:flutter/material.dart';
import 'package:book_app/features/writer/widgets/writer_header.dart';
import 'package:book_app/features/writer/widgets/writer_actions.dart';



class WriterStats  extends StatelessWidget {
  const WriterStats ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Writer Dashboard'),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WriterHeader(),
              SizedBox(height: 24),
              WriterStats(),
              SizedBox(height: 32),
              WriterActions(),
            ],
          ),
        ),
      ),
    );
  }
}
