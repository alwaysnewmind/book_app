import '../../models/user_model.dart';

enum ContentType {
  free,
  premium, Earnings,
}

class AccessRules {
  /// Can user access this content?
  static bool canAccess({
    required AppUser? user,
    required bool isGuest,
    required ContentType contentType,
  }) {
    // Free content: everyone allowed
    if (contentType == ContentType.free) {
      return true;
    }

    // Premium content rules
    if (contentType == ContentType.premium) {
      // Guest never allowed full access
      if (isGuest) return false;

      // Logged-in premium users allowed
      if (user != null && user.isPremium) {
        return true;
      }

      // Logged-in but not premium
      return false;
    }

    return false;
  }

  /// Should show teaser preview?
  static bool canPreview({
    required AppUser? user,
    required bool isGuest,
    required ContentType contentType,
  }) {
    // Allow teaser for premium content
    if (contentType == ContentType.premium) {
      return true;
    }

    return false;
  }
}
