import 'package:flutter/material.dart';
import 'package:book_app/data/dummy_books.dart';

class ManageBooksPage extends StatelessWidget {
  const ManageBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1A1A),
        elevation: 0,
        title: const Text("Manage Books"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyBooks.length,
        itemBuilder: (context, index) {
          final book = dummyBooks[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: const Color(0xFF162323),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [

                /// 📕 Cover Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                  child: Image.asset(
                    book.coverImage,
                    width: 100,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),

                /// 📖 Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// Title
                        Text(
                          book.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
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
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// Rating + Status Row
                        Row(
                          children: [

                            /// ⭐ Rating
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 14,
                                      color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(
                                    book.rating.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 10),

                            /// 💰 Premium / Free Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: book.isPremium
                                    ? Colors.deepPurple
                                    : Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                book.isPremium ? "Premium" : "Free",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        /// ✏ Action Buttons
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [

                            _ActionIcon(
                              icon: Icons.edit,
                              color: Colors.blueAccent,
                              onTap: () {
                                // TODO: Navigate to Edit Page
                              },
                            ),

                            _ActionIcon(
                              icon: Icons.analytics,
                              color: Colors.orangeAccent,
                              onTap: () {
                                // TODO: Open Analytics
                              },
                            ),

                            _ActionIcon(
                              icon: Icons.delete,
                              color: Colors.redAccent,
                              onTap: () {
                                // TODO: Delete Logic
                              },
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
    );
  }
}

///////////////////////////////////////////////////////////////
/// ACTION ICON
///////////////////////////////////////////////////////////////

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
