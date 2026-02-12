import 'package:flutter/material.dart';
import 'create_book_screen.dart';
import 'package:book_app/features/writer/widgets/writer_stats.dart';
import 'widgets/writer_books_grid.dart';

class WriterDashboard extends StatelessWidget {
  const WriterDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1A1A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1A1A),
        elevation: 0,
        title: const Text(
          "Writer Dashboard",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // 📊 Writer stats
            WriterStatsRow(),

            SizedBox(height: 28),

            // 📚 Books section
            Text(
              "Your Books",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 12),

            WriterBooksGrid(),
          ],
        ),
      ),

      // ➕ Create Book FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        elevation: 6,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateBookScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
