import 'package:flutter/material.dart';

// widgets
import 'widgets/home_app_bar.dart';
import 'widgets/app_drawer.dart';
import 'widgets/search_bar.dart';
import 'widgets/section_title.dart';
import 'widgets/banner_card.dart';
import 'widgets/banner_slider.dart';
import 'widgets/services_section.dart';
import 'widgets/sweet_banner.dart';

// data
import '../../shared/widgets/data/home_services.dart';

// screens
import '../library/screens/my_library_screen.dart';

///////////////////////////////////////////////////////////////////////////////
/// 🔥 HOME SCREEN
///////////////////////////////////////////////////////////////////////////////
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Route _animatedRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween(begin: 0.98, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ourServices = homeServices.take(4).toList();
    final explore = homeServices.skip(4).take(4).toList();
    final discoverMore = homeServices.skip(8).take(8).toList();
    final remaining = homeServices.skip(16).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      drawer: const AppDrawer(),
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
              Color (0xFF4A148C),
              Color(0xFF4A148C),
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

                const SizedBox(height: 20),

                /// 🔎 SEARCH BAR
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: HomeSearchBar(),
                ),

                const SizedBox(height: 24),

                /// 🎯 BANNER SLIDER
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: BannerSlider(
                    banners: [
                      "assets/banners/banner1.jpg",
                      "assets/banners/banner2.jpg",
                      "assets/banners/banner3.jpg",
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                /// 🛠 OUR SERVICES
                ServicesSection(
                  title: "Our Services",
                  services: ourServices,
                  crossAxisCount: 4,
                ),

                const SizedBox(height: 30),

                /// 📚 FEATURED BOOKS
                const SectionTitle("Featured Books"),
                const SizedBox(height: 16),
                const FeaturedBooks(),

                const SizedBox(height: 40),

                /// 🔎 EXPLORE
                ServicesSection(
                  title: "Explore",
                  services: explore,
                  crossAxisCount: 4,
                ),

                const SizedBox(height: 30),

                /// 🚀 DISCOVER MORE
                ServicesSection(
                  title: "Discover More",
                  services: discoverMore,
                  crossAxisCount: 4,
                ),

                const SizedBox(height: 30),

                /// 💎 PROMO CARD
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: BannerCard(
                    text: "AI Powered Reading & Writing Experience",
                  ),
                ),

                const SizedBox(height: 36),

                /// ❤️ RECOMMENDED BOOKS
                const SectionTitle("Recommended For You"),
                const SizedBox(height: 16),
                const RecommendedBooksSection(),

                const SizedBox(height: 36),

                /// 🔥 OTHERS
                ServicesSection(
                  title: "Others",
                  services: remaining,
                  crossAxisCount: 4,
                ),


                const SizedBox(height: 30),

                /// ✨ SWEET BOTTOM BANNER
                const SweetBanner(),

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
/// 🔥 SERVICE TILE
///////////////////////////////////////////////////////////////////////////////
class HomeServiceTile extends StatelessWidget {
  final HomeService service;

  const HomeServiceTile({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        if (service.route.isNotEmpty) {
          Navigator.pushNamed(context, service.route);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// OUTER RING
          Container(
            height: 68,
            width: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color.fromARGB(255, 22, 224, 224),
                width: 2.2,
              ),
            ),
            child: Center(
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 178, 167, 197).withOpacity(0.12),
                ),
                child: Icon(
                  service.icon,
                  size: 40,
                  color: Colors. deepPurple,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            service.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
/// 🔥 RECOMMENDED BOOKS SECTION
///////////////////////////////////////////////////////////////////////////////
class RecommendedBooksSection extends StatelessWidget {
  const RecommendedBooksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final books = [
      "assets/books/Book1.png",
      "assets/books/Book2.png",
      "assets/books/Book3.png",
      "assets/books/Book4.png",
      "assets/books/Book5.png",
    ];

    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: books.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final image = books[index];

          return Hero(
            tag: image,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration:
                        const Duration(milliseconds: 350),
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
                child: Image.asset(
                  image,
                  width: 130,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}