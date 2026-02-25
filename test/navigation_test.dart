import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:book_app/core/routes/app_router.dart';
import 'package:book_app/core/routes/app_routes.dart';
import 'package:book_app/features/home/widgets/app_drawer.dart';
import 'package:book_app/models/writer_book_model.dart';
import 'package:book_app/navigation/app_shell.dart';
import 'package:book_app/providers/app_settings_provider.dart';
import 'package:book_app/providers/auth_provider.dart';
import 'package:book_app/providers/reader_provider.dart';
import 'package:book_app/features/library/models/library_store.dart';
import 'package:book_app/shared/widgets/book_card.dart';

Widget _testApp({required Widget child}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => ReaderProvider()),
      ChangeNotifierProvider(create: (_) => LibraryStore()),
      ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
    ],
    child: MaterialApp(
      onGenerateRoute: AppRouter.onGenerateRoute,
      home: child,
    ),
  );
}

void main() {
  testWidgets('Home → BookDetail via BookCard tap', (tester) async {
    final book = Book(
      id: '1',
      title: 'The Silent Reader',
      author: 'E.K. Eleoin',
      coverImage: 'assets/books/Book1.png',
      summary: 'Summary',
    );

    await tester.pumpWidget(
      _testApp(
        child: Scaffold(
          body: Center(
            child: SizedBox(width: 220, height: 320, child: BookCard(book: book)),
          ),
        ),
      ),
    );

    await tester.tap(find.text('The Silent Reader'));
    await tester.pumpAndSettle();

    expect(find.text('The Silent Reader'), findsWidgets);
  });

  testWidgets('BookDetail → Reader', (tester) async {
    await tester.pumpWidget(
      _testApp(
        child: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.bookDetail,
                      arguments: const BookDetailArgs(
                        imagePath: 'assets/books/Book1.png',
                        title: 'Reader Route Book',
                      ),
                    );
                  },
                  child: const Text('Open Detail'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open Detail'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Read Book'));
    await tester.pumpAndSettle();

    expect(find.text('Reader Route Book'), findsWidgets);
  });

  testWidgets('BottomNav tabs work', (tester) async {
    await tester.pumpWidget(_testApp(child: const AppShell()));

    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();
    expect(find.text('My Library'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Switch to Writer Mode'), findsOneWidget);
  });

  testWidgets('Drawer items navigate correctly', (tester) async {
    await tester.pumpWidget(
      _testApp(
        child: const Scaffold(
          drawer: AppDrawer(),
          body: Center(child: Text('Root')),
        ),
      ),
    );

    final scaffoldState = tester.firstState<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsWidgets);
  });
}
