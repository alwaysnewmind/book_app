import 'package:flutter/material.dart';
import 'dart:math';

class WriterAnalyticsScreen extends StatelessWidget {
  const WriterAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1A1A),
        elevation: 0,
        title: const Text("Analytics"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _EarningsCard(),
            SizedBox(height: 24),
            _StatsRow(),
            SizedBox(height: 30),
            _SectionTitle(title: "Monthly Growth"),
            SizedBox(height: 14),
            _GrowthChart(),
            SizedBox(height: 30),
            _SectionTitle(title: "Top Performing Books"),
            SizedBox(height: 14),
            _TopBooksList(),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// EARNINGS CARD
////////////////////////////////////////////////////////////

class _EarningsCard extends StatelessWidget {
  const _EarningsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E2E2E),
            Color(0xFF162323),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Total Earnings",
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 8),
          Text(
            "₹ 48,250",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "+12% from last month",
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

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _StatCard(title: "Views", value: "12.4K")),
        SizedBox(width: 12),
        Expanded(child: _StatCard(title: "Reads", value: "8.1K")),
        SizedBox(width: 12),
        Expanded(child: _StatCard(title: "Subscribers", value: "1.2K")),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

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
          const SizedBox(height: 4),
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
/// GROWTH CHART (Custom Painted)
////////////////////////////////////////////////////////////

class _GrowthChart extends StatelessWidget {
  const _GrowthChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF162323),
        borderRadius: BorderRadius.circular(18),
      ),
      child: CustomPaint(
        painter: _ChartPainter(),
        child: Container(),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.amber
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    final random = Random(3);

    for (int i = 0; i < 6; i++) {
      final x = size.width / 5 * i;
      final y = random.nextDouble() * size.height * 0.8 + 20;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

////////////////////////////////////////////////////////////
/// TOP BOOKS LIST
////////////////////////////////////////////////////////////

class _TopBooksList extends StatelessWidget {
  const _TopBooksList();

  @override
  Widget build(BuildContext context) {
    final books = [
      {"title": "Dark Mind", "reads": "3.2K"},
      {"title": "Silent Love", "reads": "2.8K"},
      {"title": "Startup Fire", "reads": "2.1K"},
    ];

    return Column(
      children: books.map((book) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF162323),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [Colors.deepPurple, Colors.purpleAccent],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  book["title"]!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Text(
                book["reads"]!,
                style: const TextStyle(color: Colors.white70),
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

  const _SectionTitle({required this.title});

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
