import 'package:flutter/material.dart';
import 'package:book_app/core/theme/app_colors.dart';

class ProfileMenu extends StatelessWidget {
  final void Function(String route)? onItemTap;

  const ProfileMenu({super.key, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MenuItem(
          icon: Icons.library_books,
          title: 'My Library',
          onTap: () => onItemTap?.call('library'),
        ),
        _MenuItem(
          icon: Icons.edit,
          title: 'Writer Dashboard',
          onTap: () => onItemTap?.call('writer_dashboard'),
        ),
        _MenuItem(
          icon: Icons.settings,
          title: 'Settings',
          onTap: () => onItemTap?.call('settings'),
        ),
        _MenuItem(
          icon: Icons.help_outline,
          title: 'Help & Support',
          onTap: () => onItemTap?.call('help_support'),
        ),
        _MenuItem(
          icon: Icons.logout,
          title: 'Logout',
          onTap: () => onItemTap?.call('logout'),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }
}
