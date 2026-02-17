import 'dart:ui';
import 'package:flutter/material.dart';

// widgets
import 'widgets/home_app_bar.dart';
import 'widgets/app_drawer.dart';
import 'widgets/search_bar.dart';
import 'widgets/section_title.dart';
import 'widgets/featured_books.dart';
import 'widgets/banner_card.dart';
import 'widgets/banner_slider.dart';

// data
import '../../shared/widgets/data/home_services.dart';

// screens
import '../library/screens/my_library_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Route _animatedRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween(begin: 0.96, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstRow = homeServices.sublist(0, 4);
    final secondRow = homeServices.sublist(4, 8);
    final remaining = homeServices.sublist(8);

    return Scaffold(
      drawer: const AppDrawer(),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: HomeAppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.library_books),
              onPressed: () {
                Navigator.push(
                  context,
                  _animatedRoute(const MyLibraryScreen()),
                );
              },
            ),
          ],
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8F9FF),
              Color(0xFFEDEFFF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: HomeSearchBar(),
                ),

                const SizedBox(height: 16),

                const BannerSlider(
                  banners: [
                    "assets/banners/banner1.jpg",
                    "assets/banners/banner2.jpg",
                    "assets/banners/banner3.jpg",
                  ],
                ),

                const SizedBox(height: 32),

                const SectionTitle("Our Services"),
                const SizedBox(height: 16),
                _ServicesGrid(services: firstRow),

                const SizedBox(height: 36),

                const SectionTitle("Featured Books"),
                const SizedBox(height: 16),
                const FeaturedBooks(),

                const SizedBox(height: 36),

                const SectionTitle("Explore"),
                const SizedBox(height: 16),
                _ServicesGrid(services: secondRow),

                const SizedBox(height: 36),

                const SectionTitle("Discover More"),
                const SizedBox(height: 16),
                _ServicesGrid(services: remaining),

                const SizedBox(height: 36),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: BannerCard(
                    text: "AI Powered Reading & Writing Experience",
                  ),
                ),

                const SizedBox(height: 36),

                const SectionTitle("Recommended For You"),
                const SizedBox(height: 16),
                const RecommendedBooksSection(
                  bookImages: [
                    "assets/books/Book1.png",
                    "assets/books/Book2.png",
                    "assets/books/Book3.png",
                    "assets/books/Book4.png",
                    "assets/books/Book5.png",
                  ],
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
/// ♻️ REUSABLE SERVICE TILE (NEW)
///////////////////////////////////////////////////////////////////////////////
class HomeServiceTile extends StatelessWidget {
  final HomeService service;
  final VoidCallback onTap;

  const HomeServiceTile({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🔵 CIRCULAR ICON
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurple.withOpacity(0.12),
                    ),
                    child: Icon(
                      service.icon,
                      size: 26,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    service.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
/// 🔥 UPDATED GRID USING REUSABLE TILE
///////////////////////////////////////////////////////////////////////////////
class _ServicesGrid extends StatelessWidget {
  final List<HomeService> services;
  const _ServicesGrid({required this.services});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: services.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final service = services[index];
          return HomeServiceTile(
            service: service,
            onTap: () {
              Navigator.pushNamed(context, service.route);
            },
          );
        },
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
/// 🔥 Hero Animated Recommended Books (UNCHANGED)
///////////////////////////////////////////////////////////////////////////////
class RecommendedBooksSection extends StatelessWidget {
  final List<String> bookImages;
  const RecommendedBooksSection({super.key, required this.bookImages});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: bookImages.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final image = bookImages[index];

          return Hero(
            tag: image,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 400),
                    pageBuilder: (_, __, ___) => Scaffold(
                      backgroundColor: Colors.black,
                      body: Center(
                        child: Hero(
                          tag: image,
                          child: Image.asset(image),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
