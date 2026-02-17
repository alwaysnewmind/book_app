import 'package:flutter/material.dart';

// detail screen
import 'package:book_app/features/book/book_detail_screen.dart';

// dummy data (temporary)
import 'package:book_app/data/dummy_books.dart';

class AllBooksScreen extends StatefulWidget {
  const AllBooksScreen({super.key});

  @override
  State<AllBooksScreen> createState() => _AllBooksScreenState();
}

class _AllBooksScreenState extends State<AllBooksScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final books = dummyBooks
        .where((book) =>
            book.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,

      /// ===============================
      /// APP BAR
      /// ===============================
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("All Books"),
      ),

      /// ===============================
      /// BODY
      /// ===============================
      body: Column(
        children: [

          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search books...",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          /// BOOK GRID
          Expanded(
            child: books.isEmpty
                ? const Center(
                    child: Text(
                      "No books found",
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: books.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 18,
                      childAspectRatio: 0.68,
                    ),
                    itemBuilder: (context, index) {
                      final book = books[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookDetailScreen(
                                imagePath: book.coverImage,
                                title: book.title,
                                isLocked: book.isPremium,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// BOOK COVER
                            Expanded(
                              child: Hero(
                                tag: book.coverImage,
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(14),
                                        image: DecorationImage(
                                          image:
                                              AssetImage(book.coverImage),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                    /// LOCK BADGE
                                    if (book.isPremium)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding:
                                              const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius:
                                                BorderRadius.circular(
                                                    20),
                                          ),
                                          child: const Icon(
                                            Icons.lock,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            /// TITLE
                            Text(
                              book.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 4),

                            /// FREE / PREMIUM TAG
                            Text(
                              book.isPremium
                                  ? "Premium"
                                  : "Free",
                              style: TextStyle(
                                fontSize: 12,
                                color: book.isPremium
                                    ? Colors.redAccent
                                    : Colors.greenAccent,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
