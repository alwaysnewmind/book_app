import 'package:book_app/core/monetization/access_rules.dart';
import 'package:flutter/material.dart';
import 'package:book_app/core/monetization/premium_guard.dart';
import 'package:book_app/models/user_model.dart';
import 'package:book_app/features/subscription/reader_subscription_screen.dart';

class AIVoiceScreen extends StatelessWidget {
  final AppUser? currentUser;
  final bool isGuest;

  const AIVoiceScreen({super.key, this.currentUser, this.isGuest = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Text("AI Voice Narration"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: PremiumGuard(
          user: currentUser,
          isGuest: isGuest,
          contentType: ContentType.premium,
          lockedView: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.headphones, size: 80, color: Colors.amber),
              const SizedBox(height: 20),
              const Text(
                "AI Voice Narration is available for Premium Readers",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.amber, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReaderSubscriptionScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Upgrade",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.headphones, size: 80, color: Colors.amber),
              const SizedBox(height: 20),
              const Text(
                "Listen to this book with AI Voice",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 30),

              /// Slider (demo)
              Slider(
                value: 0.3,
                onChanged: (value) {
                  // TODO: Integrate actual audio position
                },
                activeColor: Colors.amber,
              ),

              const SizedBox(height: 20),

              /// Playback controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      // TODO: Rewind 10s
                    },
                    icon: const Icon(Icons.replay_10, color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () {
                      // TODO: Play/Pause toggle
                    },
                    icon: const Icon(Icons.play_circle_fill,
                        color: Colors.amber, size: 48),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () {
                      // TODO: Forward 10s
                    },
                    icon: const Icon(Icons.forward_10, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
