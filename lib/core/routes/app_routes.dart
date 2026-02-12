import 'package:flutter/material.dart';

Map<String, WidgetBuilder> appRoutes = {
  '/audio': (_) => const PlaceholderScreen(title: 'Audio'),
  '/challenges': (_) => const PlaceholderScreen(title: 'Challenges'),
  '/community': (_) => const PlaceholderScreen(title: 'Community'),
  '/premium': (_) => const PlaceholderScreen(title: 'Premium'),
  '/writer-hub': (_) => const PlaceholderScreen(title: 'Writer Hub'),
  '/publish': (_) => const PlaceholderScreen(title: 'Publish'),
  '/earn': (_) => const PlaceholderScreen(title: 'Earn'),
  '/feedback': (_) => const PlaceholderScreen(title: 'Feedback'),
};

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title – Coming Soon',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
