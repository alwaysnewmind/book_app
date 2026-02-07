import 'package:flutter/material.dart';

class ServiceGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const ServiceGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: items.length,
        itemBuilder: (_, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                child: Icon(items[index]['icon']),
              ),
              const SizedBox(height: 6),
              Text(
                items[index]['title'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              )
            ],
          );
        },
      ),
    );
  }
}
