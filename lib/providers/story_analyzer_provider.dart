import 'package:book_app/config/app_config.dart';
import 'package:flutter/material.dart';

class StoryAnalysisResult {
  StoryAnalysisResult({
    required this.grammarScore,
    required this.engagementScore,
    required this.suggestions,
  });

  final int grammarScore;
  final int engagementScore;
  final List<String> suggestions;
}

class StoryAnalyzerProvider extends ChangeNotifier {
  bool _isAnalyzing = false;
  StoryAnalysisResult? _result;

  bool get isAnalyzing => _isAnalyzing;
  StoryAnalysisResult? get result => _result;

  Future<void> analyzeStory(String text) async {
    _isAnalyzing = true;
    notifyListeners();
    try {
      if (isDummyMode) {
        await Future.delayed(const Duration(milliseconds: 1200));
        _result = StoryAnalysisResult(
          grammarScore: 84,
          engagementScore: 88,
          suggestions: const [
            'Add a stronger hook in the first paragraph.',
            'Reduce repeated adjectives in chapter opening.',
            'Use a shorter sentence before emotional turns for impact.',
          ],
        );
      } else {
        await Future.delayed(const Duration(milliseconds: 300));
        _result = StoryAnalysisResult(grammarScore: 0, engagementScore: 0, suggestions: const []);
      }
    } catch (_) {
      rethrow;
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }
}
