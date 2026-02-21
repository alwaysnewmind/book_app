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

  // 🔵 OUR SERVICES (Core Reading)
  HomeService(
    title: "Reader Studio",
    icon: Icons.menu_book,
    route: AppRoutes.bookDetail,
  ),
  HomeService(
    title: "Discover",
    icon: Icons.explore,
    route: AppRoutes.aiRecommendation,
  ),
  HomeService(
    title: "Premium",
    icon: Icons.workspace_premium,
    route: AppRoutes.subscription,
  ),
  HomeService(
    title: "Offline Vault",
    icon: Icons.download_for_offline,
    route: AppRoutes.downloads,
  ),
  HomeService(
    title: "Audio Books",
    icon: Icons.headphones,
    route: AppRoutes.audio,
  ),
  HomeService(
    title: "AI Summary",
    icon: Icons.psychology_alt,
    route: AppRoutes.aiSummary,
  ),

  // 🟢 WRITER ZONE
  HomeService(
    title: "Writer Studio",
    icon: Icons.edit_note,
    route: AppRoutes.writerDashboard,
  ),
  HomeService(
    title: "Content Writing",
    icon: Icons.create,
    route: AppRoutes.writerDashboard,
  ),
  HomeService(
    title: "Story Analytics",
    icon: Icons.analytics,
    route: AppRoutes.writerDashboard, // change if separate screen
  ),
  HomeService(
    title: "Earn as Writer",
    icon: Icons.currency_rupee,
    route: AppRoutes.writerEarnings,
  ),

  // 🟠 COMMUNITY & ENGAGEMENT
  HomeService(
    title: "Community",
    icon: Icons.groups,
    route: AppRoutes.community,
  ),
  HomeService(
    title: "Reviews",
    icon: Icons.rate_review,
    route: AppRoutes.community, // change if separate screen
  ),
  HomeService(
    title: "category",
    icon: Icons.emoji_events,
    route: AppRoutes.category,
  ),
  HomeService(
    title: "Book Battle",
    icon: Icons.sports_kabaddi,
    route: AppRoutes.category, // change if separate
  ),
  HomeService(
    title: "Quotes",
    icon: Icons.format_quote,
    route: AppRoutes.library,
  ),

  // 🟣 USER SETTINGS
  HomeService(
    title: "Favorites",
    icon: Icons.favorite,
    route: AppRoutes.favorites,
  ),
  HomeService(
    title: "Languages",
    icon: Icons.language,
    route: AppRoutes.language,
  ),
  HomeService(
    title: "Help & Feedback",
    icon: Icons.help_outline,
    route: AppRoutes.settings,
  ),
  HomeService(
    title: "Settings",
    icon: Icons.settings,
    route: AppRoutes.settings,
  ),
  HomeService(
    title: "Monetize",
    icon: Icons.monetization_on,
    route: AppRoutes.subscription, // change if needed
  ),

];