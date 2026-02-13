import 'package:flutter/material.dart';

// AUTH
import 'package:book_app/features/auth/screens/auth_entry_screen.dart';

// LIBRARY
import 'package:book_app/features/library/library_screen.dart';

// SUBSCRIPTION
import 'package:book_app/features/subscription/reader_subscription_screen.dart';

// WRITER
import 'package:book_app/features/writer/writer_screen.dart';
import 'package:book_app/features/writer/writer_earnings_screen.dart';

// SERVICES
import 'package:book_app/features/services/audio_screen.dart';
import 'package:book_app/features/services/community_screen.dart';
import 'package:book_app/features/services/challenges_screen.dart';

// AI
import 'package:book_app/features/ai/ai_chat_screen.dart';


final Map<String, WidgetBuilder> appRoutes = {
  '/login': (_) => const AuthEntryScreen(),
  '/library': (_) => const LibraryScreen(),
  '/subscription': (_) => const ReaderSubscriptionScreen(),
  '/writer': (_) => const WriterStats(),
  '/writer-earnings': (_) => const WriterEarningsScreen(),
  '/audio': (_) => const AudioScreen(),
  '/community': (_) => const CommunityScreen(),
  '/ai-chat': (_) => const AIChatScreen(),
  '/challenges': (_) => const ChallengesScreen(),
};



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
