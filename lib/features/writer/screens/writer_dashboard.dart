import 'dart:ui';
import 'package:book_app/core/monetization/access_rules.dart';
import 'package:book_app/features/home/widgets/section_title.dart';
import 'package:flutter/material.dart';

// widgets & screens
import 'package:book_app/features/writer/widgets/writer_header.dart';
import 'package:book_app/data/dummy_books.dart';
import 'package:book_app/features/writer/create_book_entry_page.dart';
import 'package:book_app/features/writer/screens/manage_books_page.dart';
import 'package:book_app/features/writer/screens/writer_earnings_screen.dart';
import 'package:book_app/features/writer/screens/writer_subscription_screen.dart';
import 'package:book_app/features/book/book_detail_screen.dart';
import 'package:book_app/models/user_model.dart';

class WriterDashboard extends StatelessWidget {
  final AppUser? currentUser;
  final bool isGuest;

  const WriterDashboard({
    super.key,
    required this.currentUser,
    required this.isGuest,
  });

  @override
  Widget build(BuildContext context) {

    /// 🔐 CHECK ACCESS (writerOnly or earnings — tum decide kar sakte ho)
    final hasAccess = AccessRules.canAccess(
      user: currentUser,
      isGuest: isGuest,
      contentType: ContentType.writerOnly,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Stack(
          children: [

            /// 🔹 ORIGINAL FULL DASHBOARD CONTENT (UNCHANGED)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF6F7FB),
                    Color(0xFFEDEFFD),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// 👋 Header
                    const WriterHeader(),

                    const SizedBox(height: 28),

                    /// 📊 Stats Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: const [
                          Expanded(
                            child: _StatsCard(
                              title: "Total Books",
                              value: "12",
                              gradient: [
                                Color(0xFF6C63FF),
                                Color(0xFF4A3AFF),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _StatsCard(
                              title: "Earnings",
                              value: "₹25,000",
                              gradient: [
                                Color(0xFF00C9A7),
                                Color(0xFF00B894),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _StatsCard(
                              title: "Pending",
                              value: "3",
                              gradient: [
                                Color(0xFFFF6F61),
                                Color(0xFFFF3D00),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    /// 🚀 Action Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          _ActionButton(
                            icon: Icons.add,
                            label: "Create",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CreateBookPage(),
                                ),
                              );
                            },
                          ),

                          _ActionButton(
                            icon: Icons.menu_book,
                            label: "Manage",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ManageBooksPage(),
                                ),
                              );
                            },
                          ),

                          _ActionButton(
                            icon: Icons.attach_money,
                            label: "Earnings",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const WriterEarningsScreen(),
                                ),
                              );
                            },
                          ),

                          _ActionButton(
                            icon: Icons.people,
                            label: "Subscribers",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const WriterSubscribersScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    /// 📚 Recent Books
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: SectionTitle("Recent Books"),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: dummyBooks.length,
                        itemBuilder: (context, index) {
                          final book = dummyBooks[index];

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookDetailScreen(
                                    imagePath: book.coverImage,
                                    title: book.title,
                                    isLocked: book.isPremium,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 150,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: AssetImage(book.coverImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [

                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.star,
                                              size: 14,
                                              color: Colors.amber),
                                          const SizedBox(width: 4),
                                          Text(
                                            book.rating.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(18),
                                          bottomRight: Radius.circular(18),
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.8),
                                          ],
                                        ),
                                      ),
                                      child: Text(
                                        book.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// 🔥 Promo Banner
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF6C63FF),
                              Color(0xFF9D4EDD),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.withOpacity(0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "Boost your book reach with AI recommendations 🚀",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),

            /// 🔒 PREMIUM OVERLAY (ONLY ADDITION)
            if (!hasAccess)
              const _PremiumOverlay(),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
/// 🔒 PREMIUM OVERLAY (ADDED ONLY)
///////////////////////////////////////////////////////////////////////////////

class _PremiumOverlay extends StatefulWidget {
  const _PremiumOverlay();

  @override
  State<_PremiumOverlay> createState() => _PremiumOverlayState();
}

class _PremiumOverlayState extends State<_PremiumOverlay>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          color: Colors.black.withOpacity(0.55),
          child: Center(
            child: FadeTransition(
              opacity: Tween(begin: 0.5, end: 1.0).animate(_controller),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 60,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Premium Writer Access Required",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WriterSubscribersScreen(),
                        ),
                      );
                    },
                    child: const Text("Upgrade Now"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

///////////////////////////////////////////////////////////////////////////////
/// 📊 STATS CARD
///////////////////////////////////////////////////////////////////////////////

class _StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final List<Color> gradient;

  const _StatsCard({
    required this.title,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: gradient.last.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
/// 🚀 ACTION BUTTON
///////////////////////////////////////////////////////////////////////////////

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 26,
              color: const Color(0xFF6C63FF),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
