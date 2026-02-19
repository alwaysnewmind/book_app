import '../../models/user_model.dart';

/// Types of content in app
enum ContentType {
  free,
  premium,        // Reader Premium
  earnings,       // Writer Earnings (requires writer premium)
  writerOnly,     // Writer dashboard access (trial allowed)
  adminOnly,
}

class AccessRules {
  static const int writerTrialDays = 7;

  // =====================================
  // 🔐 Reader Premium Check
  // =====================================
  static bool _hasActiveReaderSubscription(AppUser? user) {
    if (user == null) return false;
    if (!user.isPremium) return false;
    if (user.subscriptionExpiry == null) return false;

    return user.subscriptionExpiry!.isAfter(DateTime.now());
  }

  // =====================================
  // ✍ Writer Trial Check
  // =====================================
  static bool _hasActiveWriterTrial(AppUser? user) {
    if (user == null) return false;

    if (user.writerTrialStart == null) {
      // Trial not started yet → allow access
      return true;
    }

    final difference =
        DateTime.now().difference(user.writerTrialStart!).inDays;

    return difference < writerTrialDays;
  }

  // =====================================
  // ✍ Writer Access Check
  // =====================================
  static bool _canAccessWriter(AppUser? user) {
    if (user == null) return false;

    if (user.isWriterPremium) return true;

    return _hasActiveWriterTrial(user);
  }

  // =====================================
  // 🌍 Main Access Controller
  // =====================================
  static bool canAccess({
    required AppUser? user,
    required bool isGuest,
    required ContentType contentType,
  }) {
    final readerPremium = _hasActiveReaderSubscription(user);
    final writerAccess = _canAccessWriter(user);

    switch (contentType) {
      case ContentType.free:
        return true;

      // 📚 Reader Premium Content
      case ContentType.premium:
        return !isGuest && readerPremium;

      // 💰 Writer Earnings (Require Writer Premium Only)
      case ContentType.earnings:
        return !isGuest &&
            user?.role == UserRole.writer &&
            user!.isWriterPremium;

      // ✍ Writer Dashboard (Trial allowed)
      case ContentType.writerOnly:
        return !isGuest &&
            (user?.role == UserRole.writer ||
                user?.role == UserRole.admin) &&
            writerAccess;

      // 👑 Admin
      case ContentType.adminOnly:
        return !isGuest && user?.role == UserRole.admin;
    }
  }

  // =====================================
  // 👀 Preview Allowed?
  // =====================================
  static bool canPreview(ContentType contentType) {
    return true;
  }
}
