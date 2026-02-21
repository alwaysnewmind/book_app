import 'package:flutter/material.dart';

class QuotesDashboard extends StatefulWidget {
  const QuotesDashboard({Key? key}) : super(key: key);

  @override
  State<QuotesDashboard> createState() => _QuotesDashboardState();
}

class _QuotesDashboardState extends State<QuotesDashboard> {
  String selectedCategory = "Emotional";

  final List<String> categories = [
    "Emotional",
    "Motivational",
    "Love",
    "Success",
    "Life",
  ];

  final List<QuoteModel> allQuotes = [
    QuoteModel(
      category: "Emotional",
      quote: "Tears come from the heart, not from the brain.",
      author: "Leonardo da Vinci",
      tag: "Deep",
    ),
    QuoteModel(
      category: "Motivational",
      quote: "Push yourself, because no one else is going to do it for you.",
      author: "Unknown",
      tag: "Focus",
    ),
    QuoteModel(
      category: "Love",
      quote: "Love is not what you say. Love is what you do.",
      author: "Unknown",
      tag: "Relationship",
    ),
    QuoteModel(
      category: "Success",
      quote: "Success doesn’t just find you. You have to go out and get it.",
      author: "Unknown",
      tag: "Growth",
    ),
    QuoteModel(
      category: "Life",
      quote: "Life is really simple, but we insist on making it complicated.",
      author: "Confucius",
      tag: "Wisdom",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredQuotes = allQuotes
        .where((quote) => quote.category == selectedCategory)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xffF4EEFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),

              /// TITLE
              const Text(
                "My Quotes",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2E1A47)),
              ),

              const SizedBox(height: 20),

              /// CATEGORY TABS
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = selectedCategory == category;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
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
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// QUOTES LIST
              Expanded(
                child: ListView.builder(
                  itemCount: filteredQuotes.length,
                  itemBuilder: (context, index) {
                    final quote = filteredQuotes[index];
                    return QuoteCard(quote: quote);
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      /// FLOATING BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

///// QUOTE MODEL
class QuoteModel {
  final String category;
  final String quote;
  final String author;
  final String tag;

  QuoteModel({
    required this.category,
    required this.quote,
    required this.author,
    required this.tag,
  });
}

///// QUOTE CARD
class QuoteCard extends StatelessWidget {
  final QuoteModel quote;

  const QuoteCard({Key? key, required this.quote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            '"${quote.quote}"',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.4),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "- ${quote.author}",
                style: const TextStyle(
                    fontSize: 13, color: Colors.black54),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff8E2DE2),
                      Color(0xff4A00E0)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  quote.tag,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 12),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}