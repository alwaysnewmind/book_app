import 'package:book_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/routes/app_routes.dart';
import 'package:book_app/navigation/app_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  Future<void> _initialize() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      final authProvider = context.read<AuthProvider>();

      await authProvider.initialize(); // ✅ use initialize()

      if (!mounted) return;

      /// 1️⃣ Not Logged In
      if (!authProvider.isLoggedIn) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.login,
        );
        return;
      }

      final user = authProvider.currentUser;

      /// 2️⃣ Safety Check
      if (user == null) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.login,
        );
        return;
      }

      /// 3️⃣ Role NOT selected
      if (user.role == null) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.genreSelection,
        );
        return;
      }

      /// 4️⃣ Onboarding NOT completed
      if (authProvider.needsOnboarding) {
        if (user.role == UserRole.reader) {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.readerGenres,
          );
        } else {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.writerGenres,
          );
        }
        return;
      }

      /// 5️⃣ Everything OK → Go to App
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AppShell(), // ✅ FIXED
        ),
      );
    } catch (e) {
      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.login,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Image(
                  image: AssetImage("assets/image/Mythica.png"),
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Mythica",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 24),
              CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}