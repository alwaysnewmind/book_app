import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Small splash delay for UI feel
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      final authProvider =
          Provider.of<AuthProvider>(context, listen: false);

      // Restore session
      await authProvider.checkAuthState();

      if (!mounted) return;

      // 🔥 ROUTING LOGIC

      // 1️⃣ Not logged in
      if (!authProvider.isLoggedIn) {
        Navigator.pushReplacementNamed(context, "/login");
        return;
      }

      // 2️⃣ Logged in but onboarding NOT completed
      if (authProvider.needsOnboarding) {
        Navigator.pushReplacementNamed(context, "/genreSelection");
        return;
      }

      // 3️⃣ Logged in & onboarding completed
      Navigator.pushReplacementNamed(context, "/appShell");

    } catch (e) {
      // Fallback safety
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, "/login");
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
