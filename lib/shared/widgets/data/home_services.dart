import 'package:flutter/material.dart';
import 'package:book_app/core/routes/app_routes.dart';

class HomeService {
  final String title;
  final IconData icon;
  final String route;

  HomeService({
    required this.title,
    required this.icon,
    required this.route,
  });
}

final List<HomeService> homeServices = [
  HomeService(title: "Read Books", icon: Icons.menu_book, route: AppRoutes.bookDetail),
  HomeService(title: "Discover", icon: Icons.explore, route: AppRoutes.aiRecommendation),
  HomeService(title: "Premium", icon: Icons.star, route: AppRoutes.subscription),
  HomeService(title: "Favorites", icon: Icons.favorite, route: AppRoutes.favorites),
  HomeService(title: "Downloads", icon: Icons.download, route: AppRoutes.downloads),
  HomeService(title: "My Library", icon: Icons.library_books, route: AppRoutes.library),
  HomeService(title: "AI Summary", icon: Icons.psychology, route: AppRoutes.aiSummary),
  HomeService(title: "Audio Books", icon: Icons.headphones, route: AppRoutes.audio),
  HomeService(title: "Write", icon: Icons.edit, route: AppRoutes.writerDashboard),
  HomeService(title: "Earn as Writer", icon: Icons.currency_rupee, route: AppRoutes.writerEarnings),
  HomeService(title: "Community", icon: Icons.groups, route: AppRoutes.community),
  HomeService(title: "Challenges", icon: Icons.flag, route: AppRoutes.challenges),
  HomeService(title: "Reviews", icon: Icons.rate_review, route: AppRoutes.community),
  HomeService(title: "Languages", icon: Icons.language, route: AppRoutes.language),
  HomeService(title: "Settings", icon: Icons.settings, route: AppRoutes.settings),
  HomeService(title: "Help & Feedback", icon: Icons.help_outline, route: AppRoutes.settings),
];
