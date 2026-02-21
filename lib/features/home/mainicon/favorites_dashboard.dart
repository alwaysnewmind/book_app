import 'package:flutter/material.dart';

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

  final List<BookModel> favoriteBooks = [
    BookModel(
      title: "The Midnight Library",
      author: "Matt Haig",
      image: "assets/books/Book1.png",
      progress: 0.7,
    ),
    BookModel(
      title: "Project Hail Mary",
      author: "Andy Weir",
      image: "assets/books/Book2.png",
      progress: 0.5,
    ),
    BookModel(
      title: "Circe",
      author: "Madeline Miller",
      image: "assets/books/Book3.png",
      progress: 0.3,
    ),
    BookModel(
      title: "The Vanishing Half",
      author: "Brit Bennett",
      image: "assets/books/Book4.png",
      progress: 0.6,
    ),
  ];

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    image: const DecorationImage(
                      image: AssetImage("assets/books/Book1.png"),
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
                      children: const [
                        Text(
                          "The Midnight Library",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Your Most Loved Book",
                          style: TextStyle(
                              color: Colors.white70),
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
                SizedBox(
                  height: 210,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: favoriteBooks.length,
                    itemBuilder: (context, index) {
                      return FavoriteBookCard(
                        book: favoriteBooks[index],
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
      ),

      /// FLOATING BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {},
        child: const Icon(Icons.bookmark),
      ),
    );
  }
}

///// MODEL
class BookModel {
  final String title;
  final String author;
  final String image;
  final double progress;

  BookModel({
    required this.title,
    required this.author,
    required this.image,
    required this.progress,
  });
}

///// CARD
class FavoriteBookCard extends StatelessWidget {
  final BookModel book;

  const FavoriteBookCard({Key? key, required this.book})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    image: AssetImage(book.image),
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
            book.author,
            style: const TextStyle(
                fontSize: 12,
                color: Colors.black54),
          ),

          const SizedBox(height: 6),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: book.progress,
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
    );
  }
}