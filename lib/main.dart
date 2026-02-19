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

// 🔹 Book
import 'features/book/all_books_screen.dart';

// 🔹 Library
import 'features/library/screens/my_library_screen.dart';

// 🔹 Profile
import 'features/profile/downloads_screen.dart';
import 'features/profile/favorites_screen.dart';

// 🔹 Services
import 'features/services/audio_screen.dart';
import 'features/services/challenges_screen.dart';
import 'features/services/community_screen.dart';
import 'features/services/feedback_screen.dart';

// 🔹 Settings
import 'features/settings/language_selection_screen.dart';
import 'features/settings/screens/settings_screen.dart';

// 🔹 Writer
import 'features/writer/screens/writer_earnings_screen.dart';

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

          /// 🏁 Initial Screen
          home: const SplashScreen(),

          /// 🔥 Routes
          routes: {
            ...authRoutes,

            // 📚 Reading
            "/read": (_) => const AllBooksScreen(),
            "/discover": (_) => const AllBooksScreen(),

            // ❤️ Profile
            "/favorites": (_) => const FavoritesScreen(),
            "/downloads": (_) => const DownloadsScreen(),

            // 📖 Library
            "/library": (_) => const MyLibraryScreen(),

            // 🎧 Services
            "/audio": (_) => const AudioScreen(),
            "/community": (_) => const CommunityScreen(),
            "/challenges": (_) => const ChallengesScreen(),
            "/earn": (_) => const WriterEarningsScreen(),
            "/reviews": (_) => const FeedbackScreen(),

            // ⚙ Settings
            "/language": (_) => const LanguageSelectionScreen(),
            "/settings": (_) => const SettingsScreen(),
            "/help": (_) => const FeedbackScreen(),

            // ✍ Writer
            "/writer": (_) => const WriterEarningsScreen(),
          },
        );
      },
    );
  }
}
