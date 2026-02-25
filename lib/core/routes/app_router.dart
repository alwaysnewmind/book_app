import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:book_app/core/routes/app_routes.dart';
import 'package:book_app/features/auth/screens/splash_screen.dart';
import 'package:book_app/features/auth/screens/login_screen.dart';
import 'package:book_app/features/auth/screens/signup_screen.dart';
import 'package:book_app/features/auth/screens/genre_selection_screen.dart';
import 'package:book_app/features/auth/screens/reader_genre_selection_screen.dart';
import 'package:book_app/features/auth/screens/writer_genre_selection_screen.dart';
import 'package:book_app/features/home/home_screen.dart';
import 'package:book_app/features/library/screens/my_library_screen.dart';
import 'package:book_app/features/book/book_detail_screen.dart';
import 'package:book_app/features/book/book_reader_screen.dart';
import 'package:book_app/features/library/models/library_book.dart';
import 'package:book_app/features/profile/profile_screen.dart';
import 'package:book_app/features/settings/screens/settings_screen.dart';
import 'package:book_app/features/community/screens/community_home_screen.dart';
import 'package:book_app/features/writer/screens/writer_dashboard.dart';
import 'package:book_app/features/profile/subscription_screen.dart';
import 'package:book_app/features/subscription/purchase_screen.dart';
import 'package:book_app/features/subscription/reader_subscription_screen.dart';
import 'package:book_app/features/book/all_books_screen.dart';
import 'package:book_app/features/home/mainicon/discover_dashboard.dart';
import 'package:book_app/features/home/mainicon/premium_dashboard.dart';
import 'package:book_app/features/home/mainicon/offline_vault.dart';
import 'package:book_app/features/home/mainicon/audio_book_dashboard.dart';
import 'package:book_app/features/home/mainicon/content_writing_dashboard.dart';
import 'package:book_app/features/home/mainicon/review_dashboard.dart';
import 'package:book_app/features/home/mainicon/category_dashboard.dart';
import 'package:book_app/features/home/mainicon/book_battle_dashboard.dart';
import 'package:book_app/features/home/mainicon/quotes_dashboard.dart';
import 'package:book_app/features/home/mainicon/favorites_dashboard.dart';
import 'package:book_app/features/home/mainicon/help_support.dart';
import 'package:book_app/features/settings/language_selection_screen.dart';
import 'package:book_app/features/writer/screens/writer_earnings_screen.dart';
import 'package:book_app/models/user_model.dart';
import 'package:book_app/navigation/app_shell.dart';
import 'package:book_app/providers/auth_provider.dart';

class BookDetailArgs {
  final String imagePath;
  final String title;
  final bool isLocked;

  const BookDetailArgs({
    required this.imagePath,
    required this.title,
    this.isLocked = false,
  });

  LibraryBook toLibraryBook() {
    return LibraryBook(
      id: title.hashCode.toString(),
      title: title,
      imagePath: imagePath,
      chapters: const [
        'Chapter 1\n\nThis is chapter one content...',
        'Chapter 2\n\nThis is chapter two content...',
        'Chapter 3\n\nThis is chapter three content...',
      ],
    );
  }
}

class ReaderArgs {
  final LibraryBook book;
  final bool isLocked;

  const ReaderArgs({required this.book, this.isLocked = false});
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _page(const SplashScreen(), settings);
      case AppRoutes.login:
        return _page(const LoginScreen(), settings);
      case AppRoutes.signup:
        return _page(const SignupScreen(), settings);
      case AppRoutes.genreSelection:
        return _page(const RoleSelectionScreen(), settings);
      case AppRoutes.readerGenres:
        return _page(const ReaderGenreSelectionScreen(), settings);
      case AppRoutes.writerGenres:
        return _page(const WriterGenreSelectionScreen(), settings);
      case AppRoutes.home:
      case AppRoutes.appShell:
        return _page(const AppShell(), settings);
      case AppRoutes.library:
        return _page(const MyLibraryScreen(), settings);
      case AppRoutes.bookDetail:
        final args = settings.arguments as BookDetailArgs?;
        return _page(
          BookDetailScreen(
            imagePath: args?.imagePath ?? 'assets/books/Book1.png',
            title: args?.title ?? 'Book Detail',
            isLocked: args?.isLocked ?? false,
          ),
          settings,
        );
      case AppRoutes.reader:
        final args = settings.arguments;
        final readerArgs = args is ReaderArgs
            ? args
            : ReaderArgs(book: (args as BookDetailArgs?)?.toLibraryBook() ?? const LibraryBook(id: 'default', title: 'Reader', imagePath: 'assets/books/Book1.png'));
        return _page(
          BookReaderScreen(book: readerArgs.book, isLocked: readerArgs.isLocked),
          settings,
        );
      case AppRoutes.profile:
        return _page(
          Consumer<AuthProvider>(
            builder: (context, auth, _) {
              final user = auth.currentUser;
              final isWriterMode = user?.currentMode == UserMode.writer || user?.currentMode == UserMode.author;
              return ProfileScreen(
                isWriterMode: isWriterMode,
                onSwap: () async {
                  if (user == null) return;
                  final next = isWriterMode ? UserMode.reader : UserMode.writer;
                  await auth.updateUser(user.copyWith(currentMode: next));
                },
              );
            },
          ),
          settings,
        );
      case AppRoutes.settings:
        return _page(const SettingsScreen(), settings);
      case AppRoutes.community:
      case AppRoutes.communityDashboard:
        return _page(const CommunityHomeScreen(), settings);
      case AppRoutes.writer:
        return _page(
          const WriterDashboard(currentUser: null, isGuest: true, isWriterMode: false),
          settings,
        );
      case AppRoutes.premium:
        return _page(const MySubscriptionScreen(), settings);
      case AppRoutes.subscription:
        return _page(const ReaderSubscriptionScreen(), settings);
      case AppRoutes.purchase:
        return _page(const PurchaseScreen(), settings);
      case AppRoutes.read:
        return _page(const AllBooksScreen(), settings);
      case AppRoutes.discoverDashboard:
        return _page(const DiscoverDashboard(), settings);
      case AppRoutes.premiumDashboard:
        return _page(const PremiumDashboard(), settings);
      case AppRoutes.offlineVault:
        return _page(const OfflineVault(), settings);
      case AppRoutes.audioBookDashboard:
        return _page(const AudioBookDashboard(), settings);
      case AppRoutes.contentWritingDashboard:
        return _page(const ContentWritingDashboard(), settings);
      case AppRoutes.reviewDashboard:
        return _page(const ReviewDashboardScreen(), settings);
      case AppRoutes.categoryDashboard:
        return _page(const CategoryDashboard(), settings);
      case AppRoutes.bookBattleDashboard:
        return _page(const BookBattleDashboard(), settings);
      case AppRoutes.quotesDashboard:
        return _page(const QuotesDashboard(), settings);
      case AppRoutes.favoritesDashboard:
        return _page(const FavoritesDashboard(), settings);
      case AppRoutes.helpSupportDashboard:
        return _page(const HelpSupportScreen(), settings);
      case AppRoutes.language:
        return _page(const LanguageSelectionScreen(), settings);
      case AppRoutes.earn:
        return _page(const WriterEarningsScreen(), settings);
      default:
        return _page(
          Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
          settings,
        );
    }
  }

  static MaterialPageRoute<dynamic> _page(Widget child, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => child, settings: settings);
  }
}
