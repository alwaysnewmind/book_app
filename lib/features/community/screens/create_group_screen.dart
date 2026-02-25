import 'package:flutter/material.dart';
import 'chat_screen.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

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
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              const Expanded(child: _GroupList()),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: goldGlow.withOpacity(0.30),
              blurRadius: 20,
              spreadRadius: 1,
            )
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: goldPrimary,
          onPressed: () {
            _showCreateGroupSheet(context);
          },
          child: const Icon(Icons.group_add, color: bgPrimary),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          Text(
            "Groups",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: textPrimary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateGroupSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: bgPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) {
        return const _CreateGroupSheet();
      },
    );
  }
}

class _GroupList extends StatelessWidget {
  const _GroupList();

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCFC8E8);
  static const Color textMuted = Color(0xFF9F96C8);
  static const Color cardFill = Color(0xFF251A3F);
  static const Color cardBorder = Color(0xFF3A2D5C);
  static const Color goldPrimary = Color(0xFFF5C84C);
  static const Color goldGlow = Color(0xFFFFD76A);
  static const Color bgPrimary = Color(0xFF1F1533);

  @override
  Widget build(BuildContext context) {
    final groups = [
      {
        "name": "Book Lovers",
        "members": "12 Members",
        "lastMsg": "Next week we start new novel!"
      },
      {
        "name": "Fantasy Readers",
        "members": "8 Members",
        "lastMsg": "Chapter 5 discussion tonight 🔥"
      },
      {
        "name": "Writers Hub",
        "members": "15 Members",
        "lastMsg": "Share your drafts here"
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardFill,
            borderRadius: BorderRadius.circular(24),
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
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bgPrimary,
                  border: Border.all(color: cardBorder),
                ),
                child: const Icon(
                  Icons.group,
                  color: goldPrimary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group["name"]!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      group["members"]!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      group["lastMsg"]!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ChatScreen(groupName: "name"),
                    ),
                  );
                },
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: goldPrimary,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _CreateGroupSheet extends StatelessWidget {
  const _CreateGroupSheet();

  static const Color bgPrimary = Color(0xFF1F1533);
  static const Color cardFill = Color(0xFF251A3F);
  static const Color cardBorder = Color(0xFF3A2D5C);
  static const Color goldPrimary = Color(0xFFF5C84C);
  static const Color goldGlow = Color(0xFFFFD76A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCFC8E8);
  static const Color textMuted = Color(0xFF9F96C8);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Create New Group",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            style: const TextStyle(color: textSecondary),
            decoration: InputDecoration(
              labelText: "Group Name",
              labelStyle: const TextStyle(color: textMuted),
              filled: true,
              fillColor: cardFill,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: goldPrimary),
              ),
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            style: const TextStyle(color: textSecondary),
            decoration: InputDecoration(
              labelText: "Description",
              labelStyle: const TextStyle(color: textMuted),
              filled: true,
              fillColor: cardFill,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: goldPrimary),
              ),
            ),
          ),
          const SizedBox(height: 26),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: goldGlow.withOpacity(0.30),
                  blurRadius: 20,
                )
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: goldPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Create Group",
                style: TextStyle(
                  color: bgPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}