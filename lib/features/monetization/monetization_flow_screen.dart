import 'package:flutter/material.dart';

class MonetizationFlowScreen extends StatelessWidget {
  const MonetizationFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Text("Revenue Model"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _FlowSection(),
            SizedBox(height: 30),
            _RevenueSplitCard(),
            SizedBox(height: 30),
            _ExampleCalculationCard(),
          ],
        ),
      ),
    );
  }
}

//
// 🔁 FLOW VISUAL SECTION
//

class _FlowSection extends StatelessWidget {
  const _FlowSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: const [
          Text(
            "How Money Flows",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          _FlowRow(
            icon: Icons.person,
            label: "Reader Pays Subscription",
          ),
          SizedBox(height: 10),
          Icon(Icons.arrow_downward, color: Colors.white54),
          SizedBox(height: 10),
          _FlowRow(
            icon: Icons.account_balance,
            label: "Platform Receives Payment",
          ),
          SizedBox(height: 10),
          Icon(Icons.arrow_downward, color: Colors.white54),
          SizedBox(height: 10),
          _FlowRow(
            icon: Icons.edit,
            label: "Writer Gets Revenue Share",
          ),
        ],
      ),
    );
  }
}

class _FlowRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FlowRow({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

//
// 💵 REVENUE SPLIT CARD
//

class _RevenueSplitCard extends StatelessWidget {
  const _RevenueSplitCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Revenue Split",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _SplitRow(title: "Platform Share", value: "30%"),
          SizedBox(height: 8),
          _SplitRow(title: "Writer Share", value: "70%"),
        ],
      ),
    );
  }
}

class _SplitRow extends StatelessWidget {
  final String title;
  final String value;

  const _SplitRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

//
// 📊 EXAMPLE CALCULATION
//

class _ExampleCalculationCard extends StatelessWidget {
  const _ExampleCalculationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Example Calculation",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "If 1,000 readers buy ₹199 plan:",
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 8),
          Text(
            "Total Revenue = ₹1,99,000",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 6),
          Text(
            "Platform (30%) = ₹59,700",
            style: TextStyle(color: Colors.amber),
          ),
          SizedBox(height: 6),
          Text(
            "Writers (70%) = ₹1,39,300",
            style: TextStyle(color: Colors.greenAccent),
          ),
        ],
      ),
    );
  }
}
