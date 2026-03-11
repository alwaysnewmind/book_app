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
        elevation: 0,
        title: const Text(
          "Earn Money",
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Header
            const Text(
              "Earning Dashboard 💰",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Earn coins by reading books or money by publishing books.",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.lightText,
              ),
            ),

            const SizedBox(height: 30),

            /// READER SECTION
            const Text(
              "Reader Earnings",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),

            const SizedBox(height: 14),

            _earnCard(
              context,
              title: "Earn as Reader",
              subtitle: "Read books and earn coins",
              icon: Icons.menu_book,
              onTap: () {
                Navigator.pushNamed(context, "/reader-earn");
              },
            ),

            _earnCard(
              context,
              title: "Coin Wallet",
              subtitle: "View your coin balance",
              icon: Icons.account_balance_wallet,
              onTap: () {
                Navigator.pushNamed(context, "/coin-wallet");
              },
            ),

            _earnCard(
              context,
              title: "Convert Coins",
              subtitle: "Convert coins into real money",
              icon: Icons.currency_rupee,
              onTap: () {
                Navigator.pushNamed(context, "/convert-coins");
              },
            ),

            const SizedBox(height: 30),

            /// WRITER SECTION
            const Text(
              "Writer Earnings",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),

            const SizedBox(height: 14),

            _earnCard(
              context,
              title: "Earn as Writer",
              subtitle: "Track your book earnings",
              icon: Icons.edit_note,
              onTap: () {
                Navigator.pushNamed(context, "/writer-earn");
              },
            ),

            _earnCard(
              context,
              title: "Withdraw Earnings",
              subtitle: "Transfer money to bank / UPI",
              icon: Icons.account_balance,
              onTap: () {
                Navigator.pushNamed(context, "/withdraw");
              },
            ),

            const SizedBox(height: 30),

            /// INFO BOX
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.amber,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "100 Coins = ₹1. Earn coins by reading books regularly.",
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.lightText,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// EARNING CARD
  static Widget _earnCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [

              /// ICON
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Colors.amber,
                  size: 24,
                ),
              ),

              const SizedBox(width: 14),

              /// TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.lightText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              /// ARROW
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.lightText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}