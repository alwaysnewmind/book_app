import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _MenuItem(icon: Icons.library_books, title: 'My Library'),
        _MenuItem(icon: Icons.edit, title: 'Writer Dashboard'),
        _MenuItem(icon: Icons.settings, title: 'Settings'),
        _MenuItem(icon: Icons.help_outline, title: 'Help & Support'),
        _MenuItem(icon: Icons.logout, title: 'Logout'),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _MenuItem({
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
