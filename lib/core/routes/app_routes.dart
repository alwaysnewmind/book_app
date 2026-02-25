import 'package:book_app/features/auth/screens/genre_selection_screen.dart';
import 'package:book_app/features/auth/screens/reader_genre_selection_screen.dart' show ReaderGenreSelectionScreen;
import 'package:book_app/features/auth/screens/signup_screen.dart';
import 'package:book_app/features/auth/screens/writer_genre_selection_screen.dart' show WriterGenreSelectionScreen;

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

/// 🔥 Subscription
import '../../features/subscription/reader_subscription_screen.dart';

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
import 'package:book_app/features/auth/screens/login_screen.dart';

class AppRoutes {
  /// 🔥 Initial Routes
  static const String  splash = "/";
  static const String login = "/login";
  static const String home = '/home';
  static const String signup = '/signup';
  static const String genreSelection ="/genreselection";
  static const String appShell = "/appshell";
  static const String bookDetail ="/bookdetail";
  static const String subscription = "/subscription";
   static const readerGenres = '/readergenres';
  static const writerGenres = '/writergenres';
  static const profileUpload = '/profileupload';
  static const readerDashboard = '/readerdashboard';
  static const writerDashboard = '/writerdashboard';

  /// 🔥 Reading
  static const read = "/read";

  /// 🔥 Dashboards
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

  /// 🔥 Writer
  static const earn = "/earn";

  /// 🔥 Settings
  static const helpSupportDashboard = "/help-support-dashboard";
  static const language = "/language";
  static const settings = "/settings";

  /// 🔥 CENTRAL ROUTE MAP
  static final Map<String, WidgetBuilder> routes = {
    /// Auth Flow
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),
    genreSelection: (_) => const RoleSelectionScreen(), // 👈 ADD
    readerGenres: (_) => const ReaderGenreSelectionScreen(),
    writerGenres: (_) => const WriterGenreSelectionScreen(),

    
    subscription: (_) => const ReaderSubscriptionScreen(),

    /// Reading
    read: (_) => const AllBooksScreen(),

    /// Dashboards
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

    /// Writer
    earn: (_) => const WriterEarningsScreen(),

    /// Settings
    helpSupportDashboard: (_) => const HelpSupportScreen(),
    language: (_) => const LanguageSelectionScreen(),
    settings: (_) => const SettingsScreen(),
  };
}