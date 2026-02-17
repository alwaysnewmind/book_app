import 'dart:ui';
import 'package:flutter/material.dart';

// reader
import 'package:book_app/features/reader/screens/book_reader_screen.dart';

// library
import 'package:book_app/features/library/models/library_store.dart';
import 'package:book_app/features/library/models/library_book.dart';

class MyLibraryScreen extends StatelessWidget {
  const MyLibraryScreen({super.key});

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
    final List<LibraryBook> books = LibraryStore.books;

    if (books.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "No books in your library yet",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    /// Continue reading = progress > 0 and < 1
    final continueBooks =
        books.where((b) => b.progress > 0 && b.progress < 1).toList();

    /// Most recently added = last item
    final featuredBook = books.last;

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          /// ===============================
          /// APP BAR
          /// ===============================
          const SliverAppBar(
            backgroundColor: Colors.black,
            pinned: true,
            floating: true,
            title: Text("My Library"),
          ),

          /// ===============================
          /// FEATURED BANNER
          /// ===============================
          SliverToBoxAdapter(
            child: _featuredBanner(context, featuredBook),
          ),

          /// ===============================
          /// CONTINUE READING
          /// ===============================
          if (continueBooks.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: _sectionTitle("Continue Reading"),
            ),
            SliverToBoxAdapter(
              child: _horizontalList(context, continueBooks),
            ),
          ],

          /// ===============================
          /// ALL BOOKS
          /// ===============================
          SliverToBoxAdapter(
            child: _sectionTitle("All Books"),
          ),

          SliverToBoxAdapter(
            child: _horizontalList(context, books),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// FEATURED BANNER
  /// ===============================
  Widget _featuredBanner(BuildContext context, LibraryBook book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          _animatedRoute(BookReaderScreen(book: book)),
        );
      },
      child: Container(
        height: 280,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(book.imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [
                Colors.transparent,
                Colors.black87,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Text(
            book.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// ===============================
  /// SECTION TITLE
  /// ===============================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// ===============================
  /// HORIZONTAL BOOK LIST
  /// ===============================
  Widget _horizontalList(
      BuildContext context, List<LibraryBook> books) {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
            child: Container(
              width: 130,
              margin: const EdgeInsets.only(right: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// BOOK COVER
                  Hero(
                    tag: book.imagePath,
                    child: Stack(
                      children: [
                        Container(
                          height: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            image: DecorationImage(
                              image: AssetImage(book.imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        /// Progress Bar Overlay
                        if (book.progress > 0)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: LinearProgressIndicator(
                              value: book.progress,
                              minHeight: 4,
                              backgroundColor: Colors.white30,
                              color: Colors.deepPurple,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// BOOK TITLE
                  Text(
                    book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
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
