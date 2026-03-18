import 'dart:async';

import 'package:book_app/features/book/provider/book_provider.dart' show BookProvider;
import 'package:book_app/features/home/mainicon/discover_icon/provider/discover_provider.dart' show DiscoverProvider;
import 'package:book_app/features/home/mainicon/favorites_icon/provider/favorites_provider.dart' show FavoritesProvider;
import 'package:book_app/features/home/mainicon/premium_icon/services/premium_controller.dart' show PremiumController;
import 'package:book_app/features/home/mainicon/premium_icon/services/premium_remote_service.dart' show PremiumRemoteService;
import 'package:book_app/features/home/mainicon/premium_icon/services/premium_repository.dart' show PremiumRepository;
import 'package:book_app/features/home/mainicon/story_analytics_icon/provider/story_analytics_provider.dart' show StoryAnalyticsProvider;
import 'package:book_app/features/home/mainicon/story_analytics_icon/provider/story_analyzer_provider.dart' show StoryAnalyzerProvider;
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

/// Core Providers
import 'package:book_app/features/auth/provider/auth_provider.dart';
import 'providers/comment_provider.dart';
import 'providers/follow_provider.dart';
import 'providers/monetization_provider.dart';
import 'providers/notification_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Environment config
  AppConfig.initialize(AppEnvironment.dev);

  await _initializeFirebase();

  final sharedPreferences = await SharedPreferences.getInstance();

  /// Global Flutter error handler
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint("Flutter Error: ${details.exception}");
  };

  /// Catch async errors globally
  runZonedGuarded(
    () {
      runApp(MyAppRoot(sharedPreferences: sharedPreferences));
    },
    (error, stack) {
      debugPrint("Unhandled App Error: $error");
      debugPrintStack(stackTrace: stack);
    },
  );
}

class MyAppRoot extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyAppRoot({
    super.key,
    required this.sharedPreferences,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        /// Shared Preferences
        Provider<SharedPreferences>.value(value: sharedPreferences),

        /// Auth
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..initialize(),
          lazy: false,
        ),

        /// Notifications
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
        ),

        /// Proxy Providers
        ChangeNotifierProxyProvider<NotificationProvider, CommentProvider>(
          create: (context) =>
              CommentProvider(notificationProvider: context.read<NotificationProvider>()),
          update: (context, notifications, previous) =>
              CommentProvider(notificationProvider: notifications),
        ),

        ChangeNotifierProxyProvider<NotificationProvider, FollowProvider>(
          create: (context) =>
              FollowProvider(notificationProvider: context.read<NotificationProvider>()),
          update: (context, notifications, previous) =>
              FollowProvider(notificationProvider: notifications),
        ),

        ChangeNotifierProxyProvider<NotificationProvider, MonetizationProvider>(
          create: (context) =>
              MonetizationProvider(notificationProvider: context.read<NotificationProvider>()),
          update: (context, notifications, previous) =>
             MonetizationProvider(notificationProvider: notifications),
        ),

        /// Reader
        ChangeNotifierProvider(create: (_) => ReaderProvider()),
        ChangeNotifierProvider(create: (_) => ReaderStudioProvider()),

        /// Books
        ChangeNotifierProvider(
          create: (_) => BookProvider()..loadBooks(),
        ),

        /// Story AI / Analytics
        ChangeNotifierProvider(create: (_) => StoryAnalyzerProvider()),
        ChangeNotifierProvider(create: (_) => StoryAnalyticsProvider()),

        /// Discover
        ChangeNotifierProvider(
          create: (_) => DiscoverProvider()..loadDiscoverData(),
        ),

        /// Writer
        ChangeNotifierProvider(create: (_) => WriterProvider()),

        /// Favorites
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),

        /// Library
        ChangeNotifierProvider(create: (_) => LibraryStore()),

        /// App Settings
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),

        /// Premium
        ChangeNotifierProvider(
          create: (_) => PremiumController(
            PremiumRepository(
              PremiumRemoteService(),
            ),
          ),
        ),
      ],
      child: const MyApp(),
    );
  }
}

/// Firebase Initialization
Future<void> _initializeFirebase() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 10));
    }
  } catch (e, stack) {
    debugPrint("Firebase init error: $e");
    debugPrintStack(stackTrace: stack);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsProvider>(
      builder: (context, settings, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          /// Localization
          locale: settings.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('hi'),
            Locale('gu'),
          ],

          /// Theme
          theme: AppTheme.darkTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,

          /// Auth Gate
          home: const AuthWrapper(),

          /// Routes
          routes: AppRoutes.routes,
        );
      },
    );
  }
}