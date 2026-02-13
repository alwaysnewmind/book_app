import 'package:flutter/material.dart';

class ServiceItem {
  final String title;
  final IconData icon;
  final String route;

  const ServiceItem({
    required this.title,
    required this.icon,
    required this.route,
  });
}

final List<ServiceItem> serviceItems = [
  ServiceItem(
    title: 'Read',
    icon: Icons.menu_book,
    route: '/library',
  ),
  ServiceItem(
    title: 'Premium',
    icon: Icons.star,
    route: '/subscription',
  ),
  ServiceItem(
    title: 'Write',
    icon: Icons.edit,
    route: '/writer',
  ),
  ServiceItem(
    title: 'Earn',
    icon: Icons.currency_rupee,
    route: '/writer-earnings',
  ),
  ServiceItem(
    title: 'Audio',
    icon: Icons.headphones,
    route: '/audio',
  ),
  ServiceItem(
    title: 'Community',
    icon: Icons.groups,
    route: '/community',
  ),
  ServiceItem(
    title: 'AI Chat',
    icon: Icons.smart_toy,
    route: '/ai-chat',
  ),
  ServiceItem(
    title: 'Challenges',
    icon: Icons.flag,
    route: '/challenges',
  ),
];
