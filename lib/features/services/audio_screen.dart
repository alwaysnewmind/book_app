import 'package:flutter/material.dart';
import 'package:book_app/core/theme/app_colors.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.cardDark,
        title: const Text(
          "Audio Books",
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: const Center(
        child: Text(
          "Audio Books Coming Soon",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
