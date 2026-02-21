import 'package:flutter/material.dart';
import 'chat_screen.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

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
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildActiveUsers(),
              const SizedBox(height: 20),
              const Expanded(child: _FriendList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7B4DFF),
        onPressed: () {},
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: const [
          Text(
            "Friends",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveUsers() {
    final users = ["Aman", "Riya", "Karan", "Sneha", "Dev"];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Color(0xFF7B4DFF)),
                ),
                const SizedBox(height: 6),
                Text(
                  users[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
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
                  friends[index],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
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
                child: const Icon(
                  Icons.chat_bubble_outline,
                  color: Color(0xFF7B4DFF),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}