import 'package:flutter/material.dart';

class FriendRequestsScreen extends StatelessWidget {
  const FriendRequestsScreen({super.key});

  // 🎨 LUXURY COLOR SYSTEM
  static const Color bgPrimary = Color(0xFF1F1533);
  static const Color bgSecondary = Color(0xFF2A1E47);
  static const Color bgDeep = Color(0xFF140F26);

  static const Color goldPrimary = Color(0xFFF5C84C);
  static const Color goldDark = Color(0xFFE6B93E);
  static const Color goldGlow = Color(0xFFFFD76A);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCFC8E8);
  static const Color textMuted = Color(0xFF9F96C8);

  static const Color cardFill = Color(0xFF251A3F);
  static const Color cardBorder = Color(0xFF3A2D5C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPrimary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [bgPrimary, bgSecondary, bgDeep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            children: [
              const Text(
                "Friend Requests",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 30),

              /// Pending Requests
              const Text(
                "Pending Requests",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              _requestCard("Rohan Mehta"),
              _requestCard("Priya Shah"),

              const SizedBox(height: 40),

              /// Suggestions
              const Text(
                "Suggested Readers",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              _suggestionCard("Aman Verma"),
              _suggestionCard("Sneha Patel"),
              _suggestionCard("Dev Joshi"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _requestCard(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardFill,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: cardBorder),
        boxShadow: [
          BoxShadow(
            color: goldGlow.withOpacity(0.05),
            blurRadius: 25,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgPrimary,
              border: Border.all(color: cardBorder),
            ),
            child: const Icon(
              Icons.person,
              color: goldPrimary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: textPrimary,
              ),
            ),
          ),
          _actionButton("Accept", isPrimary: true),
          const SizedBox(width: 10),
          _actionButton("Reject", isPrimary: false),
        ],
      ),
    );
  }

  Widget _suggestionCard(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardFill,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: cardBorder),
        boxShadow: [
          BoxShadow(
            color: goldGlow.withOpacity(0.05),
            blurRadius: 25,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgPrimary,
              border: Border.all(color: cardBorder),
            ),
            child: const Icon(
              Icons.person,
              color: goldPrimary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: textPrimary,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: goldGlow.withOpacity(0.30),
                  blurRadius: 15,
                )
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: goldPrimary,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Text(
                "Add",
                style: TextStyle(
                  color: bgPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _actionButton(String text, {required bool isPrimary}) {
    if (isPrimary) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: goldGlow.withOpacity(0.30),
              blurRadius: 15,
            )
          ],
        ),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: goldPrimary,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: bgPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    } else {
      return Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: cardFill,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: cardBorder),
        ),
        child: const Text(
          "Reject",
          style: TextStyle(
            color: textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }
}