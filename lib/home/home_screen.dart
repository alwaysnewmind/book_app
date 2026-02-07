import 'package:flutter/material.dart';
import '../book/book_detail_screen.dart';
import 'widgets/book_card.dart';
import 'widgets/app_drawer.dart';
import 'widgets/banner_slider.dart';
import 'widgets/service_tile.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ---------------- DATA ----------------

  List<String> get books => List.generate(
        20,
        (i) => 'assets/books/images/book${(i % 6) + 1}.png',
      );

  final List<String> banners = const [
    'assets/banners/banner1.jpg',
    'assets/banners/banner2.jpg',
    'assets/banners/banner3.jpg',
  ];

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1A1A),
      drawer: const AppDrawer(),
      appBar: _appBar(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            _searchBar(),

            _sectionContainer(
              title: 'Featured Books',
              child: Column(
                children: [
                  _bookGrid(context, books.take(8).toList()),
                  const SizedBox(height: 8),
                  _viewMoreButton(context),
                ],
              ),
            ),

            BannerSlider(banners: banners),

            _sectionContainer(
              title: 'Other Services',
              child: _serviceGrid(
                context,
                icons: const [
                  Icons.menu_book,
                  Icons.format_quote,
                  Icons.lightbulb,
                  Icons.auto_stories,
                  Icons.favorite,
                  Icons.psychology,
                  Icons.star,
                  Icons.school,
                ],
                titles: const [
                  'Sessions',
                  'Quotes',
                  'Motivation',
                  'Stories',
                  'Love',
                  'Mind',
                  'Top',
                  'Learn',
                ],
              ),
            ),

            BannerSlider(banners: banners),

            _sectionContainer(
              title: 'Extra Services',
              child: _serviceGrid(
                context,
                icons: const [
                  Icons.headphones,
                  Icons.flag,
                  Icons.groups,
                  Icons.workspace_premium,
                ],
                titles: const [
                  'Audio',
                  'Challenges',
                  'Community',
                  'Premium',
                ],
              ),
            ),

            _sectionContainer(
              title: 'More',
              child: _serviceGrid(
                context,
                icons: const [
                  Icons.edit,
                  Icons.publish,
                  Icons.attach_money,
                  Icons.feedback,
                ],
                titles: const [
                  'Writer Hub',
                  'Publish',
                  'Earn',
                  'Feedback',
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- UI ----------------

  PreferredSizeWidget _appBar() => AppBar(
        backgroundColor: const Color(0xFF0E1A1A),
        elevation: 0,
        title: const Text('Readora'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Text('Hi, Rahul'),
                SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage('assets/profile/male.png'),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _searchBar() => Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search books...',
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.white10,
            prefixIcon: const Icon(Icons.search, color: Colors.white54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      );

  Widget _sectionContainer({
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF132222),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  // ---------------- SERVICE GRID ----------------

  Widget _serviceGrid(
    BuildContext context, {
    required List<IconData> icons,
    required List<String> titles,
  }) {
    return LayoutBuilder(
      builder: (_, c) {
        double iconSize = 24;
        double fontSize = 12;
        double padding = 12;

        if (c.maxWidth > 1000) {
          iconSize = 30;
          fontSize = 13;
          padding = 16;
        } else if (c.maxWidth > 600) {
          iconSize = 26;
          fontSize = 12;
          padding = 14;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: icons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (_, i) => _HoverScale(
            child: Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icons[i], size: iconSize, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    titles[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------- BOOK GRID ----------------

  Widget _bookGrid(BuildContext context, List<String> list) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, i) => BookCard(
        imagePath: list[i],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookDetailScreen(
                imagePath: list[i],
                title: 'Book ${i + 1}',
                isLocked: false,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _viewMoreButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.arrow_forward, color: Colors.white),
        label:
            const Text('View More', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// ---------------- HOVER EFFECT (WEB) ----------------

class _HoverScale extends StatefulWidget {
  final Widget child;
  const _HoverScale({required this.child});

  @override
  State<_HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<_HoverScale> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform:
            _hover ? (Matrix4.identity()..scale(1.05)) : Matrix4.identity(),
        child: widget.child,
      ),
    );
  }
}
