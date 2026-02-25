import 'package:flutter/material.dart';
import 'dart:math';

class WriterAnalyticsScreen extends StatelessWidget {
  const WriterAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1533),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1533),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Analytics",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFF5C84C)),
      ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _EarningsCard(),
              SizedBox(height: 28),
              _StatsRow(),
              SizedBox(height: 36),
              _SectionTitle(title: "Monthly Growth"),
              SizedBox(height: 16),
              _GrowthChart(),
              SizedBox(height: 36),
              _SectionTitle(title: "Top Performing Books"),
              SizedBox(height: 16),
              _TopBooksList(),
            ],
          ),
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
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3A2D5C)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4DFFD76A),
            blurRadius: 20,
            spreadRadius: 1,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Total Earnings",
            style: TextStyle(
              color: Color(0xFFCFC8E8),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "₹ 48,250",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF5C84C),
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "+12% from last month",
            style: TextStyle(
              color: Color(0xFF9F96C8),
              fontSize: 13,
            ),
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
        SizedBox(width: 14),
        Expanded(child: _StatCard(title: "Reads", value: "8.1K")),
        SizedBox(width: 14),
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
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF5C84C),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFCFC8E8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// GROWTH CHART
////////////////////////////////////////////////////////////

class _GrowthChart extends StatelessWidget {
  const _GrowthChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3A2D5C)),
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
      ..color = const Color(0xFFF5C84C)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    final random = Random(3);

    for (int i = 0; i < 6; i++) {
      final x = size.width / 5 * i;
      final y = random.nextDouble() * size.height * 0.7 + 20;

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
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF251A3F),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF3A2D5C)),
          ),
          child: Row(
            children: [
              Container(
                height: 54,
                width: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF1F1533),
                  border: Border.all(color: const Color(0xFF3A2D5C)),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Color(0xFFF5C84C),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  book["title"]!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                book["reads"]!,
                style: const TextStyle(
                  color: Color(0xFFCFC8E8),
                  fontSize: 13,
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

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: 0.6,
      ),
    );
  }
}