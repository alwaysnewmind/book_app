import 'package:book_app/features/reader/controller/pdf_reader_controller.dart';
import 'package:book_app/features/reader/controller/reader_controller.dart';
import 'package:book_app/features/reader/data/dummy_reader_data.dart';
import 'package:flutter/material.dart';

class PdfReaderScreen extends StatefulWidget {
  final ReaderBook book;

  const PdfReaderScreen({
    super.key,
    required this.book,
  });

  @override
  State<PdfReaderScreen> createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends State<PdfReaderScreen> {
  static const int _demoTotalPages = 100;

  final PdfReaderController _pdfController = PdfReaderController();
  final ReaderController _readerController = ReaderController();

  @override
  void initState() {
    super.initState();
    _pdfController.init(widget.book.id, _demoTotalPages);
    _readerController.init();
    _readerController.startReadingSession();
  }

  @override
  void dispose() {
    _readerController.stopReadingSession();
    _pdfController.stopReadingTimer();
    _pdfController.dispose();
    _readerController.dispose();
    super.dispose();
  }

  void _changePage(int nextPage) {
    if (nextPage < 0 || nextPage > _demoTotalPages) {
      return;
    }

    _pdfController.onPageChanged(nextPage);
    _readerController.updateBookProgress(
      widget.book.id,
      nextPage,
      _demoTotalPages,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: AnimatedBuilder(
        animation: _pdfController,
        builder: (context, _) {
          final currentPage = _pdfController.currentPage;
          final progressValue = _demoTotalPages == 0
              ? 0.0
              : currentPage / _demoTotalPages;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.book.author,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),

                LinearProgressIndicator(value: progressValue),

                const SizedBox(height: 8),
                Text('Page $currentPage / $_demoTotalPages'),

                const SizedBox(height: 16),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text('PDF: ${widget.book.pdfPath}'),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => _changePage(currentPage - 1),
                      child: const Text('Previous'),
                    ),
                    ElevatedButton(
                      onPressed: () => _changePage(currentPage + 1),
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}