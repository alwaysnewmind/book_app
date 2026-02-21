import 'package:flutter/material.dart';

class ReadingRoomScreen extends StatelessWidget {
  final String groupName;

  const ReadingRoomScreen({super.key, required this.groupName});

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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: ListView(
                    children: [
                      _buildCurrentBookCard(),
                      const SizedBox(height: 25),
                      _buildProgressSection(),
                      const SizedBox(height: 25),
                      _buildMembersProgress(),
                      const SizedBox(height: 30),
                      _buildActions(),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Text(
            groupName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentBookCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE7FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            height: 90,
            width: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF7B4DFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.menu_book,
                color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Atomic Habits",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "James Clear",
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Group Progress",
          style:
              TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: 0.6,
            minHeight: 10,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation(
                Color(0xFF7B4DFF)),
          ),
        ),
        const SizedBox(height: 6),
        const Text("60% Completed"),
      ],
    );
  }

  Widget _buildMembersProgress() {
    final members = [
      {"name": "Aman", "progress": 0.8},
      {"name": "Riya", "progress": 0.6},
      {"name": "Karan", "progress": 0.5},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Members Progress",
          style:
              TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ...members.map((member) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member["name"] as String),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: member["progress"] as double,
                    minHeight: 8,
                    backgroundColor:
                        Colors.grey.shade200,
                    valueColor:
                        const AlwaysStoppedAnimation(
                            Color(0xFF7B4DFF)),
                  ),
                ),
              ],
            ),
          );
        }).toList()
      ],
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFF7B4DFF),
              padding:
                  const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(25),
              ),
            ),
            onPressed: () {},
            child: const Text("Start Reading Together"),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
                color: Color(0xFF7B4DFF)),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(25),
            ),
          ),
          onPressed: () {},
          child: const Text(
            "Schedule Session",
            style:
                TextStyle(color: Color(0xFF7B4DFF)),
          ),
        )
      ],
    );
  }
}