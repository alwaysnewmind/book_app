import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/auth_routes.dart';
import 'core/theme/app_theme.dart';

// ✅ SaaS App Config
import 'config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Initialize App Config (NO domain yet)
  AppConfig.initialize(AppEnvironment.dev);

  // 🔹 Firebase Init
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🌗 Theme System (Design System Applied)
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // 🏁 Entry Point
      home: const SplashScreen(),

      // 🧭 Auth + Future Routes
      routes: authRoutes,
    );
  }
}
