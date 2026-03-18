import 'package:book_app/features/library/models/library_book.dart';
import 'package:book_app/features/reader/controller/pdf_reader_controller.dart';
import 'package:book_app/features/reader/provider/reader_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  final PdfReaderController _pdfController = PdfReaderController();
  final PdfViewerController _viewerController = PdfViewerController();

  int _totalPages = 0;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _pdfController.init(
      bookId: widget.book.id,
      totalPages: 0,
    );
  }

  @override
  void dispose() {
    final readerProvider = context.read<ReaderProvider>();

    readerProvider.savePdfProgress(
      bookId: widget.book.id,
      currentPage: _pdfController.currentPage,
      totalPages: _totalPages,
    );

    _pdfController.stopReadingTimer();
    _pdfController.dispose();
    super.dispose();
  }

  void _onPageChanged(PdfPageChangedDetails details) {
    final zeroBasedPage = details.newPageNumber - 1;
    _pdfController.onPageChanged(zeroBasedPage);

    context.read<ReaderProvider>().savePdfProgress(
          bookId: widget.book.id,
          currentPage: zeroBasedPage,
          totalPages: _totalPages,
        );
  }

  void _onDocumentLoaded(PdfDocumentLoadedDetails details) {
    final savedFromProvider =
        context.read<ReaderProvider>().getPdfSavedPage(widget.book.id);

    setState(() {
      _totalPages = details.document.pages.count;
      _loadError = null;
    });

    _pdfController.openPdf(
      bookId: widget.book.id,
      totalPages: _totalPages,
    );

    final savedPage =
        savedFromProvider > 0 ? savedFromProvider : _pdfController.currentPage;

    if (savedPage > 0 && savedPage < _totalPages) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _viewerController.jumpToPage(savedPage + 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: AnimatedBuilder(
        animation: _pdfController,
        builder: (context, _) {
          final currentPage = _pdfController.currentPage;

          return Column(
            children: [
              if (_loadError != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      _loadError!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                )
              else if (_totalPages > 0)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.book.author),
                      Text('Page ${currentPage + 1} / $_totalPages'),
                    ],
                  ),
                ),
              Expanded(
                child: SfPdfViewer.asset(
                  widget.book.pdfPath,
                  controller: _viewerController,
                  canShowPaginationDialog: true,
                  enableDoubleTapZooming: true,
                  enableTextSelection: true,
                  onDocumentLoaded: _onDocumentLoaded,
                  onDocumentLoadFailed: (details) {
                    setState(() {
                      _loadError =
                          'Failed to load PDF from ${widget.book.pdfPath}. ${details.error}';
                    });
                  },
                  onPageChanged: _onPageChanged,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
