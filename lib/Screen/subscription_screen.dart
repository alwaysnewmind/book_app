import 'package:flutter/material.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose a Plan")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _planCard("Monthly Plan", "₹99 / month"),
            _planCard("Yearly Plan", "₹799 / year"),
          ],
        ),
      ),
    );
  }

  Widget _planCard(String title, String price) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(title),
        subtitle: Text("Unlimited book access"),
        trailing: Text(
          price,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
