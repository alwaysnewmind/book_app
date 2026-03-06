import 'package:book_app/features/ai/ai_summary_screen.dart' show AISummaryScreen;
import 'package:book_app/features/auth/screens/genre_selection_screen.dart';
import 'package:book_app/features/auth/screens/reader_genre_selection_screen.dart'
    show ReaderGenreSelectionScreen;
import 'package:book_app/features/auth/screens/profile_upload_screen.dart';
import 'package:book_app/features/auth/screens/signup_screen.dart';
import 'package:book_app/features/auth/screens/writer_genre_selection_screen.dart'
    show WriterGenreSelectionScreen;
import 'package:book_app/features/book/screen/book_detail_screen.dart' show BookDetailScreen;
import 'package:book_app/features/home/mainicon/favorites%20icon/provider/favorites_provider.dart' show FavoritesProvider;
import 'package:book_app/features/library/screens/my_library_screen.dart' show MyLibraryScreen;
import 'package:book_app/features/profile/profile_screen.dart' show ProfileScreen;
import 'package:book_app/features/writer/create_book_entry_page.dart';
import 'package:book_app/features/writer/create_book_screen.dart';
import 'package:book_app/features/writer/screens/manage_books_page.dart';
import 'package:book_app/features/writer/screens/write_chapter_screen.dart';
import 'package:book_app/features/writer/screens/writer_analytics_screen.dart';
import 'package:book_app/features/writer/screens/writer_dashboard.dart';
import 'package:book_app/features/writer/screens/writer_profile_screen.dart';
import 'package:book_app/features/writer/screens/writer_publish_page.dart';
import 'package:book_app/features/writer/screens/writer_subscription_screen.dart';
import 'package:book_app/models/writer_book_model.dart' show Book;
import 'package:book_app/navigation/app_shell.dart';
import 'package:book_app/models/user_model.dart';
import 'package:book_app/features/auth/provider/auth_provider.dart';
import 'package:book_app/features/auth/widgets/role_guard.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 🔥 Auth
import '../../features/auth/screens/splash_screen.dart';
import 'package:book_app/features/auth/screens/login_screen.dart';

/// 🔥 Reading
import '../../features/book/screen/all_books_screen.dart';
import '../../features/home/mainicon/story analytics icon/story_analytics_screen.dart';
import '../../features/reader/screens/pdf_reader_screen.dart';
import '../../features/reader/data/dummy_reader_data.dart';
import '../../features/reader/screens/reader_dashboard_screen.dart';

/// 🔥 Settings
import '../../features/home/mainicon/setting icon/settings_screen.dart';
import '../../features/home/mainicon/laguge icon/language_selection_screen.dart';

/// 🔥 Writer
import '../../features/writer/screens/writer_earnings_screen.dart';

/// 🔥 Library
import 'package:book_app/features/library/models/library_book.dart';

/// 🔥 Community
import '../../features/community/screens/community_screen.dart';
import '../../features/community/screens/create_group_screen.dart';
import '../../features/community/screens/groups_screen.dart';
import '../../features/community/screens/friends_screen.dart';
import '../../features/community/screens/friend_requests_screen.dart';
import '../../features/community/screens/chat_screen.dart';

/// 🔥 Subscription
import '../../features/subscription/reader_subscription_screen.dart';

/// 🔥 Home Dashboards
import '../../features/home/mainicon/discover icon/discover_dashboard.dart';
import '../../features/home/mainicon/premium icon/premium_dashboard.dart';
import '../../features/home/mainicon/offline icon/offline_vault.dart';
import '../../features/home/mainicon/audio book icon/audio_book_dashboard.dart';
import '../../features/home/mainicon/content writing icon/content_writing_dashboard.dart';
import '../../features/home/mainicon/category icon/category_dashboard.dart';
import '../../features/home/mainicon/book battle icon/book_battle_dashboard.dart';
import '../../features/home/mainicon/help icon/help_support.dart';
import '../../features/home/mainicon/favorites icon/favorites_dashboard.dart';

/// 🔥 Reviews & Quotes
import 'package:book_app/features/home/mainicon/reviews icon/provider/review_provider.dart';
import 'package:book_app/features/home/mainicon/reviews icon/review_dashboard_screen.dart';
import 'package:book_app/features/home/mainicon/quotes icon//provider/quotes_provider.dart';
import 'package:book_app/features/home/mainicon/quotes icon/quotes_dashboard.dart';


class AppRoutes {
  /// 🔥 Route Names
  static const splash = '/splash';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const appShell = '/appshell';

  static const genreSelection = '/genreselection';
  static const readerGenres = '/readergenres';
  static const writerGenres = '/writergenres';
  static const profileUpload = '/profileupload';

  static const subscription = '/subscription';
  static const read = '/read';
  static const pdfReader = '/pdf-reader';

  static const AISummary = '/AISummary';
  static const StoryAnalytics = '/StoryAnalytics';
  

  /// Dashboards
  static const discover  = '/discover';
  static const premiumDashboard = '/premium-dashboard';
  static const offlineVault = '/offline-vault';
  static const audioBookDashboard = '/audio-book-dashboard';
  static const contentWritingDashboard = '/content-writing-dashboard';
  static const communityDashboard = '/community-dashboard';
  static const groups = '/community-groups';
  static const friends = '/community-friends';
  static const friendRequests = '/community-friend-requests';
  static const createGroup = '/community-create-group';
  static const chat = '/community-chat';
  static const reviewDashboard = '/review-dashboard';
  static const categoryDashboard = '/category-dashboard';
  static const bookBattleDashboard = '/book-battle-dashboard';
  static const quotesDashboard = '/quotes-dashboard';
  static const favoritesDashboard = '/favorites-dashboard';

  /// Writer
  static const earn = '/earn';
  static const writerDashboard = '/writerdashboard';
  static const createBook = '/writer/create-book';
  static const createBookEntry = '/writer/create-book-entry';
  static const writeChapter = '/writer/write-chapter';
  static const manageBooks = '/writer/manage-books';
  static const writerAnalytics = '/writer/analytics';
  static const writerProfile = '/writer/profile';
  static const writerSubscription = '/writer/subscription';
  static const writerPublish = '/writer/publish';

  /// Settings
  static const helpSupportDashboard = '/help-support-dashboard';
  static const language = '/language';
  static const settings = '/settings';

  static const String profile = '/profile';
  static const String library = '/library';

  static const String readerDashboard = '/readerDashboard';

  static const String bookDetail = '/bookDetail';

  /// 🔥 CENTRAL ROUTES (NO '/' HERE)
  static final Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),
    genreSelection: (_) => const RoleSelectionScreen(),
    readerGenres: (_) => const ReaderGenreSelectionScreen(),
    writerGenres: (_) => const WriterGenreSelectionScreen(),
    profileUpload: (_) => const ProfileUploadScreen(),
    readerDashboard: (context) =>
        const ReaderDashboardScreen(),

    home: (_) => const AppShell(),
    appShell: (_) => const AppShell(),
    subscription: (_) => const ReaderSubscriptionScreen(),

    bookDetail: (context) {
  final book = ModalRoute.of(context)!.settings.arguments as Book;
  return BookDetailScreen(book: book);
},


    AppRoutes.profile: (context) => ProfileScreen(isWriterMode: false,
  onSwap: () {},),
  AppRoutes.library: (context) => const MyLibraryScreen(),

    read: (_) => const AllBooksScreen(),
    AISummary: (_) => const AISummaryScreen(bookTitle: '',),
    StoryAnalytics:(_) =>const StoryAnalyticsScreen(),

    pdfReader: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as ReaderBook?;
      final fallback = DummyReaderData.continueReading.first;
      final selectedBook = args ?? fallback;

      final libraryBook = LibraryBook(
        id: selectedBook.id,
        title: selectedBook.title,
        author: selectedBook.author,
        category: 'General',
        imagePath: 'imagePath',
        pdfPath: selectedBook.pdfPath,
      );

      return PdfReaderScreen(book: libraryBook);
    },

    discover : (_) => const DiscoverDashboard(),
    premiumDashboard: (_) => const PremiumDashboard(),
    offlineVault: (_) => const OfflineVault(),
    audioBookDashboard: (_) => const AudioBookDashboard(),
    contentWritingDashboard: (_) =>
        const WriterAccessGuard(child: ContentWritingDashboard()),
    communityDashboard: (_) => const CommunityScreen(),
    groups: (_) => const GroupsScreen(),
    friends: (_) => const FriendsScreen(),
    friendRequests: (_) => const FriendRequestsScreen(),
    createGroup: (_) => const CreateGroupScreen(),

    chat: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return ChatScreen(
        title: args?['title'] ?? 'Chat',
        isPrivateChat: args?['isPrivateChat'] ?? false,
      );
    },

    reviewDashboard: (context) {
      final bookId =
          (ModalRoute.of(context)?.settings.arguments as String?) ?? 'BOOK_ID';
      return ChangeNotifierProvider(
        create: (_) => ReviewProvider(),
        child: ReviewDashboardScreen(bookId: bookId),
      );
    },

    categoryDashboard: (_) => const CategoryDashboard(),
    bookBattleDashboard: (_) => const BookBattleDashboard(),
    quotesDashboard: (_) => ChangeNotifierProvider(
  create: (_) => QuotesProvider(),
  child: const QuotesDashboard(),
),
  
    favoritesDashboard: (_) => ChangeNotifierProvider(
  create: (_) => FavoritesProvider(),
  child: const FavoritesDashboard(),
),

    earn: (_) => const WriterAccessGuard(child: WriterEarningsScreen()),
    writerDashboard: (context) {
      final auth = context.read<AuthProvider>();
      final user = auth.currentUser;
      final isWriter = user?.role == UserRole.writer;

      return WriterAccessGuard(
        child: WriterDashboard(
          currentUser: user,
          isGuest: auth.isGuest,
          isWriterMode: isWriter,
        ),
      );
    },

    createBook: (_) =>
        const WriterAccessGuard(child: CreateBookScreen()),
    createBookEntry: (_) =>
        const WriterAccessGuard(child: CreateBookPage()),
    writeChapter: (_) =>
        const WriterAccessGuard(child: WriteChapterScreen()),
    manageBooks: (_) =>
        const WriterAccessGuard(child: ManageBooksPage()),
    writerAnalytics: (_) =>
        const WriterAccessGuard(child: WriterAnalyticsScreen()),
    writerProfile: (_) =>
        const WriterAccessGuard(child: WriterProfileScreen()),
    writerSubscription: (_) =>
        const WriterAccessGuard(child: WriterSubscribersScreen()),
    writerPublish: (_) =>
        const WriterAccessGuard(child: WriterPublishPage()),

    helpSupportDashboard: (_) => const HelpSupportScreen(),
    language: (_) => const LanguageSelectionScreen(),
    settings: (_) => const SettingsScreen(),
  };
}