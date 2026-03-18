class ProgressEngine {

  /// =========================
  /// SCROLL BASED PROGRESS (0-100)
  /// =========================
  double calculateScrollProgress({
    required double scroll,
    required double maxScroll,
  }) {
    if (maxScroll <= 0) return 0;

    final safeScroll = scroll.clamp(0.0, maxScroll);

    final progress = (safeScroll / maxScroll) * 100;

    return progress.clamp(0.0, 100.0);
  }

  /// =========================
  /// PAGE BASED PROGRESS (0-100)
  /// =========================
  double calculatePageProgress({
    required int currentPage,
    required int totalPages,
  }) {
    if (totalPages <= 0) return 0;

    final safePage = currentPage.clamp(0, totalPages - 1);

    final progress = ((safePage + 1) / totalPages) * 100;

    return progress.clamp(0.0, 100.0);
  }

  /// =========================
  /// CHAPTER PROGRESS (0-100)
  /// =========================
  double calculateChapterProgress({
    required int currentChapter,
    required int totalChapters,
  }) {
    if (totalChapters <= 0) return 0;

    final safeChapter = currentChapter.clamp(0, totalChapters - 1);

    final progress = ((safeChapter + 1) / totalChapters) * 100;

    return progress.clamp(0.0, 100.0);
  }

  /// =========================
  /// BOOK COMPLETION CHECK
  /// =========================
  bool isBookCompleted(double progress) {
    final safe = progress.clamp(0.0, 100.0);
    return safe >= 99.9;
  }

  /// =========================
  /// PAGES READ CALCULATOR
  /// =========================
  int calculatePagesRead({
    required double progress,
    required int totalPages,
  }) {
    if (totalPages <= 0) return 0;

    final safeProgress = progress.clamp(0.0, 100.0);

    return ((safeProgress / 100) * totalPages).round();
  }

  /// =========================
  /// READING SPEED
  /// pages per minute
  /// =========================
  double calculateReadingSpeed({
    required int pagesRead,
    required int minutes,
  }) {
    if (minutes <= 0) return 0;

    final safePages = pagesRead < 0 ? 0 : pagesRead;

    return safePages / minutes;
  }

  /// =========================
  /// ESTIMATED TIME LEFT
  /// =========================
  int estimateRemainingMinutes({
    required int pagesLeft,
    required double pagesPerMinute,
  }) {
    if (pagesPerMinute <= 0) return 0;

    final safePagesLeft = pagesLeft < 0 ? 0 : pagesLeft;

    return (safePagesLeft / pagesPerMinute).ceil();
  }

  /// =========================
  /// REMAINING PAGES
  /// =========================
  int calculateRemainingPages({
    required int totalPages,
    required int pagesRead,
  }) {
    if (totalPages <= 0) return 0;

    final remaining = totalPages - pagesRead;

    return remaining < 0 ? 0 : remaining;
  }

  /// =========================
  /// FORMAT PROGRESS LABEL
  /// =========================
  String formatProgress(double progress) {
    final safe = progress.clamp(0.0, 100.0);

    return "${safe.toStringAsFixed(0)}%";
  }

  /// =========================
  /// READING STATUS LABEL
  /// =========================
  String getReadingStatus(double progress) {
    final safe = progress.clamp(0.0, 100.0);

    if (safe <= 0) {
      return "Not Started";
    }

    if (safe < 25) {
      return "Just Started";
    }

    if (safe < 75) {
      return "In Progress";
    }

    if (safe < 99) {
      return "Almost Finished";
    }

    return "Completed";
  }

  /// =========================
  /// NORMALIZED PROGRESS (0-1)
  /// for UI animations
  /// =========================
  double calculateNormalizedProgress({
    required double scroll,
    required double maxScroll,
  }) {
    if (maxScroll <= 0) return 0;

    final safeScroll = scroll.clamp(0.0, maxScroll);

    return (safeScroll / maxScroll).clamp(0.0, 1.0);
  }
}