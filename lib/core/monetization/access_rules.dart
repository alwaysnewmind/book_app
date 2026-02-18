import '../../models/user_model.dart';

/// Types of content in app
enum ContentType {
  free,
  premium,
  earnings,
  writerOnly,
  adminOnly,
}

class AccessRules {
  /// Check if user has active subscription
  static bool _hasActiveSubscription(AppUser? user) {
    if (user == null) return false;
    if (!user.isPremium) return false;

    if (user.subscriptionExpiry == null) return false;

    return user.subscriptionExpiry!.isAfter(DateTime.now());
  }

  /// Full access check
  static bool canAccess({
    required AppUser? user,
    required bool isGuest,
    required ContentType contentType,
  }) {
    final isPremiumActive = _hasActiveSubscription(user);

    switch (contentType) {
      case ContentType.free:
        return true;

      case ContentType.premium:
        return !isGuest && isPremiumActive;

      case ContentType.earnings:
        return !isGuest &&
            user?.role == UserRole.writer &&
            isPremiumActive;

      case ContentType.writerOnly:
        return !isGuest &&
            (user?.role == UserRole.writer ||
                user?.role == UserRole.admin);

      case ContentType.adminOnly:
        return !isGuest && user?.role == UserRole.admin;
    }
  }

  /// Preview allowed?
  static bool canPreview(ContentType contentType) {
    return true;
  }
}
