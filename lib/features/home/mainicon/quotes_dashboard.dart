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
      backgroundColor: const Color(0xFF1F1533),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1F1533),
              Color(0xFF2A1E47),
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

                const SizedBox(height: 20),

                /// TITLE
                const Text(
                  "My Quotes",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF),
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 28),

                /// CATEGORY TABS
                SizedBox(
                  height: 42,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected =
                          selectedCategory == category;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        child: AnimatedContainer(
                          duration:
                              const Duration(milliseconds: 250),
                          margin:
                              const EdgeInsets.only(right: 12),
                          padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFF5C84C)
                                : const Color(0xFF251A3F),
                            borderRadius:
                                BorderRadius.circular(30),
                            border: Border.all(
                                color:
                                    const Color(0xFF3A2D5C)),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color:
                                          const Color(0xFFFFD76A)
                                              .withOpacity(0.3),
                                      blurRadius: 14,
                                    )
                                  ]
                                : [],
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected
                                  ? const Color(0xFF1F1533)
                                  : const Color(0xFFCFC8E8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 25),

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
      ),

      /// FLOATING BUTTON
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color:
                  const Color(0xFFFFD76A).withOpacity(0.3),
              blurRadius: 18,
              spreadRadius: 2,
            )
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFF5C84C),
          onPressed: () {},
          child: const Icon(
            Icons.add,
            color: Color(0xFF1F1533),
          ),
        ),
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

  const QuoteCard({Key? key, required this.quote})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
            color: const Color(0xFF3A2D5C)),
        boxShadow: [
          BoxShadow(
            color:
                const Color(0xFFFFD76A).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Text(
            '"${quote.quote}"',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: Color(0xFFFFFFFF),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "- ${quote.author}",
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9F96C8),
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5C84C),
                  borderRadius:
                      BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color:
                          const Color(0xFFFFD76A)
                              .withOpacity(0.3),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Text(
                  quote.tag,
                  style: const TextStyle(
                    color: Color(0xFF1F1533),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}