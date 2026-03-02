import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/story_analytics_model.dart';
import 'provider/story_analytics_provider.dart';

class StoryAnalyticsScreen extends StatelessWidget {
  const StoryAnalyticsScreen({super.key, required this.storyId});

  final String storyId;

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryAnalyticsProvider>(
      builder: (context, provider, child) {
        if (!provider.isLoading &&
            provider.analytics == null &&
            provider.errorMessage == null &&
            provider.chapters.isEmpty &&
            provider.weeklyGrowth.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) {
              return;
            }
            Provider.of<StoryAnalyticsProvider>(
              context,
              listen: false,
            ).fetchStoryAnalytics(storyId);
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Story Analytics'),
            actions: [
              IconButton(
                icon: const Icon(Icons.home_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider(
                        create: (_) => StoryAnalyticsProvider(),
                        child: StoryAnalyticsScreen(storyId: storyId),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF111827), Color(0xFF1F2937)],
              ),
            ),
            child: RefreshIndicator(
              onRefresh: provider.refreshAnalytics,
              child: _buildBody(context, provider),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, StoryAnalyticsProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          _ErrorStateWidget(message: provider.errorMessage!),
        ],
      );
    }

    final analytics = provider.analytics;
    if (analytics == null &&
        provider.chapters.isEmpty &&
        provider.weeklyGrowth.isEmpty) {
      return const _EmptyStateWidget();
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        _OverviewSection(analytics: analytics ?? const StoryAnalyticsModel()),
        const SizedBox(height: 16),
        _ChapterSection(chapters: provider.chapters),
        const SizedBox(height: 16),
        _WeeklyGrowthSection(weeklyGrowth: provider.weeklyGrowth),
      ],
    );
  }
}

class _OverviewSection extends StatelessWidget {
  const _OverviewSection({required this.analytics});

  final StoryAnalyticsModel analytics;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                AnalyticsCard(title: 'Total Views', value: '${analytics.totalViews}'),
                AnalyticsCard(title: 'Unique Readers', value: '${analytics.uniqueReaders}'),
                AnalyticsCard(
                  title: 'Completion Rate',
                  value: '${analytics.completionRate.toStringAsFixed(1)}%',
                ),
                AnalyticsCard(title: 'Likes', value: '${analytics.totalLikes}'),
                AnalyticsCard(title: 'Comments', value: '${analytics.totalComments}'),
                AnalyticsCard(title: 'Shares', value: '${analytics.totalShares}'),
                AnalyticsCard(
                  title: 'Followers Gained',
                  value: '${analytics.followersGained}',
                ),
                AnalyticsCard(
                  title: 'Reading Minutes',
                  value: '${analytics.totalReadingMinutes}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChapterSection extends StatelessWidget {
  const _ChapterSection({required this.chapters});

  final List<ChapterAnalyticsModel> chapters;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chapter Engagement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (chapters.isEmpty)
              const Text('No chapter analytics available.')
            else
              ...chapters.map(
                (chapter) => ChapterEngagementCard(
                  title: chapter.title,
                  views: chapter.views,
                  engagementRate: chapter.engagementRate,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyGrowthSection extends StatelessWidget {
  const _WeeklyGrowthSection({required this.weeklyGrowth});

  final List<GrowthAnalyticsModel> weeklyGrowth;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Growth',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (weeklyGrowth.isEmpty)
              const Text('No weekly growth data available.')
            else
              ...weeklyGrowth.map(
                (growth) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(growth.label),
                  trailing: Text('${growth.reads} reads'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AnalyticsCard extends StatelessWidget {
  const AnalyticsCard({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.4,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class ChapterEngagementCard extends StatelessWidget {
  const ChapterEngagementCard({
    super.key,
    required this.title,
    required this.views,
    required this.engagementRate,
  });

  final String title;
  final int views;
  final double engagementRate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text('$views views'),
          const SizedBox(width: 12),
          Text('${engagementRate.toStringAsFixed(1)}%'),
        ],
      ),
    );
  }
}

class _ErrorStateWidget extends StatelessWidget {
  const _ErrorStateWidget({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 44),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        SizedBox(height: 120),
        Center(
          child: Text(
            'No analytics data available yet.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
