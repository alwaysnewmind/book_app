import 'package:flutter/material.dart';
import '../book/book_detail_screen.dart';
import 'widgets/book_card.dart';
import 'widgets/banner_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 📚 Books from assets
  List<String> get books => List.generate(
        10,
        (index) => 'assets/books/images/book${index + 1}.png',
      );

  // 🖼️ Banner images
  List<String> get banners => [
        'assets/banners/banner1.jpg',
        'assets/banners/banner2.jpg',
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1A1A),

      // 🔝 TOP APP BAR
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1A1A),
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Readora',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Spacer(),
            const Text(
              'Hi, Jay',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                // 🔜 STEP 3: Drawer / Profile
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/profile/male.png'),
              ),
            ),
          ],
        ),
      ),

      // 🧠 BODY
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // 🔍 SEARCH BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search books, authors, categories',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white10,
                  prefixIcon:
                      const Icon(Icons.search, color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 📢 BANNER SLIDER (ADS / PROMO)
            BannerSlider(banners: banners),

            const SizedBox(height: 28),

            // 📚 FEATURED / POPULAR BOOKS TITLE
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Popular Books',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 📚 FEATURED BOOK GRID (HERO SECTION)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: books.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // tablet / web friendly
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  return BookCard(
                    imagePath: books[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookDetailScreen(
                            imagePath: books[index],
                            title: 'Book ${index + 1}',
                            isLocked: index % 2 == 0, // demo lock
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
