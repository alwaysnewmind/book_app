import 'package:flutter/material.dart';
import 'package:book_app/core/theme/app_colors.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.cardDark,
        title: const Text(
          "Favorites",
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                size: 60,
                color: Colors.redAccent,
              ),
              SizedBox(height: 20),
              Text(
                "Your Favorite Books ❤️",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "All books you marked as favorite will appear here.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.lightText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
