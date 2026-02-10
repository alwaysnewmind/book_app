import 'package:flutter/material.dart';

class WriterDashboard extends StatelessWidget {
  const WriterDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Writer Dashboard',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
