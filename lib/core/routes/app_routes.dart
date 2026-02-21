import 'package:book_app/features/home/mainicon/audio_book_dashboard.dart' show AudioBookDashboard;
import 'package:book_app/features/home/mainicon/book_battle_dashboard.dart' show BookBattleDashboard;
import 'package:book_app/features/home/mainicon/category_dashboard.dart' show CategoryDashboard;
import 'package:book_app/features/home/mainicon/content_writing_dashboard.dart' show ContentWritingDashboard;
import 'package:book_app/features/home/mainicon/discover_dashboard.dart' show DiscoverDashboard;
import 'package:book_app/features/home/mainicon/favorites_dashboard.dart' show FavoritesDashboard;
import 'package:book_app/features/home/mainicon/help_support.dart' show HelpSupportScreen;
import 'package:book_app/features/home/mainicon/offline_vault.dart' show OfflineVault;
import 'package:book_app/features/home/mainicon/premium_dashboard.dart' show PremiumDashboard;
import 'package:book_app/features/home/mainicon/quotes_dashboard.dart' show QuotesDashboard;
import 'package:book_app/features/home/mainicon/review_dashboard.dart' show ReviewDashboardScreen;
import 'package:flutter/material.dart';

/// =======================================================
/// AUTH
/// =======================================================
import 'package:book_app/features/auth/screens/auth_entry_screen.dart';

/// =======================================================
/// LIBRARY
/// =======================================================
import 'package:book_app/features/library/library_screen.dart';
import 'package:book_app/features/profile/favorites_screen.dart';
import 'package:book_app/features/profile/downloads_screen.dart';

/// =======================================================
/// SUBSCRIPTION
/// =======================================================
import 'package:book_app/features/subscription/reader_subscription_screen.dart';

/// =======================================================
/// WRITER
/// =======================================================
import 'package:book_app/features/writer/screens/writer_dashboard.dart';
import 'package:book_app/features/writer/screens/manage_books_page.dart';
import 'package:book_app/features/writer/create_book_screen.dart';
import 'package:book_app/features/writer/screens/writer_publish_page.dart';
import 'package:book_app/features/writer/screens/writer_analytics_screen.dart';
import 'package:book_app/features/writer/screens/writer_earnings_screen.dart';
import 'package:book_app/features/writer/screens/writer_profile_screen.dart';
import 'package:book_app/features/writer/screens/writer_subscription_screen.dart';

/// =======================================================
/// SERVICES (OLD)
/// =======================================================
import 'package:book_app/features/services/audio_screen.dart';
import 'package:book_app/features/community/screens/community_home_screen.dart';
import 'package:book_app/features/category/screens/category_screen.dart';

/// =======================================================
/// AI
/// =======================================================
import 'package:book_app/features/ai/ai_chat_screen.dart';
import 'package:book_app/features/ai/ai_mood_screen.dart';
import 'package:book_app/features/ai/ai_recommendation_screen.dart';
import 'package:book_app/features/ai/ai_summary_screen.dart';
import 'package:book_app/features/ai/ai_voice_screen.dart';
import 'package:book_app/features/ai/ai_writing_assistant_screen.dart';

/// =======================================================
/// SETTINGS
/// =======================================================
import 'package:book_app/features/settings/screens/settings_screen.dart';
import 'package:book_app/features/settings/language_selection_screen.dart';

/// =======================================================
/// BOOK
/// =======================================================
import 'package:book_app/features/home/screens/pdf_viewer_screen.dart';

/// =======================================================
/// HOME SERVICE DASHBOARDS (NEW ICON SCREENS)
/// =======================================================


/// =======================================================
/// MODELS
/// =======================================================
import 'package:book_app/models/user_model.dart';

/// =======================================================
/// ROUTE NAMES
/// =======================================================
class AppRoutes {
  // AUTH
  static const login = '/login';

  // LIBRARY
  static const library = '/library';
  static const favorites = '/favorites';
  static const downloads = '/downloads';

  // SUBSCRIPTION
  static const subscription = '/subscription';

  // WRITER
  static const writerDashboard = '/writer-dashboard';
  static const writerManageBooks = '/writer-manage-books';
  static const writerCreateBook = '/writer-create-book';
  static const writerPublish = '/writer-publish';
  static const writerAnalytics = '/writer-analytics';
  static const writerEarnings = '/writer-earnings';
  static const writerProfile = '/writer-profile';
  static const writerSubscription = '/writer-subscription';

  // OLD SERVICES
  static const audio = '/audio';
  static const community = '/community';
  static const category = '/category';

  // AI
  static const aiChat = '/ai-chat';
  static const aiMood = '/ai-mood';
  static const aiRecommendation = '/ai-recommendation';
  static const aiSummary = '/ai-summary';
  static const aiVoice = '/ai-voice';
  static const aiWritingAssistant = '/ai-writing-assistant';

  // SETTINGS
  static const settings = '/settings';
  static const language = '/language';

  // BOOK
  static const bookDetail = '/book-detail';

  // ===============================
  // NEW HOME ICON DASHBOARDS
  // ===============================
  static const discoverDashboard = '/discover-dashboard';
  static const premiumDashboard = '/premium-dashboard';
  static const offlineVault = '/offline-vault';
  static const audioBookDashboard = '/audio-book-dashboard';
  static const contentWritingDashboard = '/content-writing-dashboard';
  static const communityDashboard = '/community-dashboard';
  static const reviewDashboard = '/review-dashboard';
  static const categoryDashboard = '/category-dashboard';
  static const bookBattleDashboard = '/book-battle-dashboard';
  static const quotesDashboard = '/quotes-dashboard';
  static const helpSupportDashboard = '/help-support-dashboard';
  static const favoritesDashboard = '/favorites-dashboard';
  static const aiSummaryDashboard = '/ai-summary-dashboard';
  static const monetizeDashboard = '/monetize-dashboard';
  static const storyAnalystDashboard = '/story-analyst-dashboard';
  static const earnAsWriterDashboard = '/earn-as-writer-dashboard';
}

/// =======================================================
/// ROUTES MAP
/// =======================================================
Map<String, WidgetBuilder> appRoutes(
  AppUser? currentUser,
  bool isGuest,
) {
  return {

    /// AUTH
    AppRoutes.login: (_) => const AuthEntryScreen(),

    /// LIBRARY
    AppRoutes.library: (_) => const LibraryScreen(),
    AppRoutes.favorites: (_) => const FavoritesScreen(),
    AppRoutes.downloads: (_) => const DownloadsScreen(),

    /// SUBSCRIPTION
    AppRoutes.subscription: (_) => const ReaderSubscriptionScreen(),

    /// WRITER
    AppRoutes.writerDashboard: (_) => WriterDashboard(
          currentUser: currentUser,
          isGuest: isGuest,
          isWriterMode: true,
        ),
    AppRoutes.writerManageBooks: (_) => const ManageBooksPage(),
    AppRoutes.writerCreateBook: (_) => const CreateBookScreen(),
    AppRoutes.writerPublish: (_) => const WriterPublishPage(),
    AppRoutes.writerAnalytics: (_) => const WriterAnalyticsScreen(),
    AppRoutes.writerEarnings: (_) => const WriterEarningsScreen(),
    AppRoutes.writerProfile: (_) => const WriterProfileScreen(),
    AppRoutes.writerSubscription: (_) => const WriterSubscribersScreen(),

    /// OLD SERVICES
    AppRoutes.audio: (_) => const AudioScreen(),
    AppRoutes.community: (_) => const CommunityHomeScreen(),
    AppRoutes.category: (_) => const CategoryScreen(),

    /// AI
    AppRoutes.aiChat: (_) => const AIChatScreen(),
    AppRoutes.aiMood: (_) => const AIMoodScreen(),
    AppRoutes.aiRecommendation: (_) => const AIRecommendationScreen(),
    AppRoutes.aiSummary: (_) => const AISummaryScreen(bookTitle: ''),
    AppRoutes.aiVoice: (_) => const AIVoiceScreen(),
    AppRoutes.aiWritingAssistant: (_) =>
        const AIWritingAssistantScreen(),

    /// SETTINGS
    AppRoutes.settings: (_) => const SettingsScreen(),
    AppRoutes.language: (_) => const LanguageSelectionScreen(),

    /// BOOK
    AppRoutes.bookDetail: (_) => const PdfViewerScreen(),

    // ==================================
    // NEW HOME ICON DASHBOARDS
    // ==================================
    AppRoutes.discoverDashboard: (_) => const DiscoverDashboard(),
    AppRoutes.premiumDashboard: (_) => const PremiumDashboard(),
    AppRoutes.offlineVault: (_) => const OfflineVault(),
    AppRoutes.audioBookDashboard: (_) => const AudioBookDashboard(),
    AppRoutes.contentWritingDashboard: (_) =>
        const ContentWritingDashboard(),
    AppRoutes.communityDashboard: (_) => const CommunityHomeScreen(),
    AppRoutes.reviewDashboard: (_) => const ReviewDashboardScreen(),
    AppRoutes.categoryDashboard: (_) => const CategoryDashboard(),
    AppRoutes.bookBattleDashboard: (_) => const BookBattleDashboard(),
    AppRoutes.quotesDashboard: (_) => const QuotesDashboard(),
    AppRoutes.helpSupportDashboard: (_) => const HelpSupportScreen(),
    AppRoutes.favoritesDashboard: (_) => const FavoritesDashboard(),
    
  };
}
/// =======================================================
/// FALLBACK SCREEN
/// =======================================================
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title – Coming Soon',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
