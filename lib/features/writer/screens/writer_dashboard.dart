import 'dart:ui';
import 'package:book_app/core/monetization/access_rules.dart';
import 'package:book_app/features/home/widgets/section_title.dart';
import 'package:flutter/material.dart';

// widgets & screens
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
  final bool isWriterMode;

  const WriterDashboard({
    super.key,
    required this.currentUser,
    required this.isGuest,
    required this.isWriterMode,
  });

  @override
  Widget build(BuildContext context) {
    if (!isWriterMode) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Switch to Writer Mode from Profile",
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    bool hasFreeAccess = true;

    if (currentUser?.writerTrialStart != null) {
      final activatedAt = currentUser!.writerTrialStart!;
      final difference = DateTime.now().difference(activatedAt).inDays;
      if (difference > 7) hasFreeAccess = false;
    }

    final premiumAccess = AccessRules.canAccess(
      user: currentUser,
      isGuest: isGuest,
      contentType: ContentType.writerOnly,
    );

    final hasAccess = hasFreeAccess || premiumAccess;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FB),
      body: SafeArea(
        child: Stack(
          children: [

            /// 🌈 BACKGROUND GRADIENT
            Container(
              height: 260,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF7B2FF7),
                    Color(0xFF9F44D3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            /// 📜 MAIN CONTENT
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 20),

                  /// 🔝 HEADER
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Writer Dashboard",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person, color: Colors.white),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// 📊 GLASS STATS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: const [
                        Expanded(
                          child: _GlassStatCard(
                            icon: Icons.menu_book,
                            title: "Total Books",
                            value: "12",
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: _GlassStatCard(
                            icon: Icons.attach_money,
                            title: "Earnings",
                            value: "₹25,000",
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// 🤍 WHITE BODY
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF4F5FB),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      children: [

                        const SizedBox(height: 30),

                        /// 🚀 ACTION BUTTONS
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              _ActionButton(
                                icon: Icons.add,
                                label: "Create",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const CreateBookPage(),
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
                                      builder: (_) =>
                                          const ManageBooksPage(),
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
                                      builder: (_) =>
                                          const WriterEarningsScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        /// 📚 RECENT BOOKS
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: SectionTitle("Recent Books"),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
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
                                  margin:
                                      const EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(18),
                                    image: DecorationImage(
                                      image:
                                          AssetImage(book.coverImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// ➕ FLOATING CREATE BAR
            Positioned(
              bottom: 25,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateBookPage(),
                    ),
                  );
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFF7B2FF7),
                        child:
                            Icon(Icons.add, color: Colors.white),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Create New Book",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            if (!hasAccess) const _PremiumOverlay(),
            
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// GLASS STAT CARD
////////////////////////////////////////////////////////////

class _GlassStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _GlassStatCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// ACTION BUTTON
////////////////////////////////////////////////////////////

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
        width: 85,
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
            Icon(icon, color: const Color(0xFF7B2FF7)),
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
////////////////////////////////////////////////////////////
/// PREMIUM OVERLAY
////////////////////////////////////////////////////////////

class _PremiumOverlay extends StatelessWidget {
  const _PremiumOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Icon(
                    Icons.lock,
                    size: 50,
                    color: Color(0xFF7B2FF7),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Writer Subscription Required",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Upgrade to premium to access all writer features.",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B2FF7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to subscription screen
                      Navigator.pushNamed(context, "/writer-subscription");
                    },
                    child: const Text("Upgrade Now"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
