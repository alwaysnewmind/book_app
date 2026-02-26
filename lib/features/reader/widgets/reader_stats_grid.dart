import 'package:book_app/features/reader/controller/reader_controller.dart';
import 'package:book_app/features/reader/widgets/reader_stats_card.dart';
import 'package:flutter/material.dart';

class ReaderStatsGrid extends StatelessWidget {
  final ReaderController controller;
  final VoidCallback? onTap;

  const ReaderStatsGrid({
    super.key,
    required this.controller,
    this.onTap,
  });

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
        ReaderStatsCard(
          title: 'Coins',
          value: controller.coins.toString(),
          icon: Icons.monetization_on,
          onTap: onTap,
        ),
        ReaderStatsCard(
          title: 'XP',
          value: controller.xp.toString(),
          icon: Icons.bolt,
          onTap: onTap,
        ),
        ReaderStatsCard(
          title: 'Streak',
          value: '${controller.streak} days',
          icon: Icons.local_fire_department,
          onTap: onTap,
        ),
        ReaderStatsCard(
          title: 'Completed',
          value: controller.completedBooks.toString(),
          icon: Icons.check_circle,
          onTap: onTap,
        ),
      ],
    );
  }
}
