import 'package:flutter/material.dart';

// widgets
import 'widgets/home_app_bar.dart';
import 'widgets/app_drawer.dart';
import 'widgets/search_bar.dart';
import 'widgets/section_title.dart';
import 'widgets/featured_books.dart';
import 'widgets/banner_card.dart';
import 'widgets/banner_slider.dart';
import 'widgets/services_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),

      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: HomeAppBar(),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔍 Search Bar
            const Padding(
              padding: EdgeInsets.all(16),
              child: HomeSearchBar(),
            ),

            /// 🧩 Services
            const SectionTitle("Our Services"),
            const SizedBox(height: 12),
            const ServicesSection(),

            /// 📚 Featured Books
            const SizedBox(height: 24),
            const SectionTitle("Featured Books"),
            const SizedBox(height: 12),
            const FeaturedBooks(),

            /// 🎯 Banner
            const SizedBox(height: 24),
            const BannerCard(
              text: "Read. Write. Grow with AI",
            ),

            /// 🧩 More Services
            const SizedBox(height: 24),
            const SectionTitle("More Services"),
            const SizedBox(height: 12),
            const ServicesSection(),

            /// 🔄 Auto Sliding Banner
            const SizedBox(height: 24),
            const BannerSlider(
              banners: [
                "assets/banners/banner1.png",
                "assets/banners/banner2.png",
                "assets/banners/banner3.png",
              ],
            ),

            /// 🌟 Explore
            const SizedBox(height: 24),
            const SectionTitle("Explore"),
            const SizedBox(height: 12),
            const ServicesSection(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
