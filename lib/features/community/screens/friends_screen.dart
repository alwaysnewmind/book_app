import 'package:flutter/material.dart';
import 'chat_screen.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  // 🎨 LUXURY COLORS
  static const Color primaryBg = Color(0xFF1F1533);
  static const Color gradientMid = Color(0xFF2A1E47);
  static const Color darkDeep = Color(0xFF140F26);

  static const Color goldPrimary = Color(0xFFF5C84C);
  static const Color goldDark = Color(0xFFE6B93E);
  static const Color goldGlow = Color(0xFFFFD76A);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCFC8E8);
  static const Color textMuted = Color(0xFF9F96C8);

  static const Color cardFill = Color(0xFF251A3F);
  static const Color borderInactive = Color(0xFF3A2D5C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryBg,
              gradientMid,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 28),
              _buildActiveUsers(),
              const SizedBox(height: 28),
              const Expanded(child: _FriendList()),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: goldGlow.withOpacity(0.3),
              blurRadius: 18,
              spreadRadius: 1,
            )
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: goldPrimary,
          onPressed: () {},
          child: const Icon(Icons.person_add, color: primaryBg),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        "Friends",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildActiveUsers() {
    final users = ["Aman", "Riya", "Karan", "Sneha", "Dev"];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: goldPrimary, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: goldGlow.withOpacity(0.3),
                        blurRadius: 16,
                      )
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: cardFill,
                    child: Icon(
                      Icons.person,
                      color: goldPrimary,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  users[index],
                  style: const TextStyle(
                    color: textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FriendList extends StatelessWidget {
  const _FriendList();

  static const Color goldPrimary = Color(0xFFF5C84C);
  static const Color goldGlow = Color(0xFFFFD76A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF9F96C8);
  static const Color cardFill = Color(0xFF251A3F);
  static const Color borderInactive = Color(0xFF3A2D5C);
  static const Color primaryBg = Color(0xFF1F1533);

  @override
  Widget build(BuildContext context) {
    final friends = [
      "Aman Verma",
      "Riya Patel",
      "Karan Shah",
      "Sneha Mehta",
      "Dev Joshi",
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            color: cardFill,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderInactive),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: goldPrimary, width: 1.5),
                ),
                child: const CircleAvatar(
                  backgroundColor: cardFill,
                  radius: 24,
                  child: Icon(Icons.person, color: goldPrimary),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  friends[index],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ChatScreen(groupName: friends[index]),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: goldPrimary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: goldGlow.withOpacity(0.3),
                        blurRadius: 14,
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    color: primaryBg,
                    size: 20,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}