import 'dart:async';
import 'package:flutter/material.dart';

class BookBattleDashboard extends StatefulWidget {
  const BookBattleDashboard({Key? key}) : super(key: key);

  @override
  State<BookBattleDashboard> createState() => _BookBattleDashboardState();
}

class _BookBattleDashboardState extends State<BookBattleDashboard>
    with TickerProviderStateMixin {
  int secondsLeft = 10;
  double leftVotePercent = 0.58;
  double rightVotePercent = 0.42;

  late Timer _timer;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    startTimer();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() {
          secondsLeft--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _glowController.dispose();
    super.dispose();
  }

  void voteLeft() {
    setState(() {
      leftVotePercent += 0.02;
      rightVotePercent -= 0.02;
    });
  }

  void voteRight() {
    setState(() {
      rightVotePercent += 0.02;
      leftVotePercent -= 0.02;
    });
  }

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                /// HEADER
                const SizedBox(height: 10),
                const Text(
                  "Book Battle ⚔",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Which book wins your vote?",
                  style: TextStyle(
                    color: Color(0xFF9F96C8),
                  ),
                ),

                const SizedBox(height: 24),

                /// TIMER
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF251A3F),
                      border: Border.all(color: const Color(0xFF3A2D5C)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x4DFFD76A),
                          blurRadius: 20,
                        )
                      ],
                    ),
                    child: Text(
                      "${secondsLeft}s",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF5C84C),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// BOOKS
                Row(
                  children: [
                    Expanded(
                      child: BookCard(
                        title: "Project Hail Mary",
                        author: "Andy Weir",
                        rating: 4.8,
                        image: "assets/books/Book1.png",
                        onVote: voteLeft,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: BookCard(
                        title: "The Midnight Library",
                        author: "Matt Haig",
                        rating: 4.7,
                        image: "assets/books/Book2.png",
                        onVote: voteRight,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                /// LIVE RESULT
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF251A3F),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF3A2D5C)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Live Vote Results",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                      const SizedBox(height: 18),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: leftVotePercent,
                          minHeight: 14,
                          backgroundColor: const Color(0xFF3A2D5C),
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFFF5C84C),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${(leftVotePercent * 100).toInt()}%    ${(rightVotePercent * 100).toInt()}%",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFCFC8E8),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        "Your Voting Streak: 5 🔥",
                        style: TextStyle(color: Color(0xFF9F96C8)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                /// LEADERBOARD
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Leaderboard Preview",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const LeaderBoardItem(
                  name: "Diajch",
                  book: "Project Hail Mary",
                ),
                const LeaderBoardItem(
                  name: "Eais",
                  book: "The Midnight Library",
                ),

                const SizedBox(height: 40),

                /// NEXT BATTLE BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5C84C),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      shadowColor: const Color(0xFFDFFD76A),
                      elevation: 8,
                    ),
                    child: const Text(
                      "Next Battle →",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F1533),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// BOOK CARD
class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final double rating;
  final String image;
  final VoidCallback onVote;

  const BookCard({
    Key? key,
    required this.title,
    required this.author,
    required this.rating,
    required this.image,
    required this.onVote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      child: Column(
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
            ),
          ),
          Text(
            author,
            style: const TextStyle(
              color: Color(0xFF9F96C8),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star,
                  color: Color(0xFFF5C84C), size: 16),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: const TextStyle(color: Color(0xFFCFC8E8)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: onVote,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5C84C),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 6,
            ),
            child: const Text(
              "Vote",
              style: TextStyle(
                color: Color(0xFF1F1533),
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// LEADERBOARD ITEM
class LeaderBoardItem extends StatelessWidget {
  final String name;
  final String book;

  const LeaderBoardItem({
    Key? key,
    required this.name,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFF5C84C),
            child: Icon(Icons.person,
                color: Color(0xFF1F1533)),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFFFFF))),
              Text(
                book,
                style: const TextStyle(
                  color: Color(0xFF9F96C8),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}