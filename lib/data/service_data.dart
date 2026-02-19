import 'package:flutter/material.dart';

class ServiceItem {
  final String title;
  final String route;
  final String imagePath;

  const ServiceItem({
    required this.title,
  
    required this.route,
    required this.imagePath,
  });
}

final List<ServiceItem> serviceItems = [
  ServiceItem(
    title: 'Read',
    imagePath: 'assets/services/read.png',
    route: '/library',
  ),
  ServiceItem(
    title: 'Premium',
    imagePath: 'assets/services/premium.png',
    route: '/subscription',
  ),
  ServiceItem(
    title: 'Write',
    imagePath: 'assets/services/write.png',
    route: '/writer',
  ),
  ServiceItem(
    title: 'Earn',
    imagePath: 'assets/services/earn.png',
    route: '/writer-earnings',
  ),
  ServiceItem(
    title: 'Audio',
    imagePath: 'assets/services/audio.png',
    route: '/audio',
  ),
  ServiceItem(
    title: 'Community',
    imagePath: 'assets/services/community.png',
    route: '/community',
  ),
  ServiceItem(
    title: 'AI Chat',
    imagePath: 'assets/services/ai.png',
    route: '/ai-chat',
  ),
  ServiceItem(
    title: 'Challenges',
    imagePath: 'assets/services/challenges.png',
    route: '/challenges',
  ),
];
