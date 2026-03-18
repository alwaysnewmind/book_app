import 'package:book_app/features/auth/provider/auth_provider.dart';
import 'package:book_app/features/writer/provider/writer_provider.dart';
import 'package:book_app/shared/widgets/app_popup.dart';
import 'package:book_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageBooksPage extends StatefulWidget {
  const ManageBooksPage({super.key});

  @override
  State<ManageBooksPage> createState() => _ManageBooksPageState();
}

class _ManageBooksPageState extends State<ManageBooksPage> {
  bool _errorShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      context.read<WriterProvider>().loadWriterStudio(
            user: auth.currentUser,
            isGuest: auth.isGuest,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF1F1533),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Manage Books',
          style: TextStyle(
            color: Colors.white,
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
        child: Consumer<WriterProvider>(
          builder: (context, writer, _) {
            // Show error popup once
            if (writer.error != null && !_errorShown) {
              _errorShown = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                showAppPopup(
                  context: context,
                  title: 'Unable to load books',
                  message: writer.error!,
                  buttonText: 'OK',
                );
              });
            }

            // Loading state
            if (writer.isLoading && !writer.isLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            // No books
            if (writer.writerBooks.isEmpty) {
              return const Center(
                child: Text(
                  'No books available to manage.',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            // Optional banner for dummy books
            final hasDummyBooks =
                writer.writerBooks.any((b) => b.authorId == 'dummy');

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (hasDummyBooks)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent.withValues(alpha:0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'You are viewing temporary dummy books',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ...writer.writerBooks.map((book) {
                  final canEdit =
                      writer.canEditBook(book: book, user: currentUser);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 22),
                    decoration: BoxDecoration(
                      color: const Color(0xFF251A3F),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFF3A2D5C)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD76A).withValues(alpha:0.05),
                          blurRadius: 25,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  book.author,
                                  style: const TextStyle(
                                    color: Color(0xFFCFC8E8),
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    // Rating Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF251A3F),
                                        borderRadius: BorderRadius.circular(10),
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
                                            book.rating.toStringAsFixed(1),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Free / Premium Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: book.isPremium
                                            ? const Color(0xFFF5C84C)
                                            : const Color(0xFF251A3F),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: book.isPremium
                                              ? const Color(0xFFE6B93E)
                                              : const Color(0xFF3A2D5C),
                                        ),
                                        boxShadow: book.isPremium
                                            ? [
                                                BoxShadow(
                                                  color: const Color(0xFFFFD76A)
                                                      .withValues(alpha:0.3),
                                                  blurRadius: 18,
                                                )
                                              ]
                                            : [],
                                      ),
                                      child: Text(
                                        book.isPremium ? 'Premium' : 'Free',
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
                                // Action Icons
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _ActionIcon(
                                      icon: Icons.edit,
                                      onTap: canEdit
                                          ? () {
                                              Navigator.pushNamed(
                                                context,
                                                AppRoutes.createBookEntry,
                                                arguments: {'bookId': book.id},
                                              );
                                            }
                                          : () {
                                              showAppPopup(
                                                context: context,
                                                title: 'Access denied',
                                                message:
                                                    'You can only edit your own books.',
                                                buttonText: 'OK',
                                              );
                                            },
                                    ),
                                    _ActionIcon(
                                      icon: Icons.analytics,
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, AppRoutes.writerAnalytics);
                                      },
                                    ),
                                    _ActionIcon(
                                      icon: Icons.delete,
                                      onTap: () {
                                        showAppPopup(
                                          context: context,
                                          title: 'Info',
                                          message: 'Delete flow is not enabled yet.',
                                          buttonText: 'OK',
                                        );
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
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}

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
        child: Icon(
          icon,
          color: const Color(0xFFF5C84C),
          size: 18,
        ),
      ),
    );
  }
}