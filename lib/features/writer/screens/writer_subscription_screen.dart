import 'package:flutter/material.dart';

class WriterSubscribersScreen extends StatelessWidget {
  const WriterSubscribersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1A1A),
        elevation: 0,
        title: const Text("Subscribers"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _SubscriberHeroCard(),
            SizedBox(height: 24),
            _SubscriberStatsRow(),
            SizedBox(height: 30),
            _SectionTitle("Recent Subscribers"),
            SizedBox(height: 14),
            _SubscribersList(),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// HERO CARD
////////////////////////////////////////////////////////////

class _SubscriberHeroCard extends StatelessWidget {
  const _SubscriberHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E2E2E),
            Color(0xFF162323),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Total Subscribers",
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 10),
          Text(
            "1,284",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "+18% growth this month",
            style: TextStyle(color: Colors.greenAccent),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// STATS ROW
////////////////////////////////////////////////////////////

class _SubscriberStatsRow extends StatelessWidget {
  const _SubscriberStatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _SubscriberStatCard(
            title: "Free",
            value: "820",
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _SubscriberStatCard(
            title: "Premium",
            value: "464",
          ),
        ),
      ],
    );
  }
}

class _SubscriberStatCard extends StatelessWidget {
  final String title;
  final String value;

  const _SubscriberStatCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF162323),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// SUBSCRIBERS LIST
////////////////////////////////////////////////////////////

class _SubscribersList extends StatelessWidget {
  const _SubscribersList();

  @override
  Widget build(BuildContext context) {
    final subscribers = [
      {
        "name": "Amit Sharma",
        "type": "Premium",
        "date": "Today",
      },
      {
        "name": "Neha Verma",
        "type": "Free",
        "date": "Yesterday",
      },
      {
        "name": "Rahul Mehta",
        "type": "Premium",
        "date": "12 Apr",
      },
      {
        "name": "Sneha Patel",
        "type": "Free",
        "date": "10 Apr",
      },
    ];

    return Column(
      children: subscribers.map((s) {
        final isPremium = s["type"] == "Premium";
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF162323),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    isPremium ? Colors.amber : Colors.blueGrey,
                child: Text(
                  s["name"]![0],
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s["name"]!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s["date"]!,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPremium
                      ? Colors.amber.withOpacity(0.15)
                      : Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  s["type"]!,
                  style: TextStyle(
                    color: isPremium ? Colors.amber : Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

////////////////////////////////////////////////////////////
/// SECTION TITLE
////////////////////////////////////////////////////////////

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
