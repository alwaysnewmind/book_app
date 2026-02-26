import 'package:book_app/features/book/book_reader_screen.dart'
    show BookReaderScreen;
import 'package:book_app/models/writer_book_model.dart';
import 'package:flutter/material.dart';

// Library
import 'package:book_app/features/library/models/library_store.dart';
import 'package:book_app/features/library/models/library_book.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    final existingBook = LibraryStore.instance.books
            .where((b) => b.title == book.title)
            .isNotEmpty
        ? LibraryStore.instance.books
            .firstWhere((b) => b.title == book.title)
        : null;

    final hasStarted = existingBook != null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          /// 🔥 HEADER GRADIENT
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

          /// TOP BAR
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        child:
                            Icon(Icons.person, color: Colors.white),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),

          /// MAIN CONTENT
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 120),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F6FA),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      /// BOOK HEADER
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(20),
                            child: Image.asset(
                              book.coverImage,
                              height: 180,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: const [
                                    Icon(Icons.star,
                                        color:
                                            Colors.deepPurple,
                                        size: 18),
                                    SizedBox(width: 4),
                                    Text("4.8",
                                        style: TextStyle(
                                            fontWeight:
                                                FontWeight
                                                    .w600)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "By ${book.author}",
                                  style: const TextStyle(
                                      color:
                                          Colors.black54),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  "Fantasy • Adventure",
                                  style: TextStyle(
                                      color:
                                          Colors.black45),
                                ),
                                const SizedBox(height: 16),

                                /// READ BUTTON
                                Row(
                                  children: [
                                    Expanded(
                                      child:
                                          ElevatedButton(
                                        onPressed: () {
                                          if (book
                                              .isPremium) {
                                            ScaffoldMessenger.of(
                                                    context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Please subscribe to access this book'),
                                              ),
                                            );
                                            return;
                                          }

                                          LibraryBook
                                              readerBook;

                                          if (existingBook !=
                                              null) {
                                            readerBook =
                                                existingBook;
                                          } else {
                                            readerBook =
                                                LibraryBook(
                                              id: book.id
                                                      .isNotEmpty
                                                  ? book.id
                                                  : book.title
                                                      .hashCode
                                                      .toString(),
                                              title:
                                                  book.title,
                                              imagePath:
                                                  book.coverImage,
                                              chapters: book
                                                      .chapters
                                                      .isNotEmpty
                                                  ? book
                                                      .chapters
                                                  : [
                                                      "Chapter 1\n\nThis is chapter one content...",
                                                      "Chapter 2\n\nThis is chapter two content...",
                                                      "Chapter 3\n\nThis is chapter three content...",
                                                    ],
                                            );

                                            LibraryStore
                                                .instance
                                                .addBook(
                                                    readerBook);
                                          }

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  BookReaderScreen(
                                                book:
                                                    readerBook,
                                                isLocked: book
                                                    .isPremium,
                                              ),
                                            ),
                                          );
                                        },
                                        style:
                                            ElevatedButton
                                                .styleFrom(
                                          backgroundColor:
                                              Colors
                                                  .deepPurple,
                                          shape:
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                                        30),
                                          ),
                                          padding:
                                              const EdgeInsets
                                                  .symmetric(
                                                      vertical:
                                                          14),
                                        ),
                                        child: Text(
                                          book.isPremium
                                              ? "Subscribe"
                                              : hasStarted
                                                  ? "Continue"
                                                  : "Read Book",
                                          style:
                                              const TextStyle(
                                            fontSize:
                                                16,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      /// SYNOPSIS
                      const Text(
                        "Synopsis",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        book.description,
                        style: const TextStyle(
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
}