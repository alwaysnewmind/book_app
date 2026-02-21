import 'package:flutter/material.dart';

class DiscoverDashboard extends StatelessWidget {
  const DiscoverDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151522), // lighter dark theme
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              /// TITLE
              const Text(
                "Discover",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              /// SEARCH BAR
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF222232),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: const TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.white54),
                    hintText: "Search books, authors, genres...",
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// CATEGORY CHIPS
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _categoryChip("Fantasy", true),
                    _categoryChip("Romance", false),
                    _categoryChip("Self Growth", false),
                    _categoryChip("Business", false),
                    _categoryChip("Poetry", false),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// TRENDING
              const Text(
                "Trending Now 🔥",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              SizedBox(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _BookCard(image: "assets/books/book1.jpg"),
                    _BookCard(image: "assets/books/book2.jpg"),
                    _BookCard(image: "assets/books/book3.jpg"),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// RECOMMENDED
              const Text(
                "Recommended For You",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.7,
                children: const [
                  _BookCard(image: "assets/books/book1.jpg"),
                  _BookCard(image: "assets/books/book2.jpg"),
                  _BookCard(image: "assets/books/book3.jpg"),
                  _BookCard(image: "assets/books/book1.jpg"),
                ],
              ),

              const SizedBox(height: 30),

              /// TOP AUTHORS
              const Text(
                "Top Authors",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              Row(
                children: const [
                  _AuthorAvatar(name: "Author 1"),
                  SizedBox(width: 20),
                  _AuthorAvatar(name: "Author 2"),
                  SizedBox(width: 20),
                  _AuthorAvatar(name: "Author 3"),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

      /// FLOATING BUTTON
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color(0xFF8E2DE2),
              Color(0xFF4A00E0),
            ],
          ),
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {},
          child: const Icon(Icons.explore, color: Colors.white),
        ),
      ),
    );
  }

  static Widget _categoryChip(String text, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF7F5AF0) : const Color(0xFF222232),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

/// BOOK CARD
class _BookCard extends StatelessWidget {
  final String image;

  const _BookCard({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF222232),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

/// AUTHOR AVATAR
class _AuthorAvatar extends StatelessWidget {
  final String name;

  const _AuthorAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundColor: Color(0xFF7F5AF0),
          child: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(color: Colors.white70),
        )
      ],
    );
  }
}