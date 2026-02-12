import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/otp_verify_screen.dart';

final authRoutes = {
  '/login': (context) => const LoginScreen(),
  '/signup': (context) => const SignupScreen(),
  '/otp': (context) => const OtpVerifyScreen(),
};
