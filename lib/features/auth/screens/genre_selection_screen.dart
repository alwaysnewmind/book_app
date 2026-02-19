import 'package:flutter/material.dart';

class GenreSelectionScreen extends StatefulWidget {
  const GenreSelectionScreen({super.key});

  @override
  State<GenreSelectionScreen> createState() =>
      _GenreSelectionScreenState();
}

class _GenreSelectionScreenState
    extends State<GenreSelectionScreen> {

  final List<String> genres = [
    "Fantasy",
    "Science Fiction",
    "Mystery & Thriller",
    "Romance",
    "Historical Fiction",
    "Biography",
    "Young Adult",
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
              Color(0xFF7F00FF),
              Color(0xFFE100FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              const SizedBox(height: 20),

              /// Top Branding
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.menu_book,
                      color: Colors.white, size: 28),
                  SizedBox(width: 8),
                  Text(
                    "Reader App",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Illustration
              Image.asset(
                "assets/images/reader.png",
                height: 150,
              ),

              const SizedBox(height: 20),

              /// Bottom Container
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 30),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center,
                    children: [

                      const Text(
                        "Tell Us What You Love",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Choose your favorite genres to get started.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// Genre Grid
                      Expanded(
                        child: GridView.builder(
                          itemCount: genres.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 3.2,
                          ),
                          itemBuilder: (context, index) {
                            final genre = genres[index];
                            final isSelected =
                                selectedGenres.contains(genre);

                            return GestureDetector(
                              onTap: () =>
                                  toggleGenre(genre),
                              child: AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 250),
                                padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 14),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(30),
                                  gradient: isSelected
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFF7F00FF),
                                            Color(0xFFE100FF),
                                          ],
                                        )
                                      : null,
                                  color: isSelected
                                      ? null
                                      : Colors.grey.shade200,
                                  boxShadow: [
                                    if (isSelected)
                                      BoxShadow(
                                        color: Colors.purple
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset:
                                            const Offset(0, 4),
                                      ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          isSelected
                                              ? Icons.check_box
                                              : Icons
                                                  .check_box_outline_blank,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors
                                                  .deepPurple,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          genre,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight:
                                                FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (isSelected)
                                      const CircleAvatar(
                                        radius: 10,
                                        backgroundColor:
                                            Colors.white,
                                        child: Icon(
                                          Icons.check,
                                          size: 14,
                                          color:
                                              Color(0xFF7F00FF),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// Continue Button
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF7F00FF),
                              Color(0xFFE100FF),
                            ],
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Navigate next
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Continue",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// Skip
                      GestureDetector(
                        onTap: () {
                          // TODO: Skip navigation
                        },
                        child: const Text(
                          "Skip for now",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
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
