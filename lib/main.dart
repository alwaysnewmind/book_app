import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'config/app_config.dart';
import 'core/theme/app_theme.dart';

/// 🔹 Providers
import 'providers/auth_provider.dart';
import 'providers/reader_provider.dart';
import 'providers/app_settings_provider.dart';
import 'features/library/models/library_store.dart';

/// 🔹 Auth
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/auth_routes.dart';

/// 🔹 Existing Screens
import 'features/book/all_books_screen.dart';
import 'features/library/screens/my_library_screen.dart';
import 'features/profile/downloads_screen.dart';
import 'features/profile/favorites_screen.dart';
import 'features/services/audio_screen.dart';
import 'features/services/challenges_screen.dart';
import 'features/services/feedback_screen.dart';
import 'features/settings/language_selection_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/writer/screens/writer_earnings_screen.dart';
import 'features/category/screens/category_screen.dart';
import 'features/community/screens/community_home_screen.dart';

/// 🔥 NEW HOME ICON DASHBOARDS
import 'features/home/mainicon/discover_dashboard.dart';
import 'features/home/mainicon/premium_dashboard.dart';
import 'features/home/mainicon/offline_vault.dart';
import 'features/home/mainicon/audio_book_dashboard.dart';
import 'features/home/mainicon/content_writing_dashboard.dart';

import 'package:book_app/features/community/screens/community_home_screen.dart';
import 'features/home/mainicon/review_dashboard.dart';
import 'features/home/mainicon/category_dashboard.dart';
import 'features/home/mainicon/book_battle_dashboard.dart';
import 'features/home/mainicon/quotes_dashboard.dart';
import 'features/home/mainicon/help_support.dart';
import 'features/home/mainicon/favorites_dashboard.dart';

/// =======================================================
/// 🔥 CENTRAL ROUTE NAMES
/// =======================================================
class AppRoutes {
  static const splash = "/";

  /// 📚 Reading
  static const read = "/read";
  static const discover = "/discover";

  /// ❤️ Profile
  static const favorites = "/favorites";
  static const downloads = "/downloads";

  /// 📖 Library
  static const library = "/library";

  /// 🎧 Services (Old)
  static const audio = "/audio";
  static const community = "/community";
  static const category = "/category";
  static const challenges = "/challenges";
  static const earn = "/earn";
  static const reviews = "/reviews";

  /// ⚙ Settings
  static const language = "/language";
  static const settings = "/settings";
  static const help = "/help";

  /// ✍ Writer
  static const writer = "/writer";

  /// ===================================================
  /// 🔥 HOME ICON SERVICE DASHBOARDS (NEW)
  /// ===================================================

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
  static const helpSupportDashboard = "/help-support-dashboard";
  static const favoritesDashboard = "/favorites-dashboard";
  static const aiSummaryDashboard = "/ai-summary-dashboard";
  static const monetizeDashboard = "/monetize-dashboard";
  static const storyAnalystDashboard = "/story-analyst-dashboard";
  static const earnAsWriterDashboard = "/earn-as-writer-dashboard";
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.initialize(AppEnvironment.dev);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ReaderProvider()),
        ChangeNotifierProvider(create: (_) => LibraryStore()),
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          /// 🌍 Localization
          locale: settings.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('hi'),
            Locale('gu'),
          ],

          /// 🌗 Theme
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,

          /// 🏁 Initial Route
          initialRoute: AppRoutes.splash,

          /// 🔥 ROUTES
          routes: {
            ...authRoutes,

            /// Splash
            AppRoutes.splash: (_) => const SplashScreen(),

            /// 📚 Reading
            AppRoutes.read: (_) => const AllBooksScreen(),
            AppRoutes.discover: (_) => const AllBooksScreen(),

            /// ❤️ Profile
            AppRoutes.favorites: (_) => const FavoritesScreen(),
            AppRoutes.downloads: (_) => const DownloadsScreen(),

            /// 📖 Library
            AppRoutes.library: (_) => const MyLibraryScreen(),

            /// 🎧 Old Services
            AppRoutes.audio: (_) => const AudioScreen(),
            AppRoutes.community: (_) => const CommunityHomeScreen(),
            AppRoutes.category: (_) => const CategoryScreen(),
            AppRoutes.challenges: (_) => const ChallengesScreen(),
            AppRoutes.earn: (_) => const WriterEarningsScreen(),
            AppRoutes.reviews: (_) => const FeedbackScreen(),

            /// ⚙ Settings
            AppRoutes.language: (_) => const LanguageSelectionScreen(),
            AppRoutes.settings: (_) => const SettingsScreen(),
            AppRoutes.help: (_) => const FeedbackScreen(),
            AppRoutes.writer: (_) => const WriterEarningsScreen(),

            /// ===================================================
            /// 🔥 NEW HOME ICON DASHBOARD ROUTES
            /// ===================================================

            AppRoutes.discoverDashboard: (_) => const DiscoverDashboard(),
            AppRoutes.premiumDashboard: (_) => const PremiumDashboard(),
            AppRoutes.offlineVault: (_) => const OfflineVault(),
            AppRoutes.audioBookDashboard: (_) => const AudioBookDashboard(),
            AppRoutes.contentWritingDashboard: (_) => const ContentWritingDashboard(),
            AppRoutes.communityDashboard: (_) => const CommunityHomeScreen(),
            AppRoutes.reviewDashboard: (_) => const ReviewDashboardScreen(),
            AppRoutes.categoryDashboard: (_) => const CategoryDashboard(),
            AppRoutes.bookBattleDashboard: (_) => const BookBattleDashboard(),
            AppRoutes.quotesDashboard: (_) => const QuotesDashboard(),
            AppRoutes.helpSupportDashboard: (_) => const HelpSupportScreen(),
            AppRoutes.favoritesDashboard: (_) => const FavoritesDashboard(),
          },
        );
      },
    );
  }
}