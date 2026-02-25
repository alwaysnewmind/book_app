import 'package:flutter/material.dart';

class ReaderStatsGrid extends StatelessWidget {
  final VoidCallback? onTap;

  const ReaderStatsGrid({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 2.3,
      children: [
        _StatCard(title: "Coins", value: "450", icon: Icons.monetization_on, onTap: onTap),
        _StatCard(title: "Earnings", value: "₹1200", icon: Icons.wallet, onTap: onTap),
        _StatCard(title: "Subscribers", value: "120", icon: Icons.people, onTap: onTap),
        _StatCard(title: "Completed", value: "18", icon: Icons.check_circle, onTap: onTap),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
