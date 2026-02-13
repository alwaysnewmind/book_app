class LibraryBook {
  final String title;
  final String imagePath;
  final String content;

  double lastScrollOffset; // ✅ Continue Reading Support

  LibraryBook({
    required this.title,
    required this.imagePath,
    required this.content,
    this.lastScrollOffset = 0,
  });
}
