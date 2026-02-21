import 'dart:ui';
import 'package:flutter/material.dart';

class CommunityHomeScreen extends StatefulWidget {
  const CommunityHomeScreen({super.key});

  @override
  State<CommunityHomeScreen> createState() => _CommunityHomeScreenState();
}

class _CommunityHomeScreenState extends State<CommunityHomeScreen>
    with SingleTickerProviderStateMixin {
  int selectedTab = 1;
  TextEditingController searchController = TextEditingController();

  final List<String> tabs = ["Readers", "Writers", "Common"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildDiscussionButton(),
      backgroundColor: const Color(0xFF8F6BFF),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFC9B6FF), Color(0xFF7B4DFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSegmentedTabs(),
              const SizedBox(height: 15),
              _buildSearchBar(),
              const SizedBox(height: 20),
              Expanded(child: _buildMainCard()),
            ],
          ),
        ),
      ),
    );
  }

  /// HEADER
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Community",
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          Stack(
            children: const [
              CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage("assets/user.jpg"),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: CircleAvatar(
                  radius: 6,
                  backgroundColor: Colors.green,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  /// SEGMENTED TAB
  Widget _buildSegmentedTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(tabs.length, (index) {
          bool isSelected = selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedTab = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color:
                          isSelected ? const Color(0xFF7B4DFF) : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// SEARCH BAR (Unique Feature 🔥)
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Search members or groups...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// MAIN GLASS CARD
  Widget _buildMainCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(40),
            ),
            child: ListView(
              children: [
                const Text(
                  "Readers Active Members",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                _memberCard("Alexia R", "Fantasy Lover", true),
                _memberCard("Rohan Mehta", "Sci-Fi Enthusiast", true),
                _groupCard("Epic Sci-Fi Reads", "120 members"),
                const SizedBox(height: 25),
                const Text(
                  "Readers Groups",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                _joinGroupCard("Epic Sci-Fi Reads", "120 members"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// MEMBER CARD
  Widget _memberCard(String name, String subtitle, bool online) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(radius: 25),
              if (online)
                const Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 6,
                    backgroundColor: Colors.green,
                  ),
                )
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style:
                        const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16)
        ],
      ),
    );
  }

  /// GROUP CARD
  Widget _groupCard(String title, String subtitle) {
    return _memberCard(title, subtitle, true);
  }

  /// JOIN GROUP CARD (Animated Button 🔥)
  Widget _joinGroupCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFF7B4DFF),
            child: Icon(Icons.menu_book, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: const Color(0xFF7B4DFF),
            ),
            child: const Text("Join"),
          )
        ],
      ),
    );
  }

  /// FLOATING DISCUSSION BUTTON
  Widget _buildDiscussionButton() {
    return FloatingActionButton.extended(
      onPressed: () {},
      backgroundColor: Colors.white,
      icon: const Icon(Icons.chat_bubble, color: Color(0xFF7B4DFF)),
      label: const Text(
        "Start Discussion",
        style: TextStyle(color: Color(0xFF7B4DFF)),
      ),
    );
  }
}