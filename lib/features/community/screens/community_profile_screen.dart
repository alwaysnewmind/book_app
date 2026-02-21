import 'package:flutter/material.dart';
import 'chat_screen.dart';

class CommunityProfileScreen extends StatelessWidget {
  final String name;
  final String role;

  const CommunityProfileScreen({
    super.key,
    required this.name,
    required this.role,
  });

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
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30)),
                  ),
                  child: ListView(
                    children: [
                      _buildStats(),
                      const SizedBox(height: 20),
                      _buildBio(),
                      const SizedBox(height: 20),
                      _buildButtons(context),
                      const SizedBox(height: 30),
                      _buildSharedImages(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          child: Icon(Icons.person,
              size: 60, color: Color(0xFF7B4DFF)),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          role,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        _StatItem("120", "Friends"),
        _StatItem("8", "Groups"),
        _StatItem("24", "Books"),
      ],
    );
  }

  Widget _buildBio() {
    return const Text(
      "Passionate reader who loves fantasy and self-growth books. "
      "Always open for book discussions and new recommendations!",
      style: TextStyle(fontSize: 14, color: Colors.black87),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B4DFF),
              padding:
                  const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: () {},
            child: const Text("Add Friend"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                  color: Color(0xFF7B4DFF)),
              padding:
                  const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ChatScreen(groupName: name),
                ),
              );
            },
            child: const Text(
              "Message",
              style: TextStyle(
                  color: Color(0xFF7B4DFF)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSharedImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Shared Photos",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          itemCount: 6,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEDE7FF),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.image,
                color: Color(0xFF7B4DFF),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String number;
  final String label;

  const _StatItem(this.number, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}