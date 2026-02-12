import 'package:flutter/material.dart';
import 'package:book_app/core/theme/app_colors.dart';

class WriterActions extends StatelessWidget {
  const WriterActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActionButton(
          icon: Icons.edit_note,
          title: 'Publish New Book',
        ),
        _ActionButton(
          icon: Icons.dashboard_outlined,
          title: 'Writer Dashboard',
        ),
        _ActionButton(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Earnings & Payouts',
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ActionButton({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 14),
        ],
      ),
    );
  }
}
