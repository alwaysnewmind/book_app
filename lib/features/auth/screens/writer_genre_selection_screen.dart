import 'package:flutter/material.dart';

class WriterGenreSelectionScreen extends StatefulWidget {
  const WriterGenreSelectionScreen({Key? key}) : super(key: key);

  @override
  State<WriterGenreSelectionScreen> createState() =>
      _WriterGenreSelectionScreenState();
}

class _WriterGenreSelectionScreenState
    extends State<WriterGenreSelectionScreen> {

  final List<String> genres = [
    "Fantasy",
    "Science Fiction",
    "Mystery",
    "Thriller",
    "Romance",
    "Historical Fiction",
    "Short Stories",
    "Poetry",
  ];

  final Set<String> selectedGenres = {};

  void toggleGenre(String genre) {
    setState(() {
      if (selectedGenres.contains(genre)) {
        selectedGenres.remove(genre);
      } else {
        selectedGenres.add(genre);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7B2FF7),
              Color(0xFFF107A3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              /// Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.menu_book_rounded,
                            color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Writer App",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, color: Colors.white),
                    )
                  ],
                ),
              ),

              const Spacer(),

              /// White Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Tell Us What You Love",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Choose your favorite genres to write about.",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    /// Genres
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: genres.map((genre) {
                        final isSelected =
                            selectedGenres.contains(genre);

                        return GestureDetector(
                          onTap: () => toggleGenre(genre),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF7B2FF7)
                                      .withOpacity(0.15)
                                  : Colors.grey.shade100,
                              borderRadius:
                                  BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF7B2FF7)
                                    : Colors.transparent,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  size: 18,
                                  color: isSelected
                                      ? const Color(0xFF7B2FF7)
                                      : Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  genre,
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.w500,
                                    color: isSelected
                                        ? const Color(0xFF7B2FF7)
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 30),

                    /// Continue Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF7B2FF7),
                          padding:
                              const EdgeInsets.symmetric(
                                  vertical: 14),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: selectedGenres.isEmpty
                            ? null
                            : () {
                                // Save genres logic here
                                Navigator.pushReplacementNamed(
                                  context,
                                  "/writer-dashboard",
                                );
                              },
                        child: const Text(
                          "Continue",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context,
                              "/writer-dashboard");
                        },
                        child: const Text("Skip for now"),
                      ),
                    )
                  ],
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
