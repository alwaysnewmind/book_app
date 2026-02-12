import 'package:flutter/material.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Text("Choose Language"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Select your preferred language",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "You can change this anytime from settings.",
              style: TextStyle(color: Colors.white60),
            ),
            SizedBox(height: 24),

            _LanguageTile(
              language: "English",
              subtitle: "English (Default)",
              selected: true,
            ),
            _LanguageTile(
              language: "हिन्दी",
              subtitle: "Hindi",
              selected: false,
            ),
            _LanguageTile(
              language: "ગુજરાતી",
              subtitle: "Gujarati",
              selected: false,
            ),
            _LanguageTile(
              language: "தமிழ்",
              subtitle: "Tamil",
              selected: false,
            ),
            _LanguageTile(
              language: "తెలుగు",
              subtitle: "Telugu",
              selected: false,
            ),
          ],
        ),
      ),
    );
  }
}

//
// 🌍 LANGUAGE TILE
//

class _LanguageTile extends StatelessWidget {
  final String language;
  final String subtitle;
  final bool selected;

  const _LanguageTile({
    required this.language,
    required this.subtitle,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: selected
            ? Border.all(color: Colors.amber, width: 1.2)
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  language,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),
          if (selected)
            const Icon(
              Icons.check_circle,
              color: Colors.amber,
            ),
        ],
      ),
    );
  }
}
