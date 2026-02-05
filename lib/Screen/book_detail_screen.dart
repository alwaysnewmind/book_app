import 'package:flutter/material.dart';
import '../models/book_model.dart';
import 'reader_screen.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 📕 Book Cover
            Container(
              height: 240,
              width: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6A5AE0),
                    Color(0xFF3B2DB3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.menu_book,
                size: 80,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            // 📘 Title
            Text(
              book.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            // 👤 Author
            Text(
              "by ${book.author}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 16),

            // ⭐ Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.star, color: Colors.amber, size: 18),
                Icon(Icons.star, color: Colors.amber, size: 18),
                Icon(Icons.star, color: Colors.amber, size: 18),
                Icon(Icons.star_half, color: Colors.amber, size: 18),
                Icon(Icons.star_border, color: Colors.amber, size: 18),
                SizedBox(width: 8),
                Text("3.5"),
              ],
            ),

            const SizedBox(height: 24),

            // 📝 Summary
            Card(
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "This book takes the reader on a deep journey of thought, "
                  "self-realization, and transformation. A must read for "
                  "anyone seeking clarity and growth.",
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🔘 CTA Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReaderScreen(book: book),
                    ),
                  );
                },
                child: Text(
                  book.isPaid ? "Read Free Preview" : "Start Reading",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
