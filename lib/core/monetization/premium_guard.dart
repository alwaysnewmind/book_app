import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'access_rules.dart';
import 'package:book_app/features/subscription/reader_subscription_screen.dart';

/// Wraps content and ensures only allowed users can access it.
/// Shows `lockedView` or default upgrade prompt if user cannot access.
class PremiumGuard extends StatelessWidget {
  final AppUser? user;
  final bool isGuest;
  final ContentType contentType;
  final Widget child;
  final Widget? lockedView;

  const PremiumGuard({
    super.key,
    required this.user,
    required this.isGuest,
    required this.contentType,
    required this.child,
    this.lockedView,
  });

  @override
  Widget build(BuildContext context) {
    final allowed = AccessRules.canAccess(
      user: user,
      isGuest: isGuest,
      contentType: contentType,
    );

    // ✅ Allowed: show child content
    if (allowed) return child;

    // ✅ Custom locked view provided
    if (lockedView != null) return lockedView!;

    // ✅ Default locked view
    return _defaultLockedView(context);
  }

  /// Default locked view for premium content
  Widget _defaultLockedView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline, color: Colors.amber, size: 40),
          const SizedBox(height: 12),
          const Text(
            "Premium Content",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Upgrade to unlock full access",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // 🔗 Navigate to Subscription Screen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ReaderSubscriptionScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Upgrade",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
