class ReaderBookmarkService {

  final Set<String> _bookmarks = {};

  void addBookmark(String id) {
    _bookmarks.add(id);
  }

  void removeBookmark(String id) {
    _bookmarks.remove(id);
  }

  bool isBookmarked(String id) {
    return _bookmarks.contains(id);
  }
}