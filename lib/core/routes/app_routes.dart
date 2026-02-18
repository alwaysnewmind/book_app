import 'package:flutter/material.dart';

// AUTH
import 'package:book_app/features/auth/screens/auth_entry_screen.dart';

// LIBRARY
import 'package:book_app/features/library/library_screen.dart';

// SUBSCRIPTION
import 'package:book_app/features/subscription/reader_subscription_screen.dart';

// WRITER
import 'package:book_app/features/writer/screens/writer_dashboard.dart';
import 'package:book_app/features/writer/screens/manage_books_page.dart';
import 'package:book_app/features/writer/create_book_screen.dart';
import 'package:book_app/features/writer/screens/writer_publish_page.dart';
import 'package:book_app/features/writer/screens/writer_analytics_screen.dart';
import 'package:book_app/features/writer/screens/writer_earnings_screen.dart';
import 'package:book_app/features/writer/screens/writer_profile_screen.dart';
import 'package:book_app/features/writer/screens/writer_subscription_screen.dart';

// SERVICES
import 'package:book_app/features/services/audio_screen.dart';
import 'package:book_app/features/services/community_screen.dart';
import 'package:book_app/features/services/challenges_screen.dart';

// AI
import 'package:book_app/features/ai/ai_chat_screen.dart';
import 'package:book_app/features/ai/ai_mood_screen.dart';
import 'package:book_app/features/ai/ai_recommendation_screen.dart';
import 'package:book_app/features/ai/ai_voice_screen.dart';
import 'package:book_app/features/ai/ai_writing_assistant_screen.dart';

// BOOK

// MODELS
import 'package:book_app/models/user_model.dart';

/// =======================================================
/// CENTRAL ROUTE NAMES (Single Source of Truth)
/// =======================================================
class AppRoutes {
  static const login = '/login';
  static const library = '/library';
  static const subscription = '/subscription';

  static const writerDashboard = '/writer-dashboard';
  static const writerManageBooks = '/writer-manage-books';
  static const writerCreateBook = '/writer-create-book';
  static const writerPublish = '/writer-publish';
  static const writerAnalytics = '/writer-analytics';
  static const writerEarnings = '/writer-earnings';
  static const writerProfile = '/writer-profile';
  static const writerSubscription = '/writer-subscription';

  static const audio = '/audio';
  static const community = '/community';
  static const challenges = '/challenges';
  static const premium = '/premium';

  static const aiChat = '/ai-chat';
  static const aiMood = '/ai-mood';
  static const aiRecommendation = '/ai-recommendation';
  static const aiSummary = '/ai-summary';
  static const aiVoice = '/ai-voice';
  static const aiWritingAssistant = '/ai-writing-assistant';

  static const bookDetail = '/book-detail';
}

/// =======================================================
/// ROUTE MAP (MaterialApp.routes)
/// =======================================================
Map<String, WidgetBuilder> appRoutes(AppUser? currentUser, bool isGuest) {
  return {
    // AUTH
    AppRoutes.login: (_) => const AuthEntryScreen(),

    // LIBRARY
    AppRoutes.library: (_) => const LibraryScreen(),

    // SUBSCRIPTION
    AppRoutes.subscription: (_) => const ReaderSubscriptionScreen(),

    // WRITER DASHBOARD & CHILD SCREENS
    AppRoutes.writerDashboard: (_) => WriterDashboard(
          currentUser: currentUser,
          isGuest: isGuest,
        ),
    AppRoutes.writerManageBooks: (_) => const ManageBooksPage(),
    AppRoutes.writerCreateBook: (_) => const CreateBookScreen(),
    AppRoutes.writerPublish: (_) => const WriterPublishPage(),
    AppRoutes.writerAnalytics: (_) => const WriterAnalyticsScreen(),
    AppRoutes.writerEarnings: (_) => const WriterEarningsScreen(),
    AppRoutes.writerProfile: (_) => const WriterProfileScreen(),
    AppRoutes.writerSubscription: (_) => const WriterSubscribersScreen(),

    // SERVICES
    AppRoutes.audio: (_) => const AudioScreen(),
    AppRoutes.community: (_) => const CommunityScreen(),
    AppRoutes.challenges: (_) => const ChallengesScreen(),

    // AI
    AppRoutes.aiChat: (_) => const AIChatScreen(),
    AppRoutes.aiMood: (_) => const AIMoodScreen(),
    AppRoutes.aiRecommendation: (_) => const AIRecommendationScreen(),
    AppRoutes.aiVoice: (_) => const AIVoiceScreen(),
    AppRoutes.aiWritingAssistant: (_) => const AIWritingAssistantScreen(),

    // BOOK
    AppRoutes.bookDetail: (_) => const PlaceholderScreen(title: "Book Detail"),
  };
}

/// =======================================================
/// FALLBACK / PLACEHOLDER SCREEN
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
