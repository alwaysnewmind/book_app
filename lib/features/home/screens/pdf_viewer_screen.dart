import 'package:flutter/material.dart';
import 'package:book_app/models/book_model.dart';

class PdfViewerScreen extends StatelessWidget {
  const PdfViewerScreen({super.key});
  
  get SfPdfViewer => null;

  @override
  Widget build(BuildContext context) {
    final BookModel book =
        ModalRoute.of(context)!.settings.arguments as BookModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: SfPdfViewer.asset(book.pdfPath),
    );
  }
}