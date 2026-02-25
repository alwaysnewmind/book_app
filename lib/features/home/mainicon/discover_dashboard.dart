import 'package:flutter/material.dart';

class DiscoverDashboard extends StatelessWidget {
  const DiscoverDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1533),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1F1533),
              Color(0xFF2A1E47),
              Color(0xFF140F26),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 24),

                /// TITLE
                const Text(
                  "Discover",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF),
                  ),
                ),

                const SizedBox(height: 24),

                /// SEARCH BAR
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF251A3F),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFF3A2D5C)),
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color(0xFFFFD76A).withOpacity(0.08),
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18),
                  child: const TextField(
                    style: TextStyle(color: Color(0xFFFFFFFF)),
                    decoration: InputDecoration(
                      icon: Icon(Icons.search,
                          color: Color(0xFFCFC8E8)),
                      hintText:
                          "Search books, authors, genres...",
                      hintStyle: TextStyle(
                          color: Color(0xFF9F96C8)),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// CATEGORY CHIPS
                SizedBox(
                  height: 42,
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

                const SizedBox(height: 32),

                /// TRENDING
                const Text(
                  "Trending Now 🔥",
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  height: 220,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      _BookCard(image: "assets/books/Book1.jpg"),
                      _BookCard(image: "assets/books/Book2.jpg"),
                      _BookCard(image: "assets/books/Book3.jpg"),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                /// RECOMMENDED
                const Text(
                  "Recommended For You",
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  childAspectRatio: 0.7,
                  children: const [
                    _BookCard(image: "assets/books/Book1.jpg"),
                    _BookCard(image: "assets/books/Book2.jpg"),
                    _BookCard(image: "assets/books/Book3.jpg"),
                    _BookCard(image: "assets/books/Book1.jpg"),
                  ],
                ),

                const SizedBox(height: 32),

                /// TOP AUTHORS
                const Text(
                  "Top Authors",
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: const [
                    _AuthorAvatar(name: "Author 1"),
                    SizedBox(width: 24),
                    _AuthorAvatar(name: "Author 2"),
                    SizedBox(width: 24),
                    _AuthorAvatar(name: "Author 3"),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),

      /// FLOATING BUTTON (Premium Gold)
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD76A)
                  .withOpacity(0.30),
              blurRadius: 25,
              spreadRadius: 2,
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFF5C84C),
          elevation: 0,
          onPressed: () {},
          child: const Icon(
            Icons.explore,
            color: Color(0xFF1F1533),
          ),
        ),
      ),
    );
  }

  /// CATEGORY CHIP
  static Widget _categoryChip(
      String text, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFF5C84C)
              : const Color(0xFF251A3F),
          borderRadius:
              BorderRadius.circular(22),
          border:
              Border.all(color: const Color(0xFF3A2D5C)),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFD76A)
                        .withOpacity(0.30),
                    blurRadius: 18,
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: selected
                ? const Color(0xFF1F1533)
                : const Color(0xFFCFC8E8),
            fontWeight: FontWeight.w500,
          ),
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
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: const Color(0xFF3A2D5C)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD76A)
                .withOpacity(0.08),
            blurRadius: 20,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(24),
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
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: const Color(0xFF3A2D5C)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD76A)
                    .withOpacity(0.10),
                blurRadius: 15,
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 30,
            backgroundColor:
                Color(0xFF251A3F),
            child: Icon(
              Icons.person,
              color: Color(0xFFF5C84C),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xFFCFC8E8),
            fontSize: 13,
          ),
        )
      ],
    );
  }
}