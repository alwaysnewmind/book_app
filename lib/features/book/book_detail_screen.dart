import 'package:flutter/material.dart';

// reader
import 'package:book_app/features/reader/screens/book_reader_screen.dart';

// library
import 'package:book_app/features/library/models/library_store.dart';
import 'package:book_app/features/library/models/library_book.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              isLocked
                  ? 'This book is premium. Subscribe to read full content.'
                  : 'This book is free to read.',
              style: TextStyle(
                color: isLocked ? Colors.red : Colors.green,
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (isLocked) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Please subscribe to access this book'),
                      ),
                    );
                    return;
                  }

                  // ✅ Create Library Book
                  final book = LibraryBook(
                    title: title,
                    imagePath: imagePath,
                    content: '''
This is the beginning of the book "$title".

You can replace this content later with:
• Firebase data
• API response
• Chapter-wise content
• Writer uploaded content

Happy Reading!
''',
                  );

                  // ✅ Save to Library
                  LibraryStore.addBook(book);

                  // ✅ Open Reader (MODEL BASED)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookReaderScreen(
                        book: book,
                      ),
                    ),
                  );
                },
                child: Text(isLocked ? 'Subscribe & Read' : 'Read Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
