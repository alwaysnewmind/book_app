import 'package:flutter/material.dart';

class AudioBookDashboard extends StatelessWidget {
  const AudioBookDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEDE7F6),
              Color(0xFFD1C4E9),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(30),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// TITLE
                    const Text(
                      "Audiobooks",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4527A0),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// SEARCH BAR
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.search,
                              color: Color(0xFF7E57C2)),
                          hintText:
                              "Search audiobooks, narrators...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// FEATURED
                    const Text(
                      "Featured Audiobooks 🎧",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E5F5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 80,
                                width: 80,
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
                                height: 50,
                                width: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Color(0xFF7E57C2),
                                  size: 30,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(width: 15),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Project Hail Mary",
                                  style: TextStyle(
                                      fontWeight:
                                          FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Narrator: Ray Porter\n5h 23m",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "⭐ 4.9",
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// CONTINUE LISTENING
                    const Text(
                      "Continue Listening",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: const [
                        _ContinueCard(),
                        SizedBox(width: 10),
                        _ContinueCard(),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// TRENDING
                    const Text(
                      "Trending Audio",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      height: 150,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
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
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E5F5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(10),
                            child: Image.asset(
                              "assets/books/book1.jpg",
                              height: 45,
                              width: 45,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              "Project Hail Mary\nRay Porter",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          const Icon(Icons.play_arrow,
                              color: Color(0xFF7E57C2)),
                          const SizedBox(width: 10),
                          const Icon(Icons.skip_next,
                              color: Color(0xFF7E57C2)),
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF3E5F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/books/book2.jpg",
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "The Midnight Library",
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: 0.6,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation(
                  Color(0xFF7E57C2)),
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
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              image,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}