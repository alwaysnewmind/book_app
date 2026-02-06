import 'package:flutter/material.dart';
import 'create_book_screen.dart';
import 'write_chapter_screen.dart';

class WriterDashboard extends StatelessWidget {
  const WriterDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Writer Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 💰 Earnings Card
            Card(
              child: ListTile(
                leading: const Icon(Icons.currency_rupee),
                title: const Text("Total Earnings"),
                subtitle: const Text("₹2,450 (demo data)"),
              ),
            ),

            const SizedBox(height: 20),

            // ✍️ Create Book
            ElevatedButton.icon(
              icon: const Icon(Icons.book),
              label: const Text("Create New Book"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateBookScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // 📝 Write Chapter
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text("Write New Chapter"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WriteChapterScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // 📚 My Books
            const Text(
              "My Books",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.menu_book),
                    title: Text("Soul Journey"),
                    subtitle: Text("Chapters: 4 • Published"),
                  ),
                  ListTile(
                    leading: Icon(Icons.menu_book),
                    title: Text("Mind Power"),
                    subtitle: Text("Chapters: 2 • Draft"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
