import 'package:flutter/material.dart';

/// 🔥 Auth
import '../../features/auth/screens/splash_screen.dart';

/// 🔥 Reading
import '../../features/book/all_books_screen.dart';

/// 🔥 Settings
import '../../features/settings/screens/settings_screen.dart';
import '../../features/settings/language_selection_screen.dart';

/// 🔥 Writer
import '../../features/writer/screens/writer_earnings_screen.dart';

/// 🔥 Community
import '../../features/community/screens/community_home_screen.dart';

/// 🔥 Home Dashboards
import '../../features/home/mainicon/discover_dashboard.dart';
import '../../features/home/mainicon/premium_dashboard.dart';
import '../../features/home/mainicon/offline_vault.dart';
import '../../features/home/mainicon/audio_book_dashboard.dart';
import '../../features/home/mainicon/content_writing_dashboard.dart';
import '../../features/home/mainicon/review_dashboard.dart';
import '../../features/home/mainicon/category_dashboard.dart';
import '../../features/home/mainicon/book_battle_dashboard.dart';
import '../../features/home/mainicon/quotes_dashboard.dart';
import '../../features/home/mainicon/help_support.dart';
import '../../features/home/mainicon/favorites_dashboard.dart';
import '../../features/auth/screens/auth_entry_screen.dart';
import '../../features/subscription/reader_subscription_screen.dart';

class AppRoutes {
  static const splash = "/";
  static const read = "/read";

  static const discoverDashboard = "/discover-dashboard";
  static const premiumDashboard = "/premium-dashboard";
  static const offlineVault = "/offline-vault";
  static const audioBookDashboard = "/audio-book-dashboard";
  static const contentWritingDashboard = "/content-writing-dashboard";
  static const communityDashboard = "/community-dashboard";
  static const reviewDashboard = "/review-dashboard";
  static const categoryDashboard = "/category-dashboard";
  static const bookBattleDashboard = "/book-battle-dashboard";
  static const quotesDashboard = "/quotes-dashboard";
  static const favoritesDashboard = "/favorites-dashboard";

  static const earn = "/earn";

  static const helpSupportDashboard = "/help-support-dashboard";
  static const language = "/language";
  static const settings = "/settings";
  static const bookDetail = "/bookDetail";

static const login = "/login";
static const subscription = "/subscription";

  /// 🔥 CENTRAL ROUTE MAP
  static Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    read: (_) => const AllBooksScreen(),

    discoverDashboard: (_) => const DiscoverDashboard(),
    premiumDashboard: (_) => const PremiumDashboard(),
    offlineVault: (_) => const OfflineVault(),
    audioBookDashboard: (_) => const AudioBookDashboard(),
    contentWritingDashboard: (_) => const ContentWritingDashboard(),
    communityDashboard: (_) => const CommunityHomeScreen(),
    reviewDashboard: (_) => const ReviewDashboardScreen(),
    categoryDashboard: (_) => const CategoryDashboard(),
    bookBattleDashboard: (_) => const BookBattleDashboard(),
    quotesDashboard: (_) => const QuotesDashboard(),
    favoritesDashboard: (_) => const FavoritesDashboard(),
    earn: (_) => const WriterEarningsScreen(),

    helpSupportDashboard: (_) => const HelpSupportScreen(),
    language: (_) => const LanguageSelectionScreen(),
    settings: (_) => const SettingsScreen(),



    login: (_) => const AuthEntryScreen(),
subscription: (_) => const ReaderSubscriptionScreen(),
  };

}