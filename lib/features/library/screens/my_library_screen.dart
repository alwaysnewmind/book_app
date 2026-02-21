import 'dart:ui';
import 'package:book_app/core/routes/app_routes.dart' show AppRoutes;
import 'package:book_app/data/dummy_books.dart' show dummyBooks;
import 'package:book_app/features/book/book_reader_screen.dart' show BookReaderScreen;
import 'package:flutter/material.dart';
import 'package:book_app/data/sample_books.dart';
import 'package:provider/provider.dart';

// reader

// library
import 'package:book_app/features/library/models/library_store.dart';
import 'package:book_app/features/library/models/library_book.dart';

// 🔥 dummy data
import 'package:book_app/data/dummy_books.dart';

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
    /// 🔥 Get books from provider
    List<LibraryBook> books =
        context.watch<LibraryStore>().books;

    /// 🔥 If library empty → load dummy books
    if (books.isEmpty) {
      books = dummyBooks.cast<LibraryBook>();
    }

    /// Continue Reading Section
    final continueBooks =
        books.where((b) => b.progress > 0 && b.progress < 1).toList();

    /// Featured Book
    final featuredBook = books.first;

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          /// APP BAR
          const SliverAppBar(
            backgroundColor: Colors.black,
            pinned: true,
            elevation: 0,
            title: Text(
              "My Library",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          /// FEATURED BANNER
          SliverToBoxAdapter(
            child: _featuredBanner(context, featuredBook),
          ),

          /// CONTINUE READING
          if (continueBooks.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: _sectionTitle("Continue Reading"),
            ),
            SliverToBoxAdapter(
              child: _horizontalList(context, continueBooks),
            ),
          ],

          /// ALL BOOKS TITLE
          SliverToBoxAdapter(
            child: _sectionTitle("All Books"),
          ),

          /// 4x4 GRID
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
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.65,
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 30),
          ),

          /// MORE BOOKS (If >16)
          if (books.length > 16) ...[
            SliverToBoxAdapter(
              child: _sectionTitle("More Books"),
            ),
            SliverToBoxAdapter(
              child: _horizontalList(
                context,
                books.sublist(16),
              ),
            ),
          ],

          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }

  /// 🔥 FEATURED BANNER
  Widget _featuredBanner(BuildContext context, LibraryBook book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          _animatedRoute(BookReaderScreen(book: book,
      bookTitle: book.title,
      isLocked: false,)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Hero(
          tag: book.id,
          child: Container(
            height: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              image: DecorationImage(
                image: AssetImage(book.imagePath),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.4),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Colors.transparent, Colors.black87],
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
        ),
      ),
    );
  }

  /// SECTION TITLE
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
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

  /// GRID BOOK ITEM
  Widget _gridBookItem(BuildContext context, LibraryBook book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          _animatedRoute(BookReaderScreen(book: book,
      bookTitle: book.title,
      isLocked: false,)),
        );
      },
      child: Hero(
        tag: book.id,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            image: DecorationImage(
              image: AssetImage(book.imagePath),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.3),
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// HORIZONTAL LIST
  Widget _horizontalList(
      BuildContext context, List<LibraryBook> books) {
    return SizedBox(
      height: 200,
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
                _animatedRoute(BookReaderScreen(book: book,
      bookTitle: book.title,
      isLocked: false,)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Stack(
                children: [
                  Hero(
                    tag: book.id,
                    child: Container(
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        image: DecorationImage(
                          image: AssetImage(book.imagePath),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.3),
                            blurRadius: 8,
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
                      child: LinearProgressIndicator(
                        value: book.progress,
                        minHeight: 4,
                        backgroundColor: Colors.white24,
                        color: Colors.deepPurpleAccent,
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
class FeaturedBooks extends StatelessWidget {
  const FeaturedBooks({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sampleBooks.length,
        itemBuilder: (context, index) {
          final book = sampleBooks[index];

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.bookDetail,
                arguments: book,
              );
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 16),
              color: Colors.grey.shade300,
              child: Center(
                child: Text(book.title),
              ),
            ),
          );
        },
      ),
    );
  }
}