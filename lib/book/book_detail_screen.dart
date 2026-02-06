import 'package:flutter/material.dart';
import 'reader_screen.dart';

class BookDetailScreen extends StatelessWidget {
  final String imagePath;
  final String title;
  final bool isLocked;

  const BookDetailScreen({
    super.key,
    required this.imagePath,
    required this.title,
    this.isLocked = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(imagePath, height: 220, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              isLocked
                  ? 'This book is premium. Subscribe to read full content.'
                  : 'Free to read',
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReaderScreen(isLocked: isLocked),
                    ),
                  );
                },
                child: Text(isLocked ? 'Subscribe & Read' : 'Read Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
