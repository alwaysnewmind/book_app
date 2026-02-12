import 'package:flutter/material.dart';

class WriterSubscriptionScreen extends StatelessWidget {
  const WriterSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1A1A),
      appBar: AppBar(
        title: const Text("Writer Plans"),
        backgroundColor: const Color(0xFF0E1A1A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _PlanCard(
              title: "Free Writer",
              price: "₹0 / month",
              highlight: false,
              benefits: [
                "Publish up to 2 books",
                "Standard visibility",
                "30% platform commission",
              ],
            ),
            SizedBox(height: 20),
            _PlanCard(
              title: "Pro Writer",
              price: "₹299 / month",
              highlight: true,
              benefits: [
                "Publish unlimited books",
                "Higher visibility",
                "15% platform commission",
                "Basic analytics",
              ],
            ),
            SizedBox(height: 20),
            _PlanCard(
              title: "Premium Writer Hub",
              price: "₹999 / month",
              highlight: false,
              benefits: [
                "Unlimited books",
                "Featured placement",
                "5% platform commission",
                "Advanced analytics",
                "Priority payouts",
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//
// 💎 PLAN CARD
//

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> benefits;
  final bool highlight;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.benefits,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFF2A3B55) : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: highlight
            ? Border.all(color: Colors.amber, width: 1.2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            price,
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          ...benefits.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.greenAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      b,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    highlight ? Colors.amber : const Color(0xFF334155),
                foregroundColor:
                    highlight ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: Text(
                highlight ? "Upgrade Now" : "Choose Plan",
              ),
            ),
          )
        ],
      ),
    );
  }
}
