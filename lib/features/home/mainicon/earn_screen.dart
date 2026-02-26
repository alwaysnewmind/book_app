import 'package:flutter/material.dart';
import 'package:book_app/core/theme/app_colors.dart';

class EarnPage extends StatelessWidget {
  const EarnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.cardDark,
        title: const Text(
          "Earn Money",
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.monetization_on,
                size: 60,
                color: Colors.amber,
              ),
              SizedBox(height: 20),
              Text(
                "Track Your Writing Earnings 💰",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "All your earnings, referrals, and payouts will appear here.",
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
