import 'package:book_app/core/monetization/access_rules.dart';
import 'package:flutter/material.dart';
import 'package:book_app/core/monetization/premium_guard.dart';
import 'package:book_app/models/user_model.dart';
import 'package:book_app/features/subscription/reader_subscription_screen.dart';

class AISummaryScreen extends StatelessWidget {
  final String bookTitle;
  final AppUser? currentUser;
  final bool isGuest;

  const AISummaryScreen({
    super.key,
    required this.bookTitle,
    this.currentUser,
    this.isGuest = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text("AI Summary"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bookTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            /// 📖 Summary Block
            PremiumGuard(
              user: currentUser,
              isGuest: isGuest,
              contentType: ContentType.premium,
              lockedView: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.workspace_premium, color: Colors.amber),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "AI Summary is available for Premium Readers.",
                            style: TextStyle(color: Colors.amber),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReaderSubscriptionScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        "Upgrade",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  "This AI-generated summary will help readers quickly "
                  "understand the key insights, themes, and core ideas "
                  "of the book in under 3 minutes.",
                  style: TextStyle(
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
