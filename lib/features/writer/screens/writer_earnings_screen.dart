import 'package:flutter/material.dart';

class WriterEarningsScreen extends StatelessWidget {
  const WriterEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1533),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1533),
        elevation: 0,
        title: const Text(
          "Earnings",
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
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _TotalEarningsCard(),
              SizedBox(height: 26),
              _StatsRow(),
              SizedBox(height: 36),
              Text(
                "Recent Transactions",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
              SizedBox(height: 16),
              _TransactionsList(),
            ],
          ),
        ),
      ),
    );
  }
}

//
// 💎 TOTAL EARNINGS CARD
//

class _TotalEarningsCard extends StatelessWidget {
  const _TotalEarningsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFF3A2D5C)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4DFFD76A),
            blurRadius: 22,
            spreadRadius: 1,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Earnings",
            style: TextStyle(
              color: Color(0xFFCFC8E8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "₹ 12,450",
            style: TextStyle(
              color: Color(0xFFF5C84C),
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5C84C),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x4DFFD76A),
                    blurRadius: 18,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Withdraw Earnings",
                  style: TextStyle(
                    color: Color(0xFF1F1533),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

//
// 📊 STATS ROW
//

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatCard(
            title: "This Month",
            value: "₹ 3,200",
          ),
        ),
        SizedBox(width: 18),
        Expanded(
          child: _StatCard(
            title: "Total Sales",
            value: "186",
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF9F96C8),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFF5C84C),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

//
// 📄 TRANSACTIONS LIST
//

class _TransactionsList extends StatelessWidget {
  const _TransactionsList();

  @override
  Widget build(BuildContext context) {
    final transactions = [
      {"title": "Book Sale - Soul Journey", "amount": "+ ₹199"},
      {"title": "Book Sale - Inner Power", "amount": "+ ₹149"},
      {"title": "Withdrawal", "amount": "- ₹1000"},
    ];

    return Column(
      children: transactions.map((tx) {
        final isCredit = tx["amount"]!.contains("+");

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF251A3F),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF3A2D5C)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  tx["title"]!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                tx["amount"]!,
                style: TextStyle(
                  color: isCredit
                      ? const Color(0xFFF5C84C)
                      : const Color(0xFFE6B93E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}