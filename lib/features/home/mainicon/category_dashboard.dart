import 'package:flutter/material.dart';

class CategoryDashboard extends StatelessWidget {
  const CategoryDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4EEFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),

              /// APP TITLE
              const Text(
                "BookVerse",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Explore Categories 📚",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2E1A47),
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                "Find books that match the mood.",
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 20),

              /// SEARCH BAR
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Search genres, authors, books...",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Icon(Icons.tune, color: Colors.grey),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// CATEGORY GRID
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: dummyCategories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1.2,
                        ),
                        itemBuilder: (context, index) {
                          final category = dummyCategories[index];
                          return CategoryCard(category: category);
                        },
                      ),

                      const SizedBox(height: 25),

                      /// TRENDING
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Trending Categories 🔥",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: trendingBooks.length,
                          itemBuilder: (context, index) {
                            return TrendingCard(
                              image: trendingBooks[index],
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// RECOMMENDED
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Recommended For You",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(height: 5),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Based on your reading",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      /// BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore), label: "Discover"),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view), label: "Browse"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_outline), label: "Community"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}

///// CATEGORY MODEL
class CategoryModel {
  final String title;
  final String subtitle;
  final IconData icon;

  CategoryModel({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

///// DUMMY DATA
final List<CategoryModel> dummyCategories = [
  CategoryModel(
    title: "Fiction",
    subtitle: "24k books",
    icon: Icons.menu_book,
  ),
  CategoryModel(
    title: "Self Growth",
    subtitle: "2.3k books",
    icon: Icons.trending_up,
  ),
  CategoryModel(
    title: "Comics",
    subtitle: "1.3k books",
    icon: Icons.auto_stories,
  ),
  CategoryModel(
    title: "Romance",
    subtitle: "3.1k books",
    icon: Icons.favorite,
  ),
];

///// CATEGORY CARD
class CategoryCard extends StatelessWidget {
  final CategoryModel category;

  const CategoryCard({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              category.icon,
              color: Colors.purple,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  category.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  category.subtitle,
                  style: const TextStyle(
                      color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 14, color: Colors.grey)
        ],
      ),
    );
  }
}

///// TRENDING CARD
class TrendingCard extends StatelessWidget {
  final String image;

  const TrendingCard({Key? key, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

///// DUMMY TRENDING IMAGES
final List<String> trendingBooks = [
  "assets/books/book1.png",
  "assets/books/book2.png",
  "assets/books/book3.png",
  "assets/books/book4.png",
];