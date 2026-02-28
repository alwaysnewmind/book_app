import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';

/// 🔥 Providers
import 'providers/auth_provider.dart';
import 'providers/reader_provider.dart';
import 'providers/app_settings_provider.dart';
import 'features/library/models/library_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔧 App Environment
  AppConfig.initialize(AppEnvironment.dev);

  /// 🔥 Firebase init (must before runApp)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const AppRoot());
}

/// 🔥 ROOT WIDGET (Providers separated – best practice)
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<ReaderProvider>(
          create: (_) => ReaderProvider(),
        ),
        ChangeNotifierProvider<LibraryStore>(
          create: (_) => LibraryStore(),
        ),
        ChangeNotifierProvider<AppSettingsProvider>(
          create: (_) => AppSettingsProvider(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsProvider>(
      builder: (_, settings, __) {
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

          /// 🏁 Routing
          initialRoute: AppRoutes.splash,
          routes: AppRoutes.routes,
          onGenerateRoute: AppRoutes.onGenerateRoute, // ✅ REQUIRED
        );
      },
    );
  }
}