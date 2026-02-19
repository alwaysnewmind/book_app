import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Reader
import 'package:book_app/features/reader/screens/book_reader_screen.dart';

// Library
import 'package:book_app/features/library/models/library_store.dart';
import 'package:book_app/features/library/models/library_book.dart';

// Provider
import 'package:book_app/providers/reader_provider.dart';

class BookDetailScreen extends StatelessWidget {
  final String imagePath;
  final String title;
  final bool isLocked;

  const BookDetailScreen({
    super.key,
    required this.imagePath,
    required this.title,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final readerProvider = Provider.of<ReaderProvider>(context);

    final existingBook = LibraryStore.instance.books
            .where((b) => b.title == title)
            .isNotEmpty
        ? LibraryStore.instance.books.firstWhere((b) => b.title == title)
        : null;

    final hasStarted = existingBook != null;
    final progress = hasStarted ? existingBook.progress : 0.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,

      body: Stack(
        children: [

          /// 🔥 PURPLE GRADIENT HEADER
          Container(
            height: 280,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF7B2FF7),
                  Color(0xFF9F44D3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// BACK BUTTON + PROFILE
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Reader Tail",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, color: Colors.white),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),

          /// ⚪ MAIN CONTENT
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 120),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// BOOK HEADER SECTION
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              imagePath,
                              height: 180,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 20),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  children: const [
                                    Icon(Icons.star,
                                        color: Colors.deepPurple, size: 18),
                                    SizedBox(width: 4),
                                    Text("4.8",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                const Text(
                                  "By E.K. Eleoin",
                                  style: TextStyle(color: Colors.black54),
                                ),

                                const SizedBox(height: 6),

                                const Text(
                                  "Fantasy • Adventure",
                                  style: TextStyle(color: Colors.black45),
                                ),

                                const SizedBox(height: 16),

                                /// READ BUTTON ROW
                                Row(
                                  children: [

                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (isLocked) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Please subscribe to access this book'),
                                              ),
                                            );
                                            return;
                                          }

                                          LibraryBook book;

                                          if (existingBook != null) {
                                            book = existingBook;
                                          } else {
                                            book = LibraryBook(
                                              id: title.hashCode.toString(),
                                              title: title,
                                              imagePath: imagePath,
                                              chapters: [
                                                "Chapter 1\n\nThis is chapter one content...",
                                                "Chapter 2\n\nThis is chapter two content...",
                                                "Chapter 3\n\nThis is chapter three content...",
                                              ],
                                            );
                                            LibraryStore.instance
                                                .addBook(book);
                                          }

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  BookReaderScreen(book: book),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.deepPurple,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                        ),
                                        child: Text(
                                          isLocked
                                              ? "Subscribe"
                                              : hasStarted
                                                  ? "Continue"
                                                  : "Read Book",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    _circleIcon(Icons.add),
                                    const SizedBox(width: 10),
                                    _circleIcon(Icons.favorite_border),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      /// SIMILAR BOOKS
                      const Text(
                        "Similar Books",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.deepPurple.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          height: 130,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(14),
                                child: Image.asset(
                                  imagePath,
                                  width: 90,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// SYNOPSIS
                      const Text(
                        "Synopsis",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                        "Vestibulum at eros eget nunc tempor varius. "
                        "Sed tristique magna sit amet purus gravida, "
                        "ac fermentum sapien faucibus.",
                        style: TextStyle(
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.deepPurple),
      ),
      child: Icon(icon, color: Colors.deepPurple),
    );
  }
}
