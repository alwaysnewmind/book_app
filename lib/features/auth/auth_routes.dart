import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/otp_verify_screen.dart';

final Map<String, WidgetBuilder> authRoutes = {
  '/login': (BuildContext context) => const LoginScreen(),
  '/signup': (BuildContext context) => const SignupScreen(),
  '/otp': (BuildContext context) => const OtpVerifyScreen(),
};
