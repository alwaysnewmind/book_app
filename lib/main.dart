import 'package:book_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'config/app_config.dart';
import 'core/theme/app_theme.dart';

// 🔹 Auth
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/auth_routes.dart';

// 🔹 Providers
import 'providers/reader_provider.dart';
import 'providers/app_settings_provider.dart';
import 'features/library/models/library_store.dart';

// 🔹 Feature Screens (Correct Folder Based Imports)

// Book
import 'features/book/all_books_screen.dart';

// Library
import 'features/library/screens/my_library_screen.dart';

// Profile
import 'features/profile/downloads_screen.dart';
import 'features/profile/favorites_screen.dart';

// AI
import 'features/ai/ai_summary_screen.dart';

// Services
import 'features/services/audio_screen.dart';
import 'features/services/challenges_screen.dart';
import 'features/services/community_screen.dart';
import 'features/services/earn_screen.dart';
import 'features/services/premium_screen.dart';
import 'features/services/feedback_screen.dart';

// Settings
import 'features/settings/language_selection_screen.dart';
import 'features/settings/screens/settings_screen.dart';

// Writer
import 'features/writer/screens/writer_screen.dart';

// Discover → using AllBooksScreen
// Reviews → using feedback_screen
// Premium → premium_screen
// Read Books → all_books_screen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.initialize(AppEnvironment.dev);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReaderProvider()),
        ChangeNotifierProvider(create: (_) => LibraryStore()),
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
        ChangeNotifierProvider<AuthProvider>(create: (_)=> AuthProvider(),)
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

          // 🌍 Language Support
          locale: settings.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('hi'),
            Locale('gu'),
          ],

          // 🌗 Theme
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,

          // 🏁 Start
          home: const SplashScreen(),

          // 🔥 ALL HOME SERVICE ROUTES REGISTERED
          routes: {
            ...authRoutes,

            "/read": (_) => const AllBooksScreen(),
            "/discover": (_) => const AllBooksScreen(),

            "/favorites": (_) => const FavoritesScreen(),
            "/downloads": (_) => const DownloadsScreen(),
            "/library": (_) => const MyLibraryScreen(),
            "/audio": (_) => const AudioScreen(),

            "/community": (_) => const CommunityScreen(),
            "/challenges": (_) => const ChallengesScreen(),
            "/reviews": (_) => const FeedbackScreen(),
            "/language": (_) => const LanguageSelectionScreen(),
            "/settings": (_) => const SettingsScreen(),
            "/help": (_) => const FeedbackScreen(),
          },
        );
      },
    );
  }
}
