import 'package:flutter/material.dart';

class BannerSlider extends StatelessWidget {
  final List<String> banners;

  const BannerSlider({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: PageView.builder(
        itemCount: banners.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                banners[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
