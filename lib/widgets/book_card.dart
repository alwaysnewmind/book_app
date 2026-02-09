import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onTap;
  final bool isLocked;

  const BookCard({
    super.key,
    required this.imagePath,
    this.onTap,
    this.isLocked = false,
  });

  bool get _isAsset => imagePath.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _isAsset
                      ? Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Image.network(
                          imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                ),

                // 🔒 Lock overlay (future use, abhi optional)
                if (isLocked)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(Icons.lock, color: Colors.white, size: 28),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
