import 'package:book_app/core/theme/app_colors.dart';
import 'package:book_app/shared/widgets/animated_tap_wrapper.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const labels = ['Home', 'Writer', 'Library', 'Profile'];
    const icons = [
      Icons.home_outlined,
      Icons.edit_outlined,
      Icons.library_books_outlined,
      Icons.person_outline,
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.92),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: List.generate(labels.length, (index) {
            final isSelected = currentIndex == index;
            return Expanded(
              child: AnimatedTapWrapper(
                onTap: () => onTap(index),
                borderRadius: BorderRadius.circular(20),
                pressedScale: 0.985,
                enableShadow: false,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.premiumYellow.withOpacity(0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icons[index],
                        color: isSelected ? AppColors.white : AppColors.lightText,
                        size: 21,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        labels[index],
                        style: TextStyle(
                          color: isSelected ? AppColors.white : AppColors.lightText,
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
