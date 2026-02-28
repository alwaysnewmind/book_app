import 'package:book_app/models/writer_book_model.dart';
import 'package:book_app/providers/auth_provider.dart';
import 'package:book_app/providers/discover_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscoverDashboard extends StatelessWidget {
  const DiscoverDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscoverProvider>(
      builder: (context, discover, _) {
        if (!discover.isLoading &&
            discover.allBooks.isEmpty &&
            discover.error == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.read<DiscoverProvider>().loadDiscoverData();
            }
          });
        }

        return Scaffold(
          backgroundColor: const Color(0xFF1F1533),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1F1533),
                  Color(0xFF2A1E47),
                  Color(0xFF140F26),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: discover.refreshData,
                color: const Color(0xFFF5C84C),
                backgroundColor: const Color(0xFF251A3F),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      /// TITLE
                      const Text(
                        "Discover",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// SEARCH BAR
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF251A3F),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFF3A2D5C)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFD76A).withOpacity(0.08),
                              blurRadius: 20,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: TextField(
                          style: const TextStyle(color: Color(0xFFFFFFFF)),
                          onChanged: discover.searchBooks,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.search, color: Color(0xFFCFC8E8)),
                            hintText: "Search books, authors, genres...",
                            hintStyle: TextStyle(color: Color(0xFF9F96C8)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// CATEGORY CHIPS
                      SizedBox(
                        height: 42,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: discover.genres
                              .map(
                                (genre) => GestureDetector(
                                  onTap: () => discover.filterByGenre(genre),
                                  child: _categoryChip(
                                    genre,
                                    discover.selectedGenre == genre,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      if (discover.isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: CircularProgressIndicator(
                              color: Color(0xFFF5C84C),
                            ),
                          ),
                        )
                      else if (discover.error != null)
                        _ErrorState(message: discover.error!)
                      else if (discover.visibleBooks.isEmpty)
                        const _EmptyState()
                      else ...[
                        /// TRENDING
                        const Text(
                          "Trending Now 🔥",
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          height: 220,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: discover.trendingBooks
                                .map(
                                  (book) => _BookCard(
                                    book: book,
                                    onTap: () => _handleBookTap(context, book),
                                  ),
                                )
                                .toList(),
                          ),
                        ),

                        const SizedBox(height: 32),

                        /// RECOMMENDED (Popular)
                        const Text(
                          "Popular Books",
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 18,
                          crossAxisSpacing: 18,
                          childAspectRatio: 0.7,
                          children: discover.popularBooks
                              .take(4)
                              .map(
                                (book) => _BookCard(
                                  book: book,
                                  onTap: () => _handleBookTap(context, book),
                                ),
                              )
                              .toList(),
                        ),

                        const SizedBox(height: 32),

                        const Text(
                          "New Arrivals",
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 220,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: discover.newArrivalsBooks
                                .map(
                                  (book) => _BookCard(
                                    book: book,
                                    onTap: () => _handleBookTap(context, book),
                                  ),
                                )
                                .toList(),
                          ),
                        ),

                        const SizedBox(height: 32),

                        const Text(
                          "Top Rated",
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 18,
                          crossAxisSpacing: 18,
                          childAspectRatio: 0.7,
                          children: discover.topRatedBooks
                              .take(4)
                              .map(
                                (book) => _BookCard(
                                  book: book,
                                  onTap: () => _handleBookTap(context, book),
                                ),
                              )
                              .toList(),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// FLOATING BUTTON (Premium Gold)
          floatingActionButton: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD76A).withOpacity(0.30),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: FloatingActionButton(
              backgroundColor: const Color(0xFFF5C84C),
              elevation: 0,
              onPressed: () {},
              child: const Icon(
                Icons.explore,
                color: Color(0xFF1F1533),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleBookTap(BuildContext context, Book book) {
    final authProvider = context.read<AuthProvider>();
    final isPremiumUser = authProvider.currentUser?.isPremium ?? false;

    if (book.isPaid && !isPremiumUser) {
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Premium Required'),
          content: const Text('Upgrade to Premium to access this book'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
  }

  /// CATEGORY CHIP
  static Widget _categoryChip(String text, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF5C84C) : const Color(0xFF251A3F),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFF3A2D5C)),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFD76A).withOpacity(0.30),
                    blurRadius: 18,
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: selected ? const Color(0xFF1F1533) : const Color(0xFFCFC8E8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });

    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(
          'Unable to load books.',
          style: TextStyle(color: Color(0xFFCFC8E8)),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(
          'No books available right now.',
          style: TextStyle(color: Color(0xFFCFC8E8)),
        ),
      ),
    );
  }
}

/// BOOK CARD
class _BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const _BookCard({required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF3A2D5C)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD76A).withOpacity(0.08),
              blurRadius: 20,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Image.asset(
                book.coverImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              if (book.isPaid)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5C84C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Premium',
                      style: TextStyle(
                        color: Color(0xFF1F1533),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
