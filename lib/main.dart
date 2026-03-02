import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/app_config.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/auth_wrapper.dart';
import 'features/library/models/library_store.dart';
import 'features/premium/presentation/premium_providers.dart';
import 'features/premium/presentation/premium_state.dart';
import 'features/story_analytics/provider/story_analytics_provider.dart';
import 'firebase_options.dart';
import 'providers/app_settings_provider.dart';

/// Providers
import 'providers/auth_provider.dart';
import 'providers/book_provider.dart';
import 'providers/comment_provider.dart';
import 'providers/discover_provider.dart';
import 'providers/follow_provider.dart';
import 'providers/monetization_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/reader_provider.dart';
import 'providers/reader_studio_provider.dart';
import 'providers/story_analyzer_provider.dart';
import 'providers/writer_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.initialize(AppEnvironment.dev);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ChangeNotifierProxyProvider<NotificationProvider, CommentProvider>(
            create: (context) => CommentProvider(
              notificationProvider: context.read<NotificationProvider>(),
            ),
            update: (context, notifications, previous) => CommentProvider(
              notificationProvider: notifications,
            ),
          ),
          ChangeNotifierProxyProvider<NotificationProvider, FollowProvider>(
            create: (context) => FollowProvider(
              notificationProvider: context.read<NotificationProvider>(),
            ),
            update: (context, notifications, previous) => FollowProvider(
              notificationProvider: notifications,
            ),
          ),
          ChangeNotifierProxyProvider<NotificationProvider, MonetizationProvider>(
            create: (context) => MonetizationProvider(
              notificationProvider: context.read<NotificationProvider>(),
            ),
            update: (context, notifications, previous) => MonetizationProvider(
              notificationProvider: notifications,
            ),
          ),
          ChangeNotifierProvider(create: (_) => ReaderProvider()),
          ChangeNotifierProvider(create: (_) => ReaderStudioProvider()),
          ChangeNotifierProvider(create: (_) => BookProvider()..loadBooks()),
          ChangeNotifierProvider(create: (_) => StoryAnalyzerProvider()),
          ChangeNotifierProvider(create: (_) => DiscoverProvider()..loadDiscoverData()),
          ChangeNotifierProvider(create: (_) => WriterProvider()),
          ChangeNotifierProvider(create: (_) => StoryAnalyticsProvider()),
          ChangeNotifierProvider(create: (_) => LibraryStore()),
          ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
        ],
        child: const PremiumSubscriptionBootstrap(child: MyApp()),
      ),
    ),
  );
}

class PremiumSubscriptionBootstrap extends ConsumerWidget {
  final Widget child;

  const PremiumSubscriptionBootstrap({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<PremiumState>(premiumControllerProvider, (_, __) {});
    return child;
  }
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
          theme: AppTheme.darkTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,

          home: const AuthWrapper(),

          /// 🔥 CENTRAL ROUTES
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
