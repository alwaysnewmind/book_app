import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_app/core/theme/app_colors.dart';
import 'package:book_app/models/user_model.dart';
import 'package:book_app/providers/auth_provider.dart';

import 'package:book_app/features/subscription/reader_subscription_screen.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final AppUser? user = authProvider.user;
    final bool isGuest = authProvider.isGuest;

    final bool isPremiumActive =
        user?.hasActiveSubscription ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundImage: user?.photoUrl != null
                ? NetworkImage(user!.photoUrl!)
                : const AssetImage('assets/profile/user.png')
                    as ImageProvider,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? "Guest User",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isGuest
                      ? "Guest"
                      : user?.role.name.toUpperCase() ?? "Reader",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),

                /// 🔥 PREMIUM BADGE AREA
                if (isPremiumActive)
                  _buildPremiumBadge()
                else
                  _buildUpgradeButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 👑 GOLD PREMIUM BADGE
  Widget _buildPremiumBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.amber, Colors.orange],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium,
              size: 16, color: Colors.white),
          SizedBox(width: 6),
          Text(
            "PREMIUM",
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 🚀 Upgrade Button
  Widget _buildUpgradeButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ReaderSubscriptionScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.amber),
        ),
        child: const Text(
          "Upgrade to Premium →",
          style: TextStyle(
            color: Colors.amber,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
