import 'package:book_app/features/home/widgets/featured_books.dart' show FeaturedBooks;
import 'package:book_app/navigation/bottom_nav.dart' show BottomNav;
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:book_app/features/home/widgets/home_services.dart';
import 'package:book_app/services/auth_service.dart';
import 'package:book_app/services/role_service.dart';
import 'package:book_app/core/routes/app_routes.dart';
import 'package:book_app/providers/notification_provider.dart';
import 'package:provider/provider.dart';

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
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<Map<String, dynamic>?>(
      stream: uid == null ? null : RoleService.instance.userProfileStream(uid),
      builder: (context, snapshot) {
        final role = snapshot.data?['role']?.toString();
        final canAccessWriter = RoleService.instance.isWriterOrAdmin(role);

        final visibleServices = homeServices
            .where((service) => canAccessWriter || service.route != AppRoutes.writerDashboard)
            .toList();

        final ourServices = visibleServices.take(4).toList();
        final explore = visibleServices.skip(4).take(4).toList();
        final discoverMore = visibleServices.skip(8).take(8).toList();
        final remaining = visibleServices.skip(16).toList();

        return Scaffold(
      backgroundColor: Colors.transparent,
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
            if (uid != null)
              Consumer<NotificationProvider>(
                builder: (context, notifications, _) {
                  if (notifications.notificationsForUser(uid).isEmpty) {
                    notifications.loadNotifications(uid);
                  }
                  final unread = notifications.unreadCount(uid);
                  return Stack(children: [
                    IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
                    if (unread > 0)
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          child: Text('$unread', style: const TextStyle(fontSize: 10, color: Colors.white)),
                        ),
                      ),
                  ]);
                },
              ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await AuthService.instance.logout();
              },
            ),
          ],
        ),
      ),

      // ✅ Bottom Navigation Properly Placed
          bottomNavigationBar: BottomNav(
            currentIndex: 0,
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                  break;
                case 1:
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.writerDashboard);
                  break;
                case 2:
                  Navigator.pushReplacementNamed(context, AppRoutes.library);
                  break;
                case 3:
                  Navigator.pushNamed(
                      context, AppRoutes.profile);
                  break;
              }
            },
          ),


      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.3,
            colors: [
              Color(0xFF2E1B47),
              Color(0xFF1C1B3A),
            ],
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
      },
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
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFFFD86B),
                width: 2.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD86B).withOpacity(0.4),
                  blurRadius: 18,
                  spreadRadius: 1,
            ),]
            ),
            child: Center(
              child: Container(
                height: 54,
                width: 54,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3C2A5E),
                      Color(0xFF2A2045),
                    ],
                  ),),
                child: Icon(
                  service.icon,
                  size: 40,
                  color: Color (0xFFFFD86B),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            service.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE2E2E5),
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
                      backgroundColor:const Color(0xFF1C1B3A),
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