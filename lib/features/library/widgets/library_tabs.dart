import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class LibraryTabs extends StatelessWidget {
  const LibraryTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: const [
          _TabItem(title: 'All'),
          _TabItem(title: 'Reading'),
          _TabItem(title: 'Saved'),
          _TabItem(title: 'Downloaded'),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;

  const _TabItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
