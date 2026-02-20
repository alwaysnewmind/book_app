import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'config/app_config.dart';
import 'core/theme/app_theme.dart';

// 🔹 Providers
import 'providers/auth_provider.dart';
import 'providers/reader_provider.dart';
import 'providers/app_settings_provider.dart';
import 'features/library/models/library_store.dart';

// 🔹 Auth
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/auth_routes.dart';

// 🔹 Screens
import 'features/book/all_books_screen.dart';
import 'features/library/screens/my_library_screen.dart';
import 'features/profile/downloads_screen.dart';
import 'features/profile/favorites_screen.dart';
import 'features/services/audio_screen.dart';
import 'features/services/challenges_screen.dart';
import 'features/services/community_screen.dart';
import 'features/services/feedback_screen.dart';
import 'features/settings/language_selection_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/writer/screens/writer_earnings_screen.dart';

/// =======================================================
/// 🔥 CENTRAL ROUTE NAMES (Single Source of Truth)
/// =======================================================
class AppRoutes {
  static const splash = "/";
  static const read = "/read";
  static const discover = "/discover";
  static const favorites = "/favorites";
  static const downloads = "/downloads";
  static const library = "/library";
  static const audio = "/audio";
  static const community = "/community";
  static const challenges = "/challenges";
  static const earn = "/earn";
  static const reviews = "/reviews";
  static const language = "/language";
  static const settings = "/settings";
  static const help = "/help";
  static const writer = "/writer";
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

            AppRoutes.splash: (_) => const SplashScreen(),

            /// 📚 Reading
            AppRoutes.read: (_) => const AllBooksScreen(),
            AppRoutes.discover: (_) => const AllBooksScreen(),

            /// ❤️ Profile
            AppRoutes.favorites: (_) => const FavoritesScreen(),
            AppRoutes.downloads: (_) => const DownloadsScreen(),

            /// 📖 Library
            AppRoutes.library: (_) => const MyLibraryScreen(),

            /// 🎧 Services
            AppRoutes.audio: (_) => const AudioScreen(),
            AppRoutes.community: (_) => const CommunityScreen(),
            AppRoutes.challenges: (_) => const ChallengesScreen(),
            AppRoutes.earn: (_) => const WriterEarningsScreen(),
            AppRoutes.reviews: (_) => const FeedbackScreen(),

            /// ⚙ Settings
            AppRoutes.language: (_) => const LanguageSelectionScreen(),
            AppRoutes.settings: (_) => const SettingsScreen(),
            AppRoutes.help: (_) => const FeedbackScreen(),

            /// ✍ Writer
            AppRoutes.writer: (_) => const WriterEarningsScreen(),
          },
        );
      },
    );
  }
}