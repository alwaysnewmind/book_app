import 'package:flutter/material.dart';
import 'widgets/library_tabs.dart';
import 'widgets/library_books_grid.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
        centerTitle: true,
      ),
      body: Column(
        children: const [
          LibraryTabs(),
          Expanded(
            child: LibraryBooksGrid(),
          ),
        ],
      ),
    );
  }
}
