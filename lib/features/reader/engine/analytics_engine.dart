class AnalyticsEngine {

  int totalPagesRead = 0;

  int booksCompleted = 0;

  Duration totalReadingTime = Duration.zero;

  DateTime? _sessionStart;

  /// =========================
  /// START READING SESSION
  /// =========================
  void startSession() {

    if (_sessionStart != null) {
      return;
    }

    _sessionStart = DateTime.now();
  }

  /// =========================
  /// END READING SESSION
  /// =========================
  void endSession() {

    final start = _sessionStart;

    if (start == null) return;

    final duration = DateTime.now().difference(start);

    if (duration.isNegative) {
      _sessionStart = null;
      return;
    }

    totalReadingTime += duration;

    _sessionStart = null;
  }

  /// =========================
  /// ADD PAGES READ
  /// =========================
  void addPagesRead(int pages) {

    if (pages <= 0) return;

    totalPagesRead += pages;
  }

  /// =========================
  /// BOOK COMPLETED
  /// =========================
  void bookCompleted() {

    booksCompleted++;
  }

  /// =========================
  /// CURRENT SESSION TIME
  /// =========================
  Duration _getActiveSessionTime() {

    final start = _sessionStart;

    if (start == null) return Duration.zero;

    final duration = DateTime.now().difference(start);

    if (duration.isNegative) return Duration.zero;

    return duration;
  }

  /// =========================
  /// GET ANALYTICS STATS
  /// =========================
  Map<String, dynamic> getStats() {

    final activeSession = _getActiveSessionTime();

    final totalTime = totalReadingTime + activeSession;

    return {
      "pagesRead": totalPagesRead,
      "booksCompleted": booksCompleted,
      "readingMinutes": totalTime.inMinutes,
    };
  }
}