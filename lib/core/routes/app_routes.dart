import 'package:book_app/features/auth/screens/genre_selection_screen.dart';
import 'package:book_app/features/auth/screens/reader_genre_selection_screen.dart' show ReaderGenreSelectionScreen;
import 'package:book_app/features/auth/screens/profile_upload_screen.dart';
import 'package:book_app/features/auth/screens/signup_screen.dart';
import 'package:book_app/features/auth/screens/writer_genre_selection_screen.dart' show WriterGenreSelectionScreen;
import 'package:book_app/features/writer/create_book_entry_page.dart';
import 'package:book_app/features/writer/create_book_screen.dart';
import 'package:book_app/features/writer/screens/manage_books_page.dart';
import 'package:book_app/features/writer/screens/write_chapter_screen.dart';
import 'package:book_app/features/writer/screens/writer_analytics_screen.dart';
import 'package:book_app/features/writer/screens/writer_dashboard.dart';
import 'package:book_app/features/writer/screens/writer_profile_screen.dart';
import 'package:book_app/features/writer/screens/writer_publish_page.dart';
import 'package:book_app/features/writer/screens/writer_subscription_screen.dart';
import 'package:book_app/navigation/app_shell.dart';
import 'package:book_app/models/user_model.dart';
import 'package:book_app/providers/auth_provider.dart';
import 'package:book_app/features/auth/widgets/role_guard.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 🔥 Auth
import '../../features/auth/screens/splash_screen.dart';

/// 🔥 Reading
import '../../features/book/all_books_screen.dart';

/// 🔥 Settings
import '../../features/settings/screens/settings_screen.dart';
import '../../features/settings/language_selection_screen.dart';

/// 🔥 Writer
import '../../features/writer/screens/writer_earnings_screen.dart';

/// 🔥 Community
import '../../features/community/screens/community_screen.dart';
import '../../features/community/screens/create_group_screen.dart';
import '../../features/community/screens/groups_screen.dart';
import '../../features/community/screens/friends_screen.dart';
import '../../features/community/screens/friend_requests_screen.dart';
import '../../features/community/screens/chat_screen.dart';

/// 🔥 Subscription
import '../../features/subscription/reader_subscription_screen.dart';
import '../../features/reader/screens/reader_dashboard_screen.dart';
import '../../features/reader/screens/reader_screen.dart';
import '../../features/reader/screens/pdf_reader_screen.dart';
import '../../features/reader/data/dummy_reader_data.dart';

/// 🔥 Home Dashboards
import '../../features/home/mainicon/discover_dashboard.dart';
import '../../features/home/mainicon/premium_dashboard.dart';
import '../../features/home/mainicon/offline_vault.dart';
import '../../features/home/mainicon/audio_book_dashboard.dart';
import '../../features/home/mainicon/content_writing_dashboard.dart';
import 'package:book_app/features/reviews/provider/review_provider.dart';
import 'package:book_app/features/reviews/review_dashboard_screen.dart';
import '../../features/home/mainicon/category_dashboard.dart';
import '../../features/home/mainicon/book_battle_dashboard.dart';
import 'package:book_app/features/quotes/provider/quotes_provider.dart';
import 'package:book_app/features/quotes/quotes_dashboard.dart';
import '../../features/home/mainicon/help_support.dart';
import '../../features/home/mainicon/favorites_dashboard.dart';
import 'package:book_app/features/auth/screens/login_screen.dart';

class AppRoutes {
  /// 🔥 Initial Routes
  static const String  splash = "/";
  static const String login = "/login";
  static const String home = '/home';
  static const String signup = '/signup';
  static const String genreSelection ="/genreselection";
  static const String appShell = "/appshell";
  static const String bookDetail ="/bookdetail";
  static const String subscription = "/subscription";
   static const readerGenres = '/readergenres';
  static const writerGenres = '/writergenres';
  static const profileUpload = '/profileupload';
  static const readerDashboard = '/readerdashboard';
  static const readerScreen = '/readerscreen';
  static const pdfReader = '/pdf-reader';
  static const writerDashboard = '/writerdashboard';
  static const createBook = '/writer/create-book';
  static const createBookEntry = '/writer/create-book-entry';
  static const writeChapter = '/writer/write-chapter';
  static const manageBooks = '/writer/manage-books';
  static const writerAnalytics = '/writer/analytics';
  static const writerProfile = '/writer/profile';
  static const writerSubscription = '/writer/subscription';
  static const writerPublish = '/writer/publish';

  /// 🔥 Reading
  static const read = "/read";

  /// 🔥 Dashboards
  static const discoverDashboard = "/discover-dashboard";
  static const premiumDashboard = "/premium-dashboard";
  static const offlineVault = "/offline-vault";
  static const audioBookDashboard = "/audio-book-dashboard";
  static const contentWritingDashboard = "/content-writing-dashboard";
  static const communityDashboard = "/community-dashboard";
  static const groups = '/community-groups';
  static const friends = '/community-friends';
  static const friendRequests = '/community-friend-requests';
  static const createGroup = '/community-create-group';
  static const chat = '/community-chat';
  static const reviewDashboard = "/review-dashboard";
  static const categoryDashboard = "/category-dashboard";
  static const bookBattleDashboard = "/book-battle-dashboard";
  static const quotesDashboard = "/quotes-dashboard";
  static const favoritesDashboard = "/favorites-dashboard";

  /// 🔥 Writer
  static const earn = "/earn";

  /// 🔥 Settings
  static const helpSupportDashboard = "/help-support-dashboard";
  static const language = "/language";
  static const settings = "/settings";

  /// 🔥 CENTRAL ROUTE MAP
  static final Map<String, WidgetBuilder> routes = {
    /// Auth Flow
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),
    genreSelection: (_) => const RoleSelectionScreen(), // 👈 ADD
    readerGenres: (_) => const ReaderGenreSelectionScreen(),
    writerGenres: (_) => const WriterGenreSelectionScreen(),
    profileUpload: (_) => const ProfileUploadScreen(),
    home: (_) => const AppShell(),
    appShell: (_) => const AppShell(),

    
    subscription: (_) => const ReaderSubscriptionScreen(),

    /// Reader
    readerDashboard: (_) => const ReaderDashboardScreen(),
    readerScreen: (_) => const ReaderScreen(isLocked: false),
    pdfReader: (context) {
      final book = ModalRoute.of(context)?.settings.arguments as ReaderBook?;
      final fallbackBook = DummyReaderData.continueReading.first;
      return PdfReaderScreen(book: book ?? fallbackBook);
    },

    /// Reading
    read: (_) => const AllBooksScreen(),

    /// Dashboards
    discoverDashboard: (_) => const DiscoverDashboard(),
    premiumDashboard: (_) => const PremiumDashboard(),
    offlineVault: (_) => const OfflineVault(),
    audioBookDashboard: (_) => const AudioBookDashboard(),
    contentWritingDashboard: (_) => const WriterAccessGuard(child: ContentWritingDashboard()),
    communityDashboard: (_) => const CommunityScreen(),
    groups: (_) => const GroupsScreen(),
    friends: (_) => const FriendsScreen(),
    createGroup: (_) => const CreateGroupScreen(),
    friendRequests: (_) => const FriendRequestsScreen(),
    chat: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return ChatScreen(
        title: (args?['title'] as String?) ?? 'Chat',
        isPrivateChat: (args?['isPrivateChat'] as bool?) ?? false,
      );
    },
    reviewDashboard: (context) {
      final bookId = (ModalRoute.of(context)?.settings.arguments as String?) ?? 'BOOK_ID';
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
    favoritesDashboard: (_) => const FavoritesDashboard(),

    /// Writer
    earn: (_) => const WriterAccessGuard(child: WriterEarningsScreen()),
    writerDashboard: (context) {
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.currentUser;
      final isWriterMode = user?.role == UserRole.writer;

      return WriterAccessGuard(
        child: WriterDashboard(
          currentUser: user,
          isGuest: authProvider.isGuest,
          isWriterMode: isWriterMode,
        ),
      );
    },
    createBook: (_) => const WriterAccessGuard(child: CreateBookScreen()),
    createBookEntry: (_) => const WriterAccessGuard(child: CreateBookPage()),
    writeChapter: (_) => const WriterAccessGuard(child: WriteChapterScreen()),
    manageBooks: (_) => const WriterAccessGuard(child: ManageBooksPage()),
    writerAnalytics: (_) => const WriterAccessGuard(child: WriterAnalyticsScreen()),
    writerProfile: (_) => const WriterAccessGuard(child: WriterProfileScreen()),
    writerSubscription: (_) => const WriterAccessGuard(child: WriterSubscribersScreen()),
    writerPublish: (_) => const WriterAccessGuard(child: WriterPublishPage()),

    /// Settings
    helpSupportDashboard: (_) => const HelpSupportScreen(),
    language: (_) => const LanguageSelectionScreen(),
    settings: (_) => const SettingsScreen(),
  };
}
