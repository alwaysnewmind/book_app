import 'package:flutter/material.dart';
import 'package:book_app/features/reader/controller/pdf_reader_controller.dart';
import 'package:book_app/features/reader/data/dummy_reader_data.dart';

class PdfReaderScreen extends StatefulWidget {
  final ReaderBook book;

  const PdfReaderScreen({super.key, required this.book});

  @override
  State<PdfReaderScreen> createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends State<PdfReaderScreen> {
  static const int _mockTotalPages = 24;

  final PdfReaderController _readerController = PdfReaderController();
  final PageController _pageController = PageController();

  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initializeReader();
  }

  Future<void> _initializeReader() async {
    await _readerController.init(widget.book.id, _mockTotalPages);
    if (!mounted) return;

    final initialPage = _readerController.currentPage.clamp(0, _mockTotalPages - 1);
    _pageController.jumpToPage(initialPage);

    _readerController.addListener(_onReaderStateChanged);
    setState(() => _isReady = true);
  }

  void _onReaderStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  int get _currentPage => _readerController.currentPage;
  int get _totalPages => _readerController.totalPages;

  bool get _isFirstPage => _currentPage <= 0;
  bool get _isLastPage => _currentPage >= _totalPages - 1;

  Future<void> _goToPreviousPage() async {
    if (_isFirstPage) return;
    await _pageController.previousPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _goToNextPage() async {
    if (_isLastPage) return;
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOut,
    );
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final primaryVelocity = details.primaryVelocity ?? 0;
    if (primaryVelocity < 0) {
      _goToNextPage();
    } else if (primaryVelocity > 0) {
      _goToPreviousPage();
    }
  }

  @override
  void dispose() {
    _readerController.removeListener(_onReaderStateChanged);
    _readerController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = _totalPages == 0 ? _mockTotalPages : _totalPages;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: !_isReady
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              onVerticalDragEnd: _onVerticalDragEnd,
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: _readerController.onPageChanged,
                      itemCount: totalPages,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'Page ${index + 1}\n\n${widget.book.title}\nBy ${widget.book.author}\n\n'
                            'This is the production reader flow for ${widget.book.title}. '
                            'Use left/right arrows or swipe up/down to navigate pages.\n\n'
                            'Sample reading content for page ${index + 1}.\n\n'
                            '${List.filled(25, 'Reading paragraph').join(' ')}',
                            style: const TextStyle(fontSize: 17, height: 1.7),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _isFirstPage ? null : _goToPreviousPage,
                          icon: const Icon(Icons.arrow_back_ios_new),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              '${_currentPage + 1} / $totalPages',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _isLastPage ? null : _goToNextPage,
                          icon: const Icon(Icons.arrow_forward_ios),
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
