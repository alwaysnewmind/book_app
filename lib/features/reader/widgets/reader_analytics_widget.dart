import 'package:flutter/material.dart';

class ReaderAnalyticsWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const ReaderAnalyticsWidget({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: const [
            Icon(Icons.analytics, color: Color(0xff4A6CF7)),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'View detailed reading analytics',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
