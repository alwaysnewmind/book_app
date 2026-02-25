import 'package:flutter/material.dart';

class AudioBookDashboard extends StatelessWidget {
  const AudioBookDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1533),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1F1533),
              Color(0xFF2A1E47),
              Color(0xFF140F26),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF251A3F),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFF3A2D5C)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x4DFFD76A), // 30% glow
                    blurRadius: 25,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// TITLE
                    const Text(
                      "Audiobooks",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// SEARCH BAR
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF251A3F),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFF3A2D5C)),
                      ),
                      child: const TextField(
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                        decoration: InputDecoration(
                          icon: Icon(Icons.search,
                              color: Color(0xFFF5C84C)),
                          hintText:
                              "Search audiobooks, narrators...",
                          hintStyle: TextStyle(
                              color: Color(0xFF9F96C8)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// FEATURED
                    const Text(
                      "Featured Audiobooks 🎧",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF251A3F),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF3A2D5C)),
                      ),
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 85,
                                width: 85,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(20),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/books/book1.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                height: 55,
                                width: 55,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFF5C84C),
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Color(0xFF1F1533),
                                  size: 30,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(width: 18),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Project Hail Mary",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Narrator: Ray Porter\n5h 23m",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9F96C8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5C84C),
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "⭐ 4.9",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F1533),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// CONTINUE LISTENING
                    const Text(
                      "Continue Listening",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Row(
                      children: [
                        _ContinueCard(),
                        SizedBox(width: 14),
                        _ContinueCard(),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// TRENDING
                    const Text(
                      "Trending Audio",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      height: 165,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        children: const [
                          _TrendingCard(
                              image: "assets/books/book1.jpg",
                              title: "Dune"),
                          _TrendingCard(
                              image: "assets/books/book2.jpg",
                              title: "Educated"),
                          _TrendingCard(
                              image: "assets/books/book3.jpg",
                              title: "Circe"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// MINI PLAYER
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF251A3F),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF3A2D5C)),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(12),
                            child: Image.asset(
                              "assets/books/book1.jpg",
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Text(
                              "Project Hail Mary\nRay Porter",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFCFC8E8),
                              ),
                            ),
                          ),
                          const Icon(Icons.play_arrow,
                              color: Color(0xFFF5C84C)),
                          SizedBox(width: 12),
                          const Icon(Icons.skip_next,
                              color: Color(0xFFF5C84C)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// CONTINUE CARD
class _ContinueCard extends StatelessWidget {
  const _ContinueCard();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF251A3F),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFF3A2D5C)),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/books/book2.jpg",
                height: 65,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "The Midnight Library",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFCFC8E8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const LinearProgressIndicator(
                value: 0.6,
                backgroundColor: Color(0xFF3A2D5C),
                valueColor: AlwaysStoppedAnimation(
                    Color(0xFFF5C84C)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// TRENDING CARD
class _TrendingCard extends StatelessWidget {
  final String image;
  final String title;

  const _TrendingCard({
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              image,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFCFC8E8),
            ),
          )
        ],
      ),
    );
  }
}