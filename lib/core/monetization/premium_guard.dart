import 'dart:ui';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';

import '../routes/app_routes.dart';
import 'access_rules.dart';

/// =======================================================
/// PREMIUM / ACCESS GUARD
/// Wrap any premium or restricted content with this widget
/// =======================================================
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

    // ✅ Allowed → show real content
    if (allowed) return child;

    // ✅ If custom locked UI provided
    if (lockedView != null) return lockedView!;

    // ✅ Default blurred lock overlay
    return Stack(
      children: [
        child,

        // Blur effect
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
        ),

        // Lock card
        Center(child: _defaultLockedView(context)),
      ],
    );
  }

  /// =======================================================
  /// DEFAULT LOCKED VIEW
  /// =======================================================
  Widget _defaultLockedView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline, color: Colors.amber, size: 42),
          const SizedBox(height: 12),
          const Text(
            "Premium Content",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Upgrade your plan to unlock full access",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () {
              if (isGuest) {
                Navigator.pushNamed(context, AppRoutes.login);
              } else {
                Navigator.pushNamed(context, AppRoutes.subscription);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              padding:
                  const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              isGuest ? "Login to Continue" : "Upgrade Now",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
