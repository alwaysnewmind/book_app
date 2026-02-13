import 'package:flutter/material.dart';
import 'widgets/library_books_grid.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          /// 🔥 PARALLAX HERO BANNER
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final percent =
                    (constraints.maxHeight - kToolbarHeight) / 200;

                return Stack(
                  fit: StackFit.expand,
                  children: [

                    /// Background Image (Parallax)
                    Transform.translate(
                      offset: Offset(0, percent * -30),
                      child: Image.asset(
                        "assets/books/Book1.png",
                        fit: BoxFit.cover,
                      ),
                    ),

                    /// Gradient Overlay
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black87,
                            Colors.black,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),

                    /// Banner Content
                    Positioned(
                      left: 20,
                      bottom: 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Featured Book",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "The Silent Reader",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {},
                            child: const Text("Continue Reading"),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          /// 📚 CONTINUE READING SECTION
          SliverToBoxAdapter(
            child: _sectionTitle("Continue Reading"),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 170,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return _continueCard("assets/books/Book${index + 1}.png");
                },
              ),
            ),
          ),

          /// 🎯 CATEGORY SLIDER
          SliverToBoxAdapter(
            child: _sectionTitle("Categories"),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  _CategoryChip(label: "All"),
                  _CategoryChip(label: "Reading"),
                  _CategoryChip(label: "Completed"),
                  _CategoryChip(label: "Saved"),
                  _CategoryChip(label: "Premium"),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),

          /// 📖 BOOK GRID
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverFillRemaining(
              hasScrollBody: true,
              child: LibraryBooksGrid(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _continueCard(String image) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            image,
            width: 120,
            fit: BoxFit.cover,
          ),
        ),

        /// Progress bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 4,
            color: Colors.white24,
            child: FractionallySizedBox(
              widthFactor: 0.6,
              child: Container(
                color: Colors.redAccent,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.white10,
        labelStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}
