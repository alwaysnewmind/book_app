import 'package:flutter/material.dart';

/// A reusable loading widget with optional message
class LoadingState extends StatelessWidget {
  final String? message;
  final Color? indicatorColor;
  final Color? textColor;

  const LoadingState({
    super.key,
    this.message,
    this.indicatorColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: indicatorColor ?? theme.colorScheme.primary,
          ),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor ?? theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
