import 'package:book_app/features/book/model/book_model.dart';

class FavoriteBookModel extends BookModel {
  FavoriteBookModel({
    required String id,
    required String title,
    required String author,
    required String coverUrl,
    required String description,
    required int viewsCount,
    required String pdfPath,
    DateTime? savedAt,
  }) : super(
          id: id,
          title: title,
          authorName: author,
          coverUrl: coverUrl,
          description: description,
          viewsCount: viewsCount,
          pdfPath: pdfPath,
          savedAt: savedAt,
          genre: '',
          rating: 0,
          reviewCount: 0,
          isPaid: false,
          price: 0,
          isBookmarked: true,
        );

  /// convert BookModel → FavoriteBookModel
  static FavoriteBookModel fromBook(BookModel book) {
    return FavoriteBookModel(
      id: book.id,
      title: book.title,
      author: book.authorName,
      coverUrl: book.coverUrl,
      description: book.description,
      viewsCount: book.viewsCount,
      pdfPath: book.pdfPath,
      savedAt: book.savedAt,
    );
  }
}