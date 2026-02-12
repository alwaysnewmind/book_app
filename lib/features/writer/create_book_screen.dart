import 'package:flutter/material.dart';

class CreateBookScreen extends StatefulWidget {
  const CreateBookScreen({super.key});

  @override
  State<CreateBookScreen> createState() => _CreateBookScreenState();
}

class _CreateBookScreenState extends State<CreateBookScreen> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  bool _isPremium = false;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1A1A),
      appBar: AppBar(
        title: const Text("Create New Book"),
        backgroundColor: const Color(0xFF0E1A1A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Book Title"),
            _inputField(
              controller: _titleController,
              hint: "Enter book title",
            ),

            const SizedBox(height: 16),

            _label("Author Name"),
            _inputField(
              controller: _authorController,
              hint: "Enter author name",
            ),

            const SizedBox(height: 20),

            _premiumToggle(),

            const SizedBox(height: 32),

            _saveButton(context),
          ],
        ),
      ),
    );
  }

  // ---------------- UI PARTS ----------------

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
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _premiumToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.workspace_premium, color: Colors.amber),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Mark as Premium Book",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Switch(
            value: _isPremium,
            activeColor: Colors.amber,
            onChanged: (v) {
              setState(() {
                _isPremium = v;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _saveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          // SAFE ACTION – no backend yet
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Book saved as draft"),
            ),
          );
          Navigator.pop(context);
        },
        child: const Text(
          "Save Draft",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
