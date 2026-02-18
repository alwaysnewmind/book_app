import 'package:book_app/core/monetization/access_rules.dart';
import 'package:flutter/material.dart';
import 'package:book_app/shared/widgets/book_card.dart';
import 'package:book_app/data/dummy_books.dart';
import 'package:book_app/features/book/book_detail_screen.dart';
import 'package:book_app/core/monetization/premium_guard.dart';
import 'package:book_app/models/user_model.dart';

class AIRecommendationScreen extends StatelessWidget {
  final AppUser? currentUser;
  final bool isGuest;

  const AIRecommendationScreen({
    super.key,
    this.currentUser,
    this.isGuest = true,
  });

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

                  return PremiumGuard(
                    user: currentUser,
                    isGuest: isGuest,
                    contentType: book.isPremium
                        ? ContentType.premium
                        : ContentType.free,
                    lockedView: GestureDetector(
                      onTap: () {
                        // Optional: Navigate to subscription screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Upgrade to access this premium book")),
                        );
                      },
                      child: BookCard(book: book),
                    ),
                    child: BookCard(
                      book: book,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookDetailScreen(
                              imagePath: book.coverImage,
                              title: book.title,
                              isLocked: book.isPremium,
                            ),
                          ),
                        );
                      },
                    ),
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
