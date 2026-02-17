import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFF0E1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1A1A),
        elevation: 0,
        title: const Text("Create New Book"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================= COVER PREVIEW =================
            Center(
              child: Container(
                height: 190,
                width: 135,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2A3F3F),
                      Color(0xFF162323),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.add_a_photo_outlined,
                    color: Colors.white60,
                    size: 38,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// ================= TITLE =================
            _label("Book Title"),
            _inputField(
              controller: _titleController,
              hint: "Enter book title",
            ),

            const SizedBox(height: 18),

            /// ================= SUBTITLE =================
            _label("Subtitle"),
            _inputField(
              controller: _subtitleController,
              hint: "Optional subtitle",
            ),

            const SizedBox(height: 18),

            /// ================= GENRE =================
            _label("Genre"),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF162323),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white10),
              ),
              child: DropdownButton<String>(
                value: _selectedGenre,
                dropdownColor: const Color(0xFF162323),
                isExpanded: true,
                underline: const SizedBox(),
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
                items: _genres.map((genre) {
                  return DropdownMenuItem(
                    value: genre,
                    child: Text(
                      genre,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGenre = value!;
                  });
                },
              ),
            ),

            const SizedBox(height: 18),

            /// ================= DESCRIPTION =================
            _label("Description"),
            _inputField(
              controller: _descController,
              hint: "Write short description...",
              maxLines: 4,
            ),

            const SizedBox(height: 20),

            /// ================= PREMIUM TOGGLE =================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF162323),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white10),
              ),
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: Colors.amber,
                value: _isPremium,
                title: const Text(
                  "Mark as Premium Book",
                  style: TextStyle(color: Colors.white),
                ),
                onChanged: (value) {
                  setState(() {
                    _isPremium = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 32),

            /// ================= SAVE BUTTON =================
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Book saved as draft"),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  "Save & Continue",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // REUSABLE UI COMPONENTS
  // ======================================================

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: const Color(0xFF162323),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
