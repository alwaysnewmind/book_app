import 'package:book_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:book_app/navigation/app_shell.dart';
import 'package:book_app/features/auth/provider/auth_provider.dart';
import 'package:book_app/features/auth/widgets/role_guard.dart';

/// AUTH
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/profile_upload_screen.dart';
import '../../features/auth/screens/genre_selection_screen.dart';
import '../../features/auth/screens/reader_genre_selection_screen.dart';
import '../../features/auth/screens/writer_genre_selection_screen.dart';

/// PROFILE
import 'package:book_app/features/profile/profile_screen.dart';

/// LIBRARY
import 'package:book_app/features/library/screens/my_library_screen.dart';
import 'package:book_app/features/library/models/library_book.dart';

/// BOOKS
import '../../features/book/screen/all_books_screen.dart';
import 'package:book_app/features/book/screen/book_detail_screen.dart';
import 'package:book_app/models/writer_book_model.dart';

/// READER
import '../../features/reader/screens/pdf_reader_screen.dart';
import '../../features/reader/screens/reader_dashboard_screen.dart';
import '../../features/reader/data/dummy_reader_data.dart';

/// AI
import 'package:book_app/features/ai/ai_summary_screen.dart';

/// ANALYTICS
import '../../features/home/mainicon/story_analytics_icon/story_analytics_screen.dart';

/// SETTINGS
import '../../features/home/mainicon/setting_icon/settings_screen.dart';
import '../../features/home/mainicon/laguge_icon/language_selection_screen.dart';

/// COMMUNITY
import '../../features/community/screens/community_screen.dart';
import '../../features/community/screens/create_group_screen.dart';
import '../../features/community/screens/groups_screen.dart';
import '../../features/community/screens/friends_screen.dart';
import '../../features/community/screens/friend_requests_screen.dart';
import '../../features/community/screens/chat_screen.dart';

/// WRITER
import '../../features/writer/screens/writer_dashboard.dart';
import '../../features/writer/screens/writer_earnings_screen.dart';
import 'package:book_app/features/writer/create_book_entry_page.dart';
import 'package:book_app/features/writer/create_book_screen.dart';
import 'package:book_app/features/writer/screens/manage_books_page.dart';
import 'package:book_app/features/writer/screens/write_chapter_screen.dart';
import 'package:book_app/features/writer/screens/writer_analytics_screen.dart';
import 'package:book_app/features/writer/screens/writer_profile_screen.dart';
import 'package:book_app/features/writer/screens/writer_publish_page.dart';
import 'package:book_app/features/writer/screens/writer_subscription_screen.dart';

/// HOME ICON DASHBOARDS
import '../../features/home/mainicon/discover_icon/discover_dashboard.dart';
import '../../features/home/mainicon/premium_icon/premium_dashboard.dart';
import '../../features/home/mainicon/offline_icon/offline_vault.dart';
import '../../features/home/mainicon/audio_book_icon/audio_book_dashboard.dart';
import '../../features/home/mainicon/content_writing_icon/content_writing_dashboard.dart';
import '../../features/home/mainicon/help_icon/help_support.dart';
import '../../features/home/mainicon/category_icon/category_dashboard.dart';
import '../../features/home/mainicon/book_battle_icon/book_battle_dashboard.dart';
import '../../features/home/mainicon/favorites_icon/favorites_dashboard.dart';

/// PROVIDERS
import 'package:book_app/features/home/mainicon/reviews_icon/provider/review_provider.dart';
import 'package:book_app/features/home/mainicon/reviews_icon/review_dashboard_screen.dart';
import 'package:book_app/features/home/mainicon/quotes_icon/provider/quotes_provider.dart';
import 'package:book_app/features/home/mainicon/quotes_icon/quotes_dashboard.dart';
import 'package:book_app/features/home/mainicon/favorites_icon/provider/favorites_provider.dart';

/// SUBSCRIPTION
import '../../features/subscription/reader_subscription_screen.dart';

class AppRoutes {

  /// ROUTE NAMES
  static const splash = '/splash';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';

  static const genreSelection = '/genreselection';
  static const readerGenres = '/readergenres';
  static const writerGenres = '/writergenres';
  static const profileUpload = '/profileupload';

  static const readerDashboard = '/readerDashboard';

  static const subscription = '/subscription';
  static const read = '/read';
  static const pdfReader = '/pdfReader';

  static const aiSummary = '/aiSummary';
  static const storyAnalytics = '/storyAnalytics';

  static const discover = '/discover';
  static const premiumDashboard = '/premiumDashboard';
  static const offlineVault = '/offlineVault';
  static const audioBookDashboard = '/audioBookDashboard';
  static const contentWritingDashboard = '/contentWritingDashboard';

  static const communityDashboard = '/communityDashboard';
  static const groups = '/groups';
  static const friends = '/friends';
  static const friendRequests = '/friendRequests';
  static const createGroup = '/createGroup';
  static const chat = '/chat';

  static const reviewDashboard = '/reviewDashboard';
  static const quotesDashboard = '/quotesDashboard';
  static const favoritesDashboard = '/favoritesDashboard';
  

  static const writerDashboard = '/writerDashboard';
  static const earn = '/earn';

  static const categoryDashboard = '/categoryDashboard';
  static const bookBattleDashboard = '/bookBattleDashboard';

  static const helpSupportDashboard = '/helpSupportDashboard';
  static const language = '/language';
  static const settings = '/settings';

  static const profile = '/profile';
  static const library = '/library';
  static const bookDetail = '/bookDetail';

  static const createBook = '/writer/createBook';
  static const createBookEntry = '/writer/createBookEntry';
  static const writeChapter = '/writer/writeChapter';
  static const manageBooks = '/writer/manageBooks';
  static const writerAnalytics = '/writer/analytics';
  static const writerProfile = '/writer/profile';
  static const writerSubscription = '/writer/subscription';
  static const writerPublish = '/writer/publish';

  /// STATIC ROUTES
  static final Map<String, WidgetBuilder> routes = {

    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),
    AppRoutes.profile: (context) => ProfileScreen(isWriterMode: false, onSwap: () {},),

    genreSelection: (_) => const RoleSelectionScreen(),
    readerGenres: (_) => const ReaderGenreSelectionScreen(),
    writerGenres: (_) => const WriterGenreSelectionScreen(),
    profileUpload: (_) => const ProfileUploadScreen(),

    home: (_) => const AppShell(),
    readerDashboard: (_) => const ReaderDashboardScreen(),

    subscription: (_) => const ReaderSubscriptionScreen(),
    read: (_) => const AllBooksScreen(),

    discover: (_) => const DiscoverDashboard(),
    premiumDashboard: (_) => const PremiumDashboard(),
    offlineVault: (_) => const OfflineVault(),
    audioBookDashboard: (_) => const AudioBookDashboard(),

    categoryDashboard: (_) => const CategoryDashboard(),
    bookBattleDashboard: (_) => const BookBattleDashboard(),

    contentWritingDashboard: (_) =>
        const WriterAccessGuard(child: ContentWritingDashboard()),

    communityDashboard: (_) => const CommunityScreen(),
    groups: (_) => const GroupsScreen(),
    friends: (_) => const FriendsScreen(),
    friendRequests: (_) => const FriendRequestsScreen(),
    createGroup: (_) => const CreateGroupScreen(),

    helpSupportDashboard: (_) => const HelpSupportScreen(),
    language: (_) => const LanguageSelectionScreen(),
    settings: (_) => const SettingsScreen(),
    storyAnalytics: (_) => const StoryAnalyticsScreen(),

    library: (_) => const MyLibraryScreen(),
    aiSummary: (_) => const AISummaryScreen(bookTitle: '',),

    reviewDashboard: (context) { 
      final bookId = (ModalRoute.of(context)?.settings.arguments as String?) ?? 'BOOK_ID'; 
      return ChangeNotifierProvider( create: (_) => 
    ReviewProvider(), child: 
    ReviewDashboardScreen(bookId: bookId), ); },

    quotesDashboard: (_) => ChangeNotifierProvider(
          create: (_) => QuotesProvider(),
          child: const QuotesDashboard(),
        ),

    favoritesDashboard: (_) => ChangeNotifierProvider(
          create: (_) => FavoritesProvider(),
          child: const FavoritesDashboard(),
        ),

    earn: (_) =>
        const WriterAccessGuard(child: WriterEarningsScreen()),

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
  };

  /// DYNAMIC ROUTES
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {

    switch (settings.name) {

      case bookDetail:
        final book = settings.arguments as Book?;
        if (book == null) return _errorRoute("Book not found");
        return MaterialPageRoute(
          builder: (_) => BookDetailScreen(book: book),
        );

      case pdfReader:
        final ReaderBook? args = settings.arguments as ReaderBook?;
        final ReaderBook fallback = DummyReaderData.continueReading.first;
        final ReaderBook selectedBook = args ?? fallback;

        final libraryBook = LibraryBook(
          id: selectedBook.id,
          title: selectedBook.title,
          author: selectedBook.author,
          category: "General",
          imagePath: "",
          pdfPath: selectedBook.pdfPath,
        );

        return MaterialPageRoute(
          builder: (_) => PdfReaderScreen(book: libraryBook),
        );


      case chat:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ChatScreen(
            title: args?['title'] ?? "Chat",
            isPrivateChat: args?['isPrivateChat'] ?? false,
          ),
        );

      default:
        return _errorRoute("Route not found");
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }


}