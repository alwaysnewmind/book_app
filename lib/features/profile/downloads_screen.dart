import 'package:flutter/material.dart';
import 'package:book_app/features/library/models/library_store.dart';
import 'package:book_app/features/library/models/library_book.dart';
import 'package:book_app/features/reader/screens/book_reader_screen.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  Route _animatedRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<LibraryBook> downloadedBooks =
        LibraryStore.instance.book.where((b) => b.downloaded).toList();

    /// ================= EMPTY STATE =================
    if (downloadedBooks.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F5F7),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.download_done_rounded,
                  size: 60, color: Color(0xFF7F5AF0)),
              SizedBox(height: 16),
              Text(
                "No downloaded books yet",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    /// ================= MAIN UI =================
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: Column(
        children: [

          /// ===== Purple Header =====
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 24),
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF7F5AF0),
                  Color(0xFF6246EA),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
            ),
            child: const Center(
              child: Text(
                "Downloaded Books",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          /// ===== Grid Section =====
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 18),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: downloadedBooks.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.62,
                ),
                itemBuilder: (context, index) {
                  final book = downloadedBooks[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        _animatedRoute(BookReaderScreen(book: book)),
                      );
                    },
                    child: Hero(
                      tag: "download_${book.id}",
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Stack(
                            children: [

                              /// Book Image
                              Positioned.fill(
                                child: Image.asset(
                                  book.imagePath,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              /// Download Badge
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.download_done,
                                    size: 14,
                                    color: Color(0xFF7F5AF0),
                                  ),
                                ),
                              ),

                              /// Progress Bar
                              if (book.progress > 0)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: ClipRRect(
                                    borderRadius:
                                        const BorderRadius.vertical(
                                            bottom: Radius.circular(18)),
                                    child: LinearProgressIndicator(
                                      value: book.progress,
                                      minHeight: 5,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.6),
                                      color: const Color(0xFF6246EA),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
