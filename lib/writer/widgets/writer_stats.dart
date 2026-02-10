import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class WriterStats extends StatelessWidget {
  const WriterStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _StatItem(title: 'Books', value: '12'),
        _StatItem(title: 'Followers', value: '3.4K'),
        _StatItem(title: 'Earnings', value: '₹8.2K'),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
