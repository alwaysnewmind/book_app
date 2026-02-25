import 'package:flutter/material.dart';
import 'package:book_app/data/dummy_books.dart';

class ManageBooksPage extends StatelessWidget {
  const ManageBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1533),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Manage Books",
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFF5C84C)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1F1533),
              Color(0xFF2A1E47),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: dummyBooks.length,
          itemBuilder: (context, index) {
            final book = dummyBooks[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 22),
              decoration: BoxDecoration(
                color: const Color(0xFF251A3F),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF3A2D5C)),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color(0xFFFFD76A).withOpacity(0.05),
                    blurRadius: 25,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [

                  /// 📕 Cover Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                    ),
                    child: Image.asset(
                      book.coverImage,
                      width: 105,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// 📖 Details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// Title
                          Text(
                            book.title,
                            style: const TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 6),

                          /// Author
                          Text(
                            book.author,
                            style: const TextStyle(
                              color: Color(0xFFCFC8E8),
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 12),

                          /// Rating + Status Row
                          Row(
                            children: [

                              /// ⭐ Rating
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF251A3F),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color(0xFF3A2D5C)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 15,
                                      color: Color(0xFFF5C84C),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      book.rating.toString(),
                                      style: const TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 12),

                              /// Premium / Free Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: book.isPremium
                                      ? const Color(0xFFF5C84C)
                                      : const Color(0xFF251A3F),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  border: Border.all(
                                    color: book.isPremium
                                        ? const Color(0xFFE6B93E)
                                        : const Color(0xFF3A2D5C),
                                  ),
                                  boxShadow: book.isPremium
                                      ? [
                                          BoxShadow(
                                            color: const Color(
                                                    0xFFFFD76A)
                                                .withOpacity(0.3),
                                            blurRadius: 18,
                                          )
                                        ]
                                      : [],
                                ),
                                child: Text(
                                  book.isPremium
                                      ? "Premium"
                                      : "Free",
                                  style: TextStyle(
                                    color: book.isPremium
                                        ? const Color(0xFF1F1533)
                                        : const Color(0xFFCFC8E8),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          /// ✏ Action Buttons
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [

                              _ActionIcon(
                                icon: Icons.edit,
                                onTap: () {},
                              ),

                              _ActionIcon(
                                icon: Icons.analytics,
                                onTap: () {},
                              ),

                              _ActionIcon(
                                icon: Icons.delete,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// ACTION ICON (Luxury Version)
///////////////////////////////////////////////////////////////

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF251A3F),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF3A2D5C)),
        ),
        child: const Icon(
          Icons.circle,
          size: 0,
        ),
      ),
    );
  }
}