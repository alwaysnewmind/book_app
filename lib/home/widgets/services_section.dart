import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/service_tile.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.border,
            width: 1.5,
          ),
        ),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            ServiceTile(
              title: 'My Books',
              image: 'assets/services/my_books.png',
              onTap: () {},
            ),
            ServiceTile(
              title: 'Reading List',
              image: 'assets/services/reading_list.png',
            ),
            ServiceTile(
              title: 'New Releases',
              image: 'assets/services/new_release.png',
            ),
            ServiceTile(
              title: 'Favorites',
              image: 'assets/services/favorites.png',
            ),
          ],
        ),
      ),
    );
  }
}
