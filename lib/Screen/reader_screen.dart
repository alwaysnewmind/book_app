import 'package:flutter/material.dart';
import '../models/book_model.dart';

class ReaderScreen extends StatefulWidget {
  final Book book;

  const ReaderScreen({super.key, required this.book});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  int currentPage = 0;

  // 🔹 Dummy book pages (later DB / API / PDF se aayega)
  final List<String> pages = [
    "Chapter 1\n\nThis is the beginning of the journey. "
        "Every soul seeks meaning, and every path starts with a question.",

    "Chapter 2\n\nThe road was long and silent. "
        "Yet within the silence, clarity was born.",

    "Chapter 3\n\nStrength comes not from force, "
        "but from understanding oneself.",

    "Chapter 4\n\nThe end is not an end, "
        "but the beginning of awareness.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 📖 Reading Area
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  pages[currentPage],
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 📊 Progress
            Text(
              "Page ${currentPage + 1} of ${pages.length}",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 12),

            // ⏮️ ⏭️ Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: currentPage > 0
                      ? () {
                          setState(() {
                            currentPage--;
                          });
                        }
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: currentPage < pages.length - 1
                      ? () {
                          setState(() {
                            currentPage++;
                          });
                        }
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
