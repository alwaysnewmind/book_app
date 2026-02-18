import 'package:flutter/material.dart';
import 'package:book_app/core/theme/app_colors.dart';

class ProfileStats extends StatelessWidget {
  final int booksRead;
  final int saved;
  final int following;
  final void Function(String stat)? onTap;

  const ProfileStats({
    super.key,
    this.booksRead = 0,
    this.saved = 0,
    this.following = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatItem(
          title: 'Books Read',
          value: booksRead.toString(),
          onTap: () => onTap?.call('books_read'),
        ),
        _StatItem(
          title: 'Saved',
          value: saved.toString(),
          onTap: () => onTap?.call('saved'),
        ),
        _StatItem(
          title: 'Following',
          value: following.toString(),
          onTap: () => onTap?.call('following'),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _StatItem({
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
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
      ),
    );
  }
}
