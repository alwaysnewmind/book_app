import 'package:flutter/material.dart';

class ReaderStatsGrid extends StatelessWidget {
  const ReaderStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 2.3,
      children: const [
        _StatCard(title: "Coins", value: "450", icon: Icons.monetization_on),
        _StatCard(title: "Earnings", value: "₹1200", icon: Icons.wallet),
        _StatCard(title: "Subscribers", value: "120", icon: Icons.people),
        _StatCard(title: "Completed", value: "18", icon: Icons.check_circle),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Color(0xff4A6CF7)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          )
        ],
      ),
    );
  }
}