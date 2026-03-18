import 'package:book_app/features/library/models/library_book.dart';
import 'package:book_app/features/reader/controller/pdf_reader_controller.dart';
import 'package:book_app/features/reader/controller/reader_controller.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfReaderScreen extends StatefulWidget {
  final LibraryBook book;

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

    _pdfController.init(
      bookId: widget.book.id,
      totalPages: _demoTotalPages,
    );

    _readerController.init();
    _readerController.startSession(
      widget.book.id,
      startPage: 0,
      totalPages: _demoTotalPages,
    );
  }

  @override
  void dispose() {
    _readerController.endSession();
    _pdfController.stopReadingTimer();
    _pdfController.dispose();
    _readerController.dispose();
    super.dispose();
  }

  void _changePage(int nextPage) {
    if (nextPage < 0 || nextPage >= _demoTotalPages) return;

    _pdfController.onPageChanged(nextPage);

    _readerController.updateProgress(nextPage.toDouble());
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
          final int currentPage = _pdfController.currentPage;

          final double progressValue =
              _demoTotalPages > 0 ? currentPage / _demoTotalPages : 0.0;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Author
                Text(
                  widget.book.author,
                  style: theme.textTheme.bodyMedium,
                ),

                const SizedBox(height: 12),

                /// Progress bar
                LinearProgressIndicator(
                  value: progressValue.clamp(0.0, 1.0),
                  backgroundColor: Colors.grey.shade300,
                  color: theme.primaryColor,
                  minHeight: 6,
                ),

                const SizedBox(height: 8),

                /// Page info
                Text('Page ${currentPage + 1} / $_demoTotalPages'),

                const SizedBox(height: 16),

                /// PDF Viewer
                Expanded(
                  child: SfPdfViewer.asset(
                    widget.book.pdfPath,
                    onPageChanged: (details) {
                      _changePage(details.newPageNumber - 1);
                    },
                  ),
                ),

                const SizedBox(height: 10),

                /// Navigation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: currentPage > 0
                          ? () => _changePage(currentPage - 1)
                          : null,
                      child: const Text('Previous'),
                    ),
                    ElevatedButton(
                      onPressed: currentPage < _demoTotalPages - 1
                          ? () => _changePage(currentPage + 1)
                          : null,
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