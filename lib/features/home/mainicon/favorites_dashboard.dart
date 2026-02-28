import 'package:book_app/features/book/book_detail_screen.dart';
import 'package:book_app/models/book_model.dart';
import 'package:book_app/providers/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesDashboard extends StatefulWidget {
  const FavoritesDashboard({Key? key}) : super(key: key);

  @override
  State<FavoritesDashboard> createState() => _FavoritesDashboardState();
}

class _FavoritesDashboardState extends State<FavoritesDashboard> {
  int selectedFilter = 0;

  final List<String> filters = [
    "All",
    "Recently Added",
    "Most Read",
    "Downloaded"
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesProvider>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffEEE7FF),
              Color(0xffF8F5FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              final favoriteBooks = _applyFilter(favoritesProvider.favoriteBooks);
              final heroBook = favoriteBooks.isNotEmpty ? favoriteBooks.first : null;

              return RefreshIndicator(
                onRefresh: favoritesProvider.refreshFavorites,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        /// TITLE
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Your Favorites",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.favorite_border)
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// HERO CARD
                        Container(
                          height: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            image: DecorationImage(
                              image: AssetImage(heroBook?.coverUrl.isNotEmpty == true
                                  ? heroBook!.coverUrl
                                  : "assets/books/Book1.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  heroBook?.title.isNotEmpty == true
                                      ? heroBook!.title
                                      : "The Midnight Library",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Your Most Loved Book",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// FILTER CHIPS
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: filters.length,
                            itemBuilder: (context, index) {
                              final isSelected = selectedFilter == index;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedFilter = index;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? const LinearGradient(
                                            colors: [
                                              Color(0xff8E2DE2),
                                              Color(0xff4A00E0)
                                            ],
                                          )
                                        : null,
                                    color:
                                        isSelected ? null : Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    filters[index],
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Favorite Books",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 15),

                        /// BOOK LIST
                        if (favoritesProvider.isLoading)
                          const SizedBox(
                            height: 210,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (favoritesProvider.error != null)
                          SizedBox(
                            height: 210,
                            child: Center(
                              child: Text(
                                favoritesProvider.error!,
                                style: const TextStyle(color: Colors.redAccent),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        else if (favoriteBooks.isEmpty)
                          const SizedBox(
                            height: 210,
                            child: Center(
                              child: Text(
                                'No favorites yet. Pull down to refresh.',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            height: 210,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: favoriteBooks.length,
                              itemBuilder: (context, index) {
                                return FavoriteBookCard(
                                  book: favoriteBooks[index],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BookDetailScreen(
                                          book: favoriteBooks[index].toWriterBook(),
                                        ),
                                      ),
                                    );
                                  },
                                  onLongPress: () {
                                    favoritesProvider.removeFromFavorites(favoriteBooks[index].id);
                                  },
                                );
                              },
                            ),
                          ),

                        const Spacer(),

                        /// BOTTOM TEXT
                        const Center(
                          child: Text(
                            "Long press to manage",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),

      /// FLOATING BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          context.read<FavoritesProvider>().refreshFavorites();
        },
        child: const Icon(Icons.bookmark),
      ),
    );
  }

  List<BookModel> _applyFilter(List<BookModel> source) {
    if (selectedFilter == 1) {
      return [...source]..sort((a, b) => b.savedAt.compareTo(a.savedAt));
    }
    if (selectedFilter == 2) {
      return [...source]..sort((a, b) => b.viewsCount.compareTo(a.viewsCount));
    }
    if (selectedFilter == 3) {
      return source.where((book) => book.pdfPath.isNotEmpty).toList();
    }
    return source;
  }
}

///// CARD
class FavoriteBookCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const FavoriteBookCard({
    Key? key,
    required this.book,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    image: DecorationImage(
                      image: AssetImage(book.coverUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              book.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              book.authorName,
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (book.rating / 5).clamp(0, 1),
                minHeight: 6,
                backgroundColor:
                    Colors.purple.shade100,
                valueColor:
                    const AlwaysStoppedAnimation(
                        Colors.purple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
