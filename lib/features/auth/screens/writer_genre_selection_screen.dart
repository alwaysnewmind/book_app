import 'package:flutter/material.dart';
import 'package:book_app/core/routes/app_routes.dart';

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

  void _goToHome() {
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  // 🎨 Exact Premium Colors (Image Match)
  static const Color bgDark = Color(0xFF1F1533);
  static const Color bgTop = Color(0xFF2E1B47);
  static const Color yellow = Color(0xFFFFD86B);
  static const Color chipBorder = Color(0xFF5C4A80);
  static const Color subtitleColor = Color(0xFFB8AFCF);
  static const Color white = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [
              bgTop,
              bgDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [

                const SizedBox(height: 20),

                /// 🔥 Header
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.menu_book,
                            color: yellow, size: 26),
                        SizedBox(width: 10),
                        Text(
                          "Writer App",
                          style: TextStyle(
                            color: white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white24,
                    )
                  ],
                ),

                const SizedBox(height: 40),

                const Text(
                  "Tell Us What You Love",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: white,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Choose your favorite genres to write about.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 40),

                /// 🔥 Genre Chips
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: genres.map((genre) {
                        final isSelected =
                            selectedGenres.contains(genre);

                        return GestureDetector(
                          onTap: () => toggleGenre(genre),
                          child: AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 250),
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? yellow.withOpacity(0.15)
                                  : Colors.transparent,
                              borderRadius:
                                  BorderRadius.circular(30),
                              border: Border.all(
                                color: isSelected
                                    ? yellow
                                    : chipBorder,
                                width: 1.5,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: yellow
                                            .withOpacity(0.5),
                                        blurRadius: 20,
                                        spreadRadius: 1,
                                      )
                                    ]
                                  : [],
                            ),
                            child: Row(
                              mainAxisSize:
                                  MainAxisSize.min,
                              children: [
                                Text(
                                  genre,
                                  style: TextStyle(
                                    color: isSelected
                                        ? yellow
                                        : white,
                                    fontWeight:
                                        FontWeight.w500,
                                  ),
                                ),
                                if (isSelected) ...[
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.check_circle,
                                    color: yellow,
                                    size: 18,
                                  ),
                                ]
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔥 Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellow,
                      disabledBackgroundColor:
                          chipBorder,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: selectedGenres.isEmpty
                        ? null
                        : _goToHome,
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: bgDark,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// 🔥 Skip Button
                TextButton(
                  onPressed: _goToHome,
                  child: const Text(
                    "Skip for now",
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}