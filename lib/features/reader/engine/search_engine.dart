class SearchResult {

  final int page;
  final String text;
  final int index;

  SearchResult({
    required this.page,
    required this.text,
    required this.index,
  });
}

class SearchEngine {

  List<SearchResult> searchInBook({
    required List<String> pages,
    required String query,
  }) {

    final results = <SearchResult>[];

    if (query.trim().isEmpty) return results;

    final q = query.toLowerCase();

    for (int i = 0; i < pages.length; i++) {

      final pageText = pages[i].toLowerCase();

      int index = pageText.indexOf(q);

      while (index != -1) {

        results.add(
          SearchResult(
            page: i,
            text: pages[i],
            index: index,
          ),
        );

        index = pageText.indexOf(q, index + q.length);
      }
    }

    return results;
  }
}