import 'package:book_app/features/book/provider/book_provider.dart' show BookProvider;
import 'package:book_app/features/home/mainicon/discover%20icon/provider/discover_provider.dart' show DiscoverProvider;
import 'package:book_app/features/home/mainicon/story%20analytics%20icon/provider/story_analytics_provider.dart' show StoryAnalyticsProvider;
import 'package:book_app/features/home/mainicon/story%20analytics%20icon/provider/story_analyzer_provider.dart' show StoryAnalyzerProvider;
import 'package:book_app/features/reader/provider/reader_provider.dart' show ReaderProvider;
import 'package:book_app/features/reader/provider/reader_studio_provider.dart' show ReaderStudioProvider;
import 'package:book_app/features/writer/provider/writer_provider.dart' show WriterProvider;
import 'package:book_app/firebase_options.dart' show DefaultFirebaseOptions;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/app_config.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/auth_wrapper.dart';
import 'features/library/models/library_store.dart';
import 'providers/app_settings_provider.dart';

/// 🔌 Core Providers
import 'package:book_app/features/auth/provider/auth_provider.dart';
import 'providers/comment_provider.dart';
import 'providers/follow_provider.dart';
import 'providers/monetization_provider.dart';
import 'providers/notification_provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔧 App environment
  AppConfig.initialize(AppEnvironment.dev);

  /// 🔥 Firebase init
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  /// 💾 Local storage
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        /// Local storage provider
        Provider<SharedPreferences>.value(value: sharedPreferences),

        /// Auth & Notifications
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
        ),

        /// Providers dependent on NotificationProvider
        ChangeNotifierProxyProvider<NotificationProvider, CommentProvider>(
          create: (context) => CommentProvider(
            notificationProvider: context.read<NotificationProvider>(),
          ),
          update: (context, notifications, _) =>
              CommentProvider(notificationProvider: notifications),
        ),

        ChangeNotifierProxyProvider<NotificationProvider, FollowProvider>(
          create: (context) => FollowProvider(
            notificationProvider: context.read<NotificationProvider>(),
          ),
          update: (context, notifications, _) =>
              FollowProvider(notificationProvider: notifications),
        ),

        ChangeNotifierProxyProvider<NotificationProvider, MonetizationProvider>(
          create: (context) => MonetizationProvider(
            notificationProvider: context.read<NotificationProvider>(),
          ),
          update: (context, notifications, _) =>
              MonetizationProvider(notificationProvider: notifications),
        ),

        /// Core App Providers
        ChangeNotifierProvider(create: (_) => ReaderProvider()),
        ChangeNotifierProvider(create: (_) => ReaderStudioProvider()),
        ChangeNotifierProvider(
          create: (_) => BookProvider()..loadBooks(),
        ),
        ChangeNotifierProvider(create: (_) => StoryAnalyzerProvider()),
        ChangeNotifierProvider(
          create: (_) => DiscoverProvider()..loadDiscoverData(),
        ),
        ChangeNotifierProvider(create: (_) => WriterProvider()),
        ChangeNotifierProvider(create: (_) => StoryAnalyticsProvider()),
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
      builder: (context, settings, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          /// 🌍 Localization
          locale: settings.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('hi'),
            Locale('gu'),
          ],

          /// 🎨 Theme (self-hosted fonts safe)
          theme: AppTheme.darkTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,

          /// 🔐 Auth gate
          home: const AuthWrapper(),

          /// 🚦 Centralized routes
          routes: AppRoutes.routes,
        );
      },
    );
  }
}