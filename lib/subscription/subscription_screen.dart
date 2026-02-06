import 'package:flutter/material.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1A1A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1A1A),
        elevation: 0,
        title: const Text('Go Premium'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔒 Header
            const Text(
              'Unlock Full Access',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Read unlimited books, premium stories & exclusive content.',
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 24),

            // 💎 PLAN 1
            _planCard(
              title: 'Monthly',
              price: '₹99 / month',
              highlight: false,
            ),

            const SizedBox(height: 16),

            // ⭐ PLAN 2 (Recommended)
            _planCard(
              title: 'Yearly',
              price: '₹999 / year',
              highlight: true,
            ),

            const Spacer(),

            // 🚀 CTA BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // 🔜 Payment integration later
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment integration coming soon'),
                    ),
                  );
                },
                child: const Text(
                  'Continue to Payment',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // 🧩 Plan Card Widget
  Widget _planCard({
    required String title,
    required String price,
    required bool highlight,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight ? Colors.white : Colors.white10,
        borderRadius: BorderRadius.circular(16),
        border: highlight
            ? Border.all(color: Colors.amber, width: 2)
            : null,
      ),
      child: Row(
        children: [
          Icon(
            highlight ? Icons.star : Icons.lock,
            color: highlight ? Colors.black : Colors.white,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: highlight ? Colors.black : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                price,
                style: TextStyle(
                  color: highlight ? Colors.black87 : Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
