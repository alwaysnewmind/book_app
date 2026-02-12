import 'package:flutter/material.dart';
import 'package:book_app/shared/widgets/book_card.dart';
import 'package:book_app/data/dummy_books.dart';

class AIRecommendationScreen extends StatelessWidget {
  const AIRecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recommended = dummyBooks.take(6).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text("AI Recommendations"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recommended For You",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Based on your reading behavior & interests",
              style: TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: GridView.builder(
                itemCount: recommended.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final book = recommended[index];

                  return BookCard(
                    imagePath: book.imagePath,
                    title: book.title,
                    author: book.author,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
