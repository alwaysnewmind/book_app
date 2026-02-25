import 'package:book_app/core/theme/app_colors.dart';
import 'package:book_app/shared/widgets/animated_tap_wrapper.dart';
import 'package:flutter/material.dart';

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.white),
          ),
          child: Icon(icon, color: AppColors.premiumYellow),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );

    if (onTap == null) return content;

    return AnimatedTapWrapper(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      enableShadow: false,
      child: content,
    );
  }
}
