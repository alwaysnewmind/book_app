import 'package:book_app/features/book/model/book_model.dart' show BookModel;
import 'package:flutter/material.dart';

class FavoriteBookCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const FavoriteBookCard({
    Key? key,
    required this.book,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  // 🎨 Luxury Color System
  static const Color gold = Color(0xFFF5C84C);
  static const Color goldGlow = Color(0xFFFFD76A);
  static const Color bgTop = Color(0xFF1F1533);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCFC8E8);
  static const Color textMuted = Color(0xFF9F96C8);

  static const Color cardFill = Color(0xFF251A3F);
  static const Color borderInactive = Color(0xFF3A2D5C);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 18),
        decoration: BoxDecoration(
          color: cardFill,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderInactive),
          boxShadow: [
            BoxShadow(
              color: goldGlow.withOpacity(0.10),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// BOOK COVER
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: borderInactive),
                      ),
                      child: Image.asset(
                        book.coverUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  /// FAVORITE ICON
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: bgTop.withOpacity(0.85),
                        boxShadow: [
                          BoxShadow(
                            color: goldGlow.withOpacity(0.30),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.favorite,
                        size: 16,
                        color: gold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// TITLE
              Text(
                book.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              /// AUTHOR
              Text(
                book.authorName,
                style: const TextStyle(
                  fontSize: 12,
                  color: textMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 10),

              /// RATING BAR
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (book.rating / 5).clamp(0, 1),
                  minHeight: 6,
                  backgroundColor: borderInactive,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(gold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}