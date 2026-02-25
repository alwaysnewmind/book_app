import 'package:flutter/material.dart';
import 'package:book_app/core/routes/app_routes.dart';

class CreateBookScreen extends StatefulWidget {
  const CreateBookScreen({super.key});

  @override
  State<CreateBookScreen> createState() => _CreateBookScreenState();
}

class _CreateBookScreenState extends State<CreateBookScreen> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _descController = TextEditingController();

  bool _isPremium = false;
  String _selectedGenre = "Fiction";

  final List<String> _genres = [
    "Fiction",
    "Romance",
    "Thriller",
    "Horror",
    "Self Growth",
    "Business"
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1533),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Create New Book",
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ================= COVER PREVIEW =================
              Center(
                child: Container(
                  height: 210,
                  width: 155,
                  decoration: BoxDecoration(
                    color: const Color(0xFF251A3F),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFF3A2D5C)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD76A)
                            .withOpacity(0.08),
                        blurRadius: 40,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      color: Color(0xFFCFC8E8),
                      size: 42,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// ================= TITLE =================
              _label("BOOK TITLE"),
              _inputField(
                controller: _titleController,
                hint: "Enter book title",
              ),

              const SizedBox(height: 22),

              /// ================= SUBTITLE =================
              _label("SUBTITLE"),
              _inputField(
                controller: _subtitleController,
                hint: "Optional subtitle",
              ),

              const SizedBox(height: 22),

              /// ================= GENRE =================
              _label("GENRE"),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF251A3F),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF3A2D5C)),
                ),
                child: DropdownButton<String>(
                  value: _selectedGenre,
                  dropdownColor: const Color(0xFF251A3F),
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFFF5C84C),
                  ),
                  style: const TextStyle(color: Color(0xFFFFFFFF)),
                  items: _genres.map((genre) {
                    return DropdownMenuItem(
                      value: genre,
                      child: Text(genre),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGenre = value!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 22),

              /// ================= DESCRIPTION =================
              _label("DESCRIPTION"),
              _inputField(
                controller: _descController,
                hint: "Write short description...",
                maxLines: 4,
              ),

              const SizedBox(height: 26),

              /// ================= PREMIUM TOGGLE =================
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF251A3F),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFF3A2D5C)),
                ),
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: const Color(0xFFF5C84C),
                  activeTrackColor:
                      const Color(0xFFE6B93E).withOpacity(0.5),
                  value: _isPremium,
                  title: const Text(
                    "Mark as Premium Book",
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _isPremium = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 42),

              /// ================= SAVE BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 60,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Book saved as draft"),
                      ),
                    );
                    Navigator.pushNamed(context, AppRoutes.createBookEntry, arguments: {
                      'title': _titleController.text.trim(),
                      'subtitle': _subtitleController.text.trim(),
                      'description': _descController.text.trim(),
                      'genre': _selectedGenre,
                      'isPremium': _isPremium,
                    });
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5C84C),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD76A)
                              .withOpacity(0.3),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Save & Continue",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F1533),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= LABEL =================
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF9F96C8),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    );
  }

  // ================= INPUT =================
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Color(0xFFFFFFFF)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9F96C8)),
        filled: true,
        fillColor: const Color(0xFF251A3F),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide:
              const BorderSide(color: Color(0xFF3A2D5C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide:
              const BorderSide(color: Color(0xFFF5C84C), width: 1.3),
        ),
      ),
    );
  }
}
