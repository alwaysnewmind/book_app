import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:book_app/models/user_model.dart';
import 'package:book_app/providers/auth_provider.dart';

/// 🔥 Auth
import 'package:book_app/features/auth/screens/splash_screen.dart';
import 'package:book_app/features/auth/screens/login_screen.dart';
import 'package:book_app/features/auth/screens/signup_screen.dart';
import 'package:book_app/features/auth/screens/genre_selection_screen.dart';
import 'package:book_app/features/auth/screens/reader_genre_selection_screen.dart';
import 'package:book_app/features/auth/screens/writer_genre_selection_screen.dart';

/// 🔥 Shell
import 'package:book_app/navigation/app_shell.dart';

/// 🔥 Reader
import 'package:book_app/features/reader/screens/reader_dashboard_screen.dart';
import 'package:book_app/features/reader/screens/reader_screen.dart';
import 'package:book_app/features/reader/screens/pdf_reader_screen.dart';
import 'package:book_app/features/reader/data/dummy_reader_data.dart';

/// 🔥 Reading
import 'package:book_app/features/book/all_books_screen.dart';
import 'package:book_app/features/home/mainicon/story_analytics.dart';

/// 🔥 Subscription
import 'package:book_app/features/subscription/reader_subscription_screen.dart';

/// 🔥 Writer
import 'package:book_app/features/writer/screens/writer_dashboard.dart';
import 'package:book_app/features/writer/screens/writer_analytics_screen.dart';
import 'package:book_app/features/writer/screens/writer_profile_screen.dart';
import 'package:book_app/features/writer/screens/writer_publish_page.dart';
import 'package:book_app/features/writer/screens/writer_subscription_screen.dart';
import 'package:book_app/features/writer/screens/writer_earnings_screen.dart';
import 'package:book_app/features/writer/create_book_screen.dart';
import 'package:book_app/features/writer/create_book_entry_page.dart';
import 'package:book_app/features/writer/screens/manage_books_page.dart';
import 'package:book_app/features/writer/screens/write_chapter_screen.dart';

/// 🔥 Community
import 'package:book_app/features/community/screens/community_screen.dart';
import 'package:book_app/features/community/screens/groups_screen.dart';
import 'package:book_app/features/community/screens/friends_screen.dart';
import 'package:book_app/features/community/screens/friend_requests_screen.dart';
import 'package:book_app/features/community/screens/create_group_screen.dart';
import 'package:book_app/features/community/screens/chat_screen.dart';

/// 🔥 Dashboards
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

/// 🔥 Settings
import 'package:book_app/features/settings/screens/settings_screen.dart';
import 'package:book_app/features/settings/language_selection_screen.dart';

/// 🔥 AI
import 'package:book_app/features/ai/ai_summary_screen.dart';

class AppRoutes {
  /// 🔥 Core
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';

  /// 🔥 Auth
  static const genreSelection = '/genreselection';
  static const readerGenres = '/readergenres';
  static const writerGenres = '/writergenres';
    static const String bookDetail ="/bookdetail";
      static const String subscription = "/subscription";

  /// 🔥 Reader
  static const readerDashboard = '/readerdashboard';
  static const readerScreen = '/readerscreen';
  static const pdfReader = '/pdf-reader';

  /// 🔥 Writer
  static const writerDashboard = '/writerdashboard';
  static const createBook = '/writer/create-book';
  static const createBookEntry = '/writer/create-book-entry';
  static const writeChapter = '/writer/write-chapter';
  static const manageBooks = '/writer/manage-books';
  static const writerAnalytics = '/writer/analytics';
  static const writerProfile = '/writer/profile';
  static const writerSubscription = '/writer/subscription';
  static const writerPublish = '/writer/publish';
  static const earn = '/earn';

  /// 🔥 Reading
  static const read = '/read';
  static const storyAnalytics = '/story-analytics';

  /// 🔥 Community
  static const communityDashboard = '/community-dashboard';
  static const groups = '/community-groups';
  static const friends = '/community-friends';
  static const friendRequests = '/community-friend-requests';
  static const createGroup = '/community-create-group';
  static const chat = '/community-chat';

  /// 🔥 Dashboards
  static const discoverDashboard = '/discover-dashboard';
  static const premiumDashboard = '/premium-dashboard';
  static const offlineVault = '/offline-vault';
  static const audioBookDashboard = '/audio-book-dashboard';
  static const contentWritingDashboard = '/content-writing-dashboard';
  static const reviewDashboard = '/review-dashboard';
  static const categoryDashboard = '/category-dashboard';
  static const bookBattleDashboard = '/book-battle-dashboard';
  static const quotesDashboard = '/quotes-dashboard';
  static const favoritesDashboard = '/favorites-dashboard';

  /// 🔥 Settings
  static const helpSupportDashboard = '/help-support-dashboard';
  static const language = '/language';
  static const settings = '/settings';

  /// 🔥 AI
  static const aiSummary = '/ai-summary';

  /// 🔥 STATIC ROUTES (NO PROVIDER LOGIC HERE)
  static final Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),

    genreSelection: (_) => const RoleSelectionScreen(),
    readerGenres: (_) => const ReaderGenreSelectionScreen(),
    writerGenres: (_) => const WriterGenreSelectionScreen(),

    home: (_) => const AppShell(),

    readerDashboard: (_) => const ReaderDashboardScreen(),
    readerScreen: (_) => const ReaderScreen(isLocked: false),

    read: (_) => const AllBooksScreen(),
    storyAnalytics: (_) => const StoryAnalyticsScreen(),

    discoverDashboard: (_) => const DiscoverDashboard(),
    premiumDashboard: (_) => const PremiumDashboard(),
    offlineVault: (_) => const OfflineVault(),
    audioBookDashboard: (_) => const AudioBookDashboard(),
    contentWritingDashboard: (_) => const ContentWritingDashboard(),
    reviewDashboard: (_) => const ReviewDashboardScreen(),
    categoryDashboard: (_) => const CategoryDashboard(),
    bookBattleDashboard: (_) => const BookBattleDashboard(),
    quotesDashboard: (_) => const QuotesDashboard(),
    favoritesDashboard: (_) => const FavoritesDashboard(),

    communityDashboard: (_) => const CommunityScreen(),
    groups: (_) => const GroupsScreen(),
    friends: (_) => const FriendsScreen(),
    friendRequests: (_) => const FriendRequestsScreen(),
    createGroup: (_) => const CreateGroupScreen(),

    earn: (_) => const WriterEarningsScreen(),
    createBook: (_) => const CreateBookScreen(),
    createBookEntry: (_) => const CreateBookPage(),
    writeChapter: (_) => const WriteChapterScreen(),
    manageBooks: (_) => const ManageBooksPage(),
    writerAnalytics: (_) => const WriterAnalyticsScreen(),
    writerProfile: (_) => const WriterProfileScreen(),
    writerSubscription: (_) => const WriterSubscribersScreen(),
    writerPublish: (_) => const WriterPublishPage(),

    helpSupportDashboard: (_) => const HelpSupportScreen(),
    language: (_) => const LanguageSelectionScreen(),
    settings: (_) => const SettingsScreen(),
  };

  /// 🔥 DYNAMIC ROUTES (SAFE)
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case writerDashboard:
        return MaterialPageRoute(
          builder: (context) {
            final auth = context.watch<AuthProvider>();
            final user = auth.currentUser;

            final isWriterMode =
                user?.currentMode == UserMode.writer ||
                user?.currentMode == UserMode.author;

            return WriterDashboard(
              currentUser: user,
              isGuest: auth.isGuest,
              isWriterMode: isWriterMode,
            );
          },
        );

      case pdfReader:
        final book = settings.arguments as ReaderBook?;
        final fallback = DummyReaderData.continueReading.first;
        return MaterialPageRoute(
          builder: (_) => PdfReaderScreen(book: book ?? fallback),
        );

      case chat:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ChatScreen(
            title: args?['title'] ?? 'Chat',
            isPrivateChat: args?['isPrivateChat'] ?? false,
          ),
        );

      case aiSummary:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => AISummaryScreen(
            bookTitle: args['bookTitle'],
            currentUser: args['currentUser'],
            isGuest: args['isGuest'] ?? true,
          ),
        );
    }
    return null;
  }
}