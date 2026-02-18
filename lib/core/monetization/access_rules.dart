import '../../models/user_model.dart';

/// Defines types of content in the app
enum ContentType {
  free,
  premium,
  earnings, // renamed to lowercase for Dart naming consistency
}

class AccessRules {
  /// Check if user can fully access the content
  static bool canAccess({
    required AppUser? user,
    required bool isGuest,
    required ContentType contentType,
  }) {
    switch (contentType) {
      case ContentType.free:
        // Free content: everyone allowed
        return true;

      case ContentType.premium:
        // Guest cannot access premium
        if (isGuest) return false;

        // Logged-in premium users allowed
        return user?.isPremium ?? false;

      case ContentType.earnings:
        // Only premium users (not guests) can access earnings
        if (isGuest) return false;
        return user?.isPremium ?? false;
    }
  }

  /// Should show teaser/preview for content
  static bool canPreview({
    required AppUser? user,
    required bool isGuest,
    required ContentType contentType,
  }) {
    switch (contentType) {
      case ContentType.free:
        return true; // free content always visible

      case ContentType.premium:
      case ContentType.earnings:
        // Teaser available for premium/earnings content
        return true;
    }
  }
}
