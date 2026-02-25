import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:book_app/core/monetization/access_rules.dart';
import 'package:book_app/data/dummy_books.dart';
import 'package:book_app/features/book/book_detail_screen.dart';
import 'package:book_app/core/routes/app_routes.dart';
import 'package:book_app/models/user_model.dart';

class WriterDashboard extends StatefulWidget {
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
  State<WriterDashboard> createState() => _WriterDashboardState();
}

class _WriterDashboardState extends State<WriterDashboard> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (!widget.isWriterMode) {
      return const Scaffold(
        body: Center(
          child: Text("Switch to Writer Mode from Profile"),
        ),
      );
    }

    final premiumAccess = AccessRules.canAccess(
      user: widget.currentUser,
      isGuest: widget.isGuest,
      contentType: ContentType.writerOnly,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [

          /// 🌌 BACKGROUND GRADIENT
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1F153B),
                  Color(0xFF261A43),
                  Color(0xFF322254),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /// 📜 MAIN SCROLLABLE CONTENT
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 20),

                  /// HEADER
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Writer Dashboard",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, color: Colors.white),
                      )
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// STATS
                  const Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.menu_book,
                          title: "Total Books",
                          value: "12",
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: StatCard(
                          icon: Icons.attach_money,
                          title: "Earnings",
                          value: "₹25,000",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// ACTION BUTTONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ActionButton(
                        icon: Icons.add,
                        label: "Create",
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.createBook, arguments: const {'source': 'dashboard'});
                        },
                      ),
                      ActionButton(
                        icon: Icons.menu_book,
                        label: "Manage",
                        highlighted: true,
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.manageBooks);
                        },
                      ),
                      ActionButton(
                        icon: Icons.attach_money,
                        label: "Earnings",
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.earn);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ActionButton(
                        icon: Icons.analytics,
                        label: "Analytics",
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.writerAnalytics);
                        },
                      ),
                      ActionButton(
                        icon: Icons.person,
                        label: "Profile",
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.writerProfile);
                        },
                      ),
                      ActionButton(
                        icon: Icons.subscriptions,
                        label: "Subscription",
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.writerSubscription);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      ActionButton(
                        icon: Icons.publish,
                        label: "Publish",
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.writerPublish);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Recent Books",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// BOOK CAROUSEL
                  SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: dummyBooks.length,
                      itemBuilder: (context, index) {
                        final book = dummyBooks[index];
                        final isSelected = index == selectedIndex;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });

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
                          child: BookCard(
                            image: book.coverImage,
                            isSelected: isSelected,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// FLOATING PILL BUTTON (inside scroll)
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.createBook, arguments: const {'source': 'dashboard'});
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xFFF7C405),
                            child: Icon(Icons.add, color: Colors.black),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Create New Book",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),

     //     if (!premiumAccess) const _PremiumOverlay(),
        
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// GLASS STAT CARD
////////////////////////////////////////////////////////////

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Color(0xFFF7C405)),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                title,
                style: const TextStyle(color: Color(0xFFD3CEDD)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// ACTION BUTTON
////////////////////////////////////////////////////////////

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlighted;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: highlighted
              ? const Color(0xFFF7C405).withOpacity(0.15)
              : Colors.white.withOpacity(0.08),
          boxShadow: highlighted
              ? [
                  BoxShadow(
                    color: const Color(0xFFF7C405).withOpacity(0.6),
                    blurRadius: 20,
                  )
                ]
              : [],
        ),
        child: Column(
          children: [
            Icon(icon,
                color: highlighted
                    ? const Color(0xFFF7C405)
                    : Colors.white),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: highlighted
                    ? const Color(0xFFF7C405)
                    : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// BOOK CARD
////////////////////////////////////////////////////////////

class BookCard extends StatelessWidget {
  final String image;
  final bool isSelected;

  const BookCard({
    super.key,
    required this.image,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isSelected ? 170 : 150,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFFE8B503).withOpacity(0.6),
                  blurRadius: 25,
                )
              ]
            : [],
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

 /// PREMIUM OVERLAY  
//class _PremiumOverlay 
//extends StatelessWidget 
//{ const _PremiumOverlay(); 
//@override 
//Widget build(BuildContext context) 
//{ return Positioned.fill( child: BackdropFilter( 
 // filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6), 
  //child: Container( color: Colors.black.withOpacity(0.4), 
//child: Center( child: Container( padding: const EdgeInsets.all(24), 
//margin: const EdgeInsets.symmetric(horizontal: 30), 
//decoration: BoxDecoration( color: Colors.white, borderRadius: BorderRadius.circular(20), ), 
//child: Column( mainAxisSize: MainAxisSize.min, 
//children: [ const Icon( Icons.lock, size: 50, color: Color(0xFF7B2FF7), ), 
//const SizedBox(height: 20), const Text( "Writer Subscription Required", textAlign: 
//TextAlign.center, style: 
//TextStyle( fontSize: 18, fontWeight: FontWeight.bold, ), ), 
//const SizedBox(height: 10), const Text( "Upgrade to premium to access all writer features.", 
//textAlign: TextAlign.center, ), const SizedBox(height: 20), ElevatedButton( style: 
//ElevatedButton.styleFrom( backgroundColor: const Color(0xFF7B2FF7), 
//shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(12), ), ), 
//onPressed: () { 
// Navigate to subscription screen 
//Navigator.pushNamed(context, "/writer-subscription"); }, 
//child: const Text("Upgrade Now"), 
//) 
//], 
//),
// ), 
 //), 
 //), 
 //),
 // );
  // }
  //  }
    