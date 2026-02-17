import 'package:flutter/material.dart';

// 🔐 SaaS Services
import 'package:book_app/services/auth_guard.dart';
import '../../../services/session_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _handleStartup();
  }

  Future<void> _handleStartup() async {
    // splash delay (same as before)
    await Future.delayed(const Duration(seconds: 2));

    // 🔁 Decide where to go
    final destination = await AuthGuard.decide();

    if (!mounted) return;

    switch (destination) {
      case AuthDestination.guestHome:
        await SessionService.saveGuestSession();
        Navigator.pushReplacementNamed(context, '/home');
        break;

      case AuthDestination.userHome:
        Navigator.pushReplacementNamed(context, '/home');
        break;

      case AuthDestination.login:
      Navigator.pushReplacementNamed(context, '/login');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book, size: 80, color: Colors.amber),
            SizedBox(height: 12),
            Text(
              'Reader App',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
