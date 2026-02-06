import 'package:flutter/material.dart';
import 'auth/auth_entry_screen.dart';

void main() {
  runApp(const BookApp());
}

class BookApp extends StatelessWidget {
  const BookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Readora',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const AuthEntryScreen(),
    );
  }
}
