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
      backgroundColor: const Color(0xffF3EBFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              /// HEADER
              const SizedBox(height: 10),
              Text(
                "Book Battle ⚔",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff2E1A47),
                    ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Which book wins your vote?",
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 20),

              /// TIMER
              Align(
                alignment: Alignment.centerRight,
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Text(
                    "${secondsLeft}s",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.purple),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// BOOKS SECTION
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
                  const SizedBox(width: 15),
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

              const SizedBox(height: 30),

              /// LIVE RESULT
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Live Vote Results",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 15),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: leftVotePercent,
                        minHeight: 14,
                        backgroundColor: Colors.purple.shade100,
                        valueColor:
                            const AlwaysStoppedAnimation(Colors.purple),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${(leftVotePercent * 100).toInt()}%    ${(rightVotePercent * 100).toInt()}%",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text("Your Voting Streak: 5 🔥"),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// LEADERBOARD
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Leaderboard Preview",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87),
                ),
              ),
              const SizedBox(height: 15),

              LeaderBoardItem(
                name: "Diajch",
                book: "Project Hail Mary",
              ),
              LeaderBoardItem(
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    backgroundColor: Colors.purple,
                  ),
                  child: const Text(
                    "Next Battle →",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// BOOK CARD WIDGET
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            author,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              Text(rating.toString()),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onVote,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text("Vote"),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.purple,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                book,
                style: const TextStyle(color: Colors.black54),
              )
            ],
          )
        ],
      ),
    );
  }
}