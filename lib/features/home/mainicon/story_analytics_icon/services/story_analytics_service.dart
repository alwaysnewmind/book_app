import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/story_analytics_model.dart';

class StoryAnalyticsService {
  StoryAnalyticsService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<StoryAnalyticsModel> fetchOverview(String storyId) async {
    try {
      final snapshot = await _firestore
          .collection('stories')
          .doc(storyId)
          .collection('analytics')
          .doc('overview')
          .get();

      if (!snapshot.exists) {
        return const StoryAnalyticsModel();
      }

      return StoryAnalyticsModel.fromJson(snapshot.data());
    } on FirebaseException catch (error) {
      debugPrint('fetchOverview FirebaseException: ${error.message}');
      throw Exception(
        'Unable to load overview analytics right now. Please try again.',
      );
    } catch (error) {
      debugPrint('fetchOverview Unknown error: $error');
      throw Exception('An unexpected error occurred while loading overview.');
    }
  }

  Future<List<ChapterAnalyticsModel>> fetchChapters(String storyId) async {
    try {
      final snapshot = await _firestore
          .collection('stories')
          .doc(storyId)
          .collection('analytics')
          .doc('overview')
          .collection('chapters')
          .orderBy('views', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ChapterAnalyticsModel.fromJson(doc.data()))
          .toList(growable: false);
    } on FirebaseException catch (error) {
      debugPrint('fetchChapters FirebaseException: ${error.message}');
      throw Exception(
        'Unable to load chapter analytics right now. Please try again.',
      );
    } catch (error) {
      debugPrint('fetchChapters Unknown error: $error');
      throw Exception('An unexpected error occurred while loading chapters.');
    }
  }

  Future<List<GrowthAnalyticsModel>> fetchWeeklyGrowth(String storyId) async {
    try {
      final snapshot = await _firestore
          .collection('stories')
          .doc(storyId)
          .collection('analytics')
          .doc('overview')
          .collection('weekly_growth')
          .get();

      return snapshot.docs
          .map((doc) => GrowthAnalyticsModel.fromJson(doc.data()))
          .toList(growable: false);
    } on FirebaseException catch (error) {
      debugPrint('fetchWeeklyGrowth FirebaseException: ${error.message}');
      throw Exception(
        'Unable to load weekly growth right now. Please try again.',
      );
    } catch (error) {
      debugPrint('fetchWeeklyGrowth Unknown error: $error');
      throw Exception('An unexpected error occurred while loading growth.');
    }
  }
}
