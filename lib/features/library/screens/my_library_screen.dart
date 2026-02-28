import 'package:book_app/core/routes/app_routes.dart' show AppRoutes;
import 'package:book_app/data/dummy_books.dart' show dummyBooks;
import 'package:book_app/features/book/book_reader_screen.dart' show BookReaderScreen;
import 'package:flutter/material.dart';
import 'package:book_app/data/sample_books.dart';
import 'package:provider/provider.dart';
import 'package:book_app/features/library/models/library_store.dart';
import 'package:book_app/features/library/models/library_book.dart';
import 'package:book_app/data/dummy_books.dart';

class MyLibraryScreen extends StatelessWidget {
  const MyLibraryScreen({super.key});

  // 🎨 Luxury Color System
  static const Color bgTop = Color(0xFF1F1533);
  static const Color bgMid = Color(0xFF2A1E47);
  static const Color bgBottom = Color(0xFF140F26);

  static const Color gold = Color(0xFFF5C84C);
  static const Color goldDark = Color(0xFFE6B93E);
  static const Color goldGlow = Color(0xFFFFD76A);

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFCFC8E8);
  static const Color textMuted = Color(0xFF9F96C8);

  static const Color cardFill = Color(0xFF251A3F);
  static const Color borderInactive = Color(0xFF3A2D5C);

  Route _animatedRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<LibraryBook> books = context.watch<LibraryStore>().books;

    if (books.isEmpty) {
      books = dummyBooks.cast<LibraryBook>();
    }

    final continueBooks =
        books.where((b) => b.progress > 0 && b.progress < 1).toList();

    final featuredBook = books.first;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [bgTop, bgMid, bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [

            /// 🔥 APP BAR
            const SliverAppBar(
              backgroundColor: bgTop,
              pinned: true,
              elevation: 0,
              title: Text(
                "My Library",
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: false,
            ),

            /// FEATURED
            SliverToBoxAdapter(
              child: _featuredBanner(context, featuredBook),
            ),

            if (continueBooks.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: _sectionTitle("Continue Reading"),
              ),
              SliverToBoxAdapter(
                child: _horizontalList(context, continueBooks),
              ),
            ],

            SliverToBoxAdapter(
              child: _sectionTitle("All Books"),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final book = books[index];
                    return _gridBookItem(context, book);
                  },
                  childCount: books.length > 16 ? 16 : books.length,
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  childAspectRatio: 0.65,
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 FEATURED BANNER
  Widget _featuredBanner(BuildContext context, LibraryBook book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          _animatedRoute(BookReaderScreen(book: book)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Hero(
          tag: book.id,
          child: Container(
            height: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              image: DecorationImage(
                image: AssetImage(book.imagePath),
                fit: BoxFit.cover,
              ),
              border: Border.all(color: borderInactive),
              boxShadow: [
                BoxShadow(
                  color: goldGlow.withOpacity(0.3),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(22),
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    bgBottom.withOpacity(0.95),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Text(
                book.title,
                style: const TextStyle(
                  color: textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        title,
        style: const TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _gridBookItem(BuildContext context, LibraryBook book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          _animatedRoute(BookReaderScreen(book: book)),
        );
      },
      child: Hero(
        tag: book.id,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage(book.imagePath),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: borderInactive),
            boxShadow: [
              BoxShadow(
                color: goldGlow.withOpacity(0.25),
                blurRadius: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _horizontalList(
      BuildContext context, List<LibraryBook> books) {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                _animatedRoute(BookReaderScreen(book: book)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Stack(
                children: [
                  Hero(
                    tag: book.id,
                    child: Container(
                      width: 135,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        image: DecorationImage(
                          image: AssetImage(book.imagePath),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(color: borderInactive),
                        boxShadow: [
                          BoxShadow(
                            color: goldGlow.withOpacity(0.25),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (book.progress > 0)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(22)),
                        child: LinearProgressIndicator(
                          value: book.progress,
                          minHeight: 6,
                          backgroundColor: borderInactive,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(gold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}