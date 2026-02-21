import 'package:book_app/features/book/book_reader_screen.dart' show BookReaderScreen;
import 'package:flutter/material.dart';
import 'package:book_app/features/library/models/library_store.dart';
import 'package:book_app/features/library/models/library_book.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  Route _animatedRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween(begin: 0.96, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter favorite books from library
    final List<LibraryBook> favoriteBooks =
        LibraryStore.instance.books.where((b) => b.favorite).toList();

    if (favoriteBooks.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "No favorite books yet",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Favorite Books"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favoriteBooks.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.6,
        ),
        itemBuilder: (context, index) {
          final book = favoriteBooks[index];

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
              tag: book.imagePath,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Image.asset(
                      book.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
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
            ),
          );
        },
      ),
    );
  }
}
