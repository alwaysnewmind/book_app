// lib/shared/widgets/data/home_services.dart
import 'package:flutter/material.dart';

class HomeService {
  final String title;
  final IconData icon;  // IconData for UI
  final String route;   // Navigation route

  HomeService({
    required this.title,
    required this.icon,
    required this.route,
  });
}

// 🔹 List of services
final List<HomeService> homeServices = [
  HomeService(title: "Read Books", icon: Icons.menu_book, route: "/read"),
  HomeService(title: "Discover", icon: Icons.explore, route: "/discover"),
  HomeService(title: "Premium", icon: Icons.star, route: "/premium"),
  HomeService(title: "Favorites", icon: Icons.favorite, route: "/favorites"),
  HomeService(title: "Downloads", icon: Icons.download, route: "/downloads"),
  HomeService(title: "My Library", icon: Icons.library_books, route: "/library"),
  HomeService(title: "AI Summary", icon: Icons.psychology, route: "/ai-summary"),
  HomeService(title: "Audio Books", icon: Icons.headphones, route: "/audio"),
  HomeService(title: "Write", icon: Icons.edit, route: "/writer"),
  HomeService(title: "Earn as Writer", icon: Icons.currency_rupee, route: "/earn"),
  HomeService(title: "Community", icon: Icons.groups, route: "/community"),
  HomeService(title: "Challenges", icon: Icons.flag, route: "/challenges"),
  HomeService(title: "Reviews", icon: Icons.rate_review, route: "/reviews"),
  HomeService(title: "Languages", icon: Icons.language, route: "/language"),
  HomeService(title: "Settings", icon: Icons.settings, route: "/settings"),
  HomeService(title: "Help & Feedback", icon: Icons.help_outline, route: "/help"),
];
