import 'package:flutter/material.dart';

import 'library_book.dart';

class LibraryStore extends ChangeNotifier {
  LibraryStore() {
    if (_books.isEmpty) {
      _books.addAll(dummyBooks);
    }
  }

  static final LibraryStore instance = LibraryStore();

  static final List<LibraryBook> dummyBooks = [
    LibraryBook(
      id: 'lb-001',
      title: 'The Silent Reader',
      author: 'Elena Hart',
      category: 'Mystery',
      imagePath: 'assets/books/Book1.png',
      progress: 0.65,
      favorite: true,
      downloaded: true,
      chapters: [
        'Chapter 1 - Arrival',
        'Chapter 2 - Hidden Notes',
        'Chapter 3 - Night Clues',
      ],
      lastReadChapter: 1,
    ),
    LibraryBook(
      id: 'lb-002',
      title: 'Deep Work Habits',
      author: 'Marcus Vale',
      category: 'Productivity',
      imagePath: 'assets/books/Book2.png',
      progress: 0.35,
      favorite: false,
      downloaded: true,
      chapters: ['Part 1', 'Part 2', 'Part 3'],
    ),
    LibraryBook(
      id: 'lb-003',
      title: 'Golden Mindset',
      author: 'Priya Sethi',
      category: 'Self Growth',
      imagePath: 'assets/books/Book3.png',
      progress: 1.0,
      favorite: true,
      chapters: ['Mindset', 'Focus', 'Consistency'],
      lastReadChapter: 2,
    ),
    LibraryBook(
      id: 'lb-004',
      title: 'Whispers of Dawn',
      author: 'Nikhil Rao',
      category: 'Fantasy',
      imagePath: 'assets/books/Book4.png',
      progress: 0.0,
      favorite: false,
      chapters: ['Prologue', 'The Forest', 'The Oath'],
    ),
    LibraryBook(
      id: 'lb-005',
      title: 'The Last Formula',
      author: 'Aarav Menon',
      category: 'Thriller',
      imagePath: 'assets/books/Book5.png',
      progress: 0.8,
      favorite: true,
      downloaded: true,
      chapters: ['Origin', 'Breakpoint', 'Final Cipher'],
      lastReadChapter: 2,
    ),
    LibraryBook(
      id: 'lb-006',
      title: 'Letters to the Moon',
      author: 'Sara Qureshi',
      category: 'Romance',
      imagePath: 'assets/books/Book6.png',
      progress: 1.0,
      favorite: false,
      chapters: ['Letter One', 'Letter Two', 'Letter Three'],
      lastReadChapter: 2,
    ),
  ];

  final List<LibraryBook> _books = [];

  List<LibraryBook> get books => List.unmodifiable(_books);

  void addBook(LibraryBook book) {
    if (!_books.any((b) => b.id == book.id)) {
      _books.add(book);
      notifyListeners();
    }
  }

  void removeBook(String id) {
    _books.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  bool containsBook(String id) {
    return _books.any((b) => b.id == id);
  }

  void updateProgress(String id, double progress) {
    final index = _books.indexWhere((b) => b.id == id);
    if (index != -1) {
      _books[index] = _books[index].copyWith(progress: progress.clamp(0.0, 1.0));
      notifyListeners();
    }
  }

  void setDownloaded(String id, bool value) {
    final index = _books.indexWhere((b) => b.id == id);
    if (index != -1) {
      _books[index] = _books[index].copyWith(downloaded: value);
      notifyListeners();
    }
  }

  void setFavorite(String id, bool value) {
    final index = _books.indexWhere((b) => b.id == id);
    if (index != -1) {
      _books[index] = _books[index].copyWith(favorite: value);
      notifyListeners();
    }
  }

  LibraryBook? getBook(String id) {
    try {
      return _books.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  void clearLibrary() {
    _books.clear();
    notifyListeners();
  }
}
