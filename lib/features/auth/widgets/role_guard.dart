import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:book_app/features/home/home_screen.dart';
import 'package:book_app/services/role_service.dart';
import 'package:book_app/shared/widgets/app_popup.dart';

class WriterAccessGuard extends StatefulWidget {
  const WriterAccessGuard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<WriterAccessGuard> createState() => _WriterAccessGuardState();
}

class _WriterAccessGuardState extends State<WriterAccessGuard> {
  bool _redirected = false;

  Future<bool> _canAccessWriterFeatures() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;

    final role = await RoleService.instance.fetchRole(uid);
    return RoleService.instance.isWriterOrAdmin(role);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _canAccessWriterFeatures(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || snapshot.data != true) {
          if (!_redirected) {
            _redirected = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              showAppPopup(
                context: context,
                title: 'Access denied',
                message: 'Switch to Writer account from Profile to access this feature',
                buttonText: 'OK',
              );
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            });
          }

          return const Scaffold(
            body: SizedBox.shrink(),
          );
        }

        return widget.child;
      },
    );
  }
}
