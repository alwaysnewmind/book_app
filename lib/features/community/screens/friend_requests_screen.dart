import 'package:flutter/material.dart';

class FriendRequestsScreen extends StatelessWidget {
  const FriendRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFC9B6FF),
              Color(0xFF8F6BFF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                "Friend Requests",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              /// Pending Requests
              const Text(
                "Pending Requests",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              _requestCard("Rohan Mehta"),
              _requestCard("Priya Shah"),

              const SizedBox(height: 30),

              /// Suggestions
              const Text(
                "Suggested Readers",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
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
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFF7B4DFF),
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _actionButton("Accept", Colors.green),
          const SizedBox(width: 8),
          _actionButton("Reject", Colors.red),
        ],
      ),
    );
  }

  Widget _suggestionCard(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFF7B4DFF),
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF7B4DFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Add",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _actionButton(String text, Color color) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}