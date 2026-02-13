import 'dart:ui';
import 'package:flutter/material.dart';

// reader
import 'package:book_app/features/reader/screens/book_reader_screen.dart';

// library
import 'package:book_app/features/library/models/library_store.dart';

class MyLibraryScreen extends StatelessWidget {
  const MyLibraryScreen({super.key});

  Route _animatedRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        final fade = Tween(begin: 0.0, end: 1.0).animate(animation);
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ).animate(animation);

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final books = LibraryStore.books;

    return Scaffold(
      backgroundColor: Colors.black,
      body: books.isEmpty
          ? const Center(
              child: Text(
                "No books added yet",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [

                /// 🔥 App Bar
                SliverAppBar(
                  backgroundColor: Colors.black,
                  pinned: true,
                  floating: true,
                  title: const Text("My Library"),
                ),

                /// 🎬 Featured Banner
                SliverToBoxAdapter(
                  child: _featuredBanner(context, books.first),
                ),

                /// 📚 Continue Reading
                SliverToBoxAdapter(
                  child: _sectionTitle("Continue Reading"),
                ),

                SliverToBoxAdapter(
                  child: _horizontalList(context, books),
                ),

                /// ⭐ Recently Added
                SliverToBoxAdapter(
                  child: _sectionTitle("Recently Added"),
                ),

                SliverToBoxAdapter(
                  child: _horizontalList(context, books.reversed.toList()),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 40),
                ),
              ],
            ),
    );
  }

  Widget _featuredBanner(BuildContext context, dynamic book) {
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

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

  Widget _horizontalList(BuildContext context, List books) {
    return SizedBox(
      height: 190,
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
            child: Hero(
              tag: book.imagePath,
              child: Container(
                width: 120,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  image: DecorationImage(
                    image: AssetImage(book.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
