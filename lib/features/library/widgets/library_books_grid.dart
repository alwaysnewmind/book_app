import 'package:flutter/material.dart';
import 'package:book_app/core/routes/app_routes.dart';

class LibraryBooksGrid extends StatelessWidget {
  const LibraryBooksGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final books = List.generate(12, (index) => 'Book ${index + 1}');

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        final bookImage = 'assets/books/Book${(index % 5) + 1}.png';

        return GestureDetector(
          onTap: () {
            // Navigate to Book Detail Screen
            Navigator.pushNamed(
              context,
              AppRoutes.bookDetail,
              // arguments: books[index], // optional: pass book ID
            );
          },
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  bookImage,
                  fit: BoxFit.cover,
                ),
              ),

              /// Premium lock overlay example
              if (index % 4 == 0) // simulate premium books
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.lock,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
