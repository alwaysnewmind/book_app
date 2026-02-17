class LibraryBook {
  final String id;
  final String title;
  final String imagePath;

  /// Full book content divided into chapters
  final List<String> chapters;

  /// Reading State
  int lastReadChapter;
  double progress;

  /// Optional metadata (future ready)
  final String? author;
  final String? description;
  final bool isPremium;

  LibraryBook({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.chapters,
    this.lastReadChapter = 0,
    this.progress = 0.0,
    this.author,
    this.description,
    this.isPremium = false,
  });

  /// Update progress based on chapter
  void updateProgress(int currentChapter) {
    lastReadChapter = currentChapter;
    progress = (currentChapter + 1) / chapters.length;
  }
}
