import 'dart:ui';
import 'package:flutter/material.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchController = TextEditingController();

  int expandedIndex = 0;

  final List<Map<String, String>> faqs = [
    {
      "question": "How do reset & password?",
      "answer":
          "Go to Settings > Account > Reset Password. You will receive an email link to reset."
    },
    {
      "question": "What payment methods accepted?",
      "answer":
          "We accept Credit Card, Debit Card, UPI, PayPal and Google Pay."
    },
    {
      "question": "Using a downloaded books?",
      "answer":
          "You can access downloaded books from Offline Vault section anytime."
    },
  ];

  void toggleFAQ(int index) {
    setState(() {
      expandedIndex = expandedIndex == index ? -1 : index;
    });
  }

  void chatWithSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Opening Live Chat...")),
    );
  }

  void emailSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Opening Email Client...")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6DFFF),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE6DFFF), Color(0xFFCBB6FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// HEADER
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Help & Support",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4B2E83),
                                ),
                              ),
                              Icon(Icons.headset_mic,
                                  size: 30,
                                  color: Color(0xFF7B4DFF))
                            ],
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "How can we help you today?",
                            style: TextStyle(
                                color: Colors.black54),
                          ),
                          const SizedBox(height: 20),

                          /// SEARCH BAR
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius:
                                  BorderRadius.circular(30),
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.search),
                                hintText: "Search help topics...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          /// QUICK HELP
                          const Text(
                            "Quick Help Categories",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          const SizedBox(height: 15),

                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _categoryCard(Icons.person,
                                  "Account Issues"),
                              _categoryCard(Icons.book,
                                  "Reading &"),
                              _categoryCard(Icons.payment,
                                  "Payments & Premium"),
                              _categoryCard(Icons.edit,
                                  "Writer Dashboard Help"),
                            ],
                          ),

                          const SizedBox(height: 25),

                          /// FAQ
                          const Text(
                            "FAQS",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          const SizedBox(height: 10),

                          Column(
                            children: List.generate(
                                faqs.length,
                                (index) => _faqTile(
                                    index,
                                    faqs[index]["question"]!,
                                    faqs[index]["answer"]!)),
                          ),

                          const SizedBox(height: 25),

                          /// CONTACT SUPPORT
                          const Text(
                            "Contact Support",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          const SizedBox(height: 15),

                          _gradientButton(
                              "Chat with Support", chatWithSupport),
                          const SizedBox(height: 10),
                          _gradientButton("Email Us", emailSupport),

                          const SizedBox(height: 15),

                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFF7B4DFF)),
                              borderRadius:
                                  BorderRadius.circular(15),
                            ),
                            child: const Text(
                              "Support response time: < 1 hour",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// FOOTER
                          const Center(
                            child: Column(
                              children: [
                                Text("App Version 1.0.0"),
                                SizedBox(height: 5),
                                Text(
                                  "Privacy Policy • Terms of Service",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryCard(IconData icon, String title) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF7B4DFF),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Text(title,
                  style: const TextStyle(fontSize: 13)))
        ],
      ),
    );
  }

  Widget _faqTile(int index, String question, String answer) {
    final bool isOpen = expandedIndex == index;

    return GestureDetector(
      onTap: () => toggleFAQ(index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(question,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600)),
                ),
                Icon(isOpen
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down)
              ],
            ),
            if (isOpen) ...[
              const SizedBox(height: 10),
              Text(answer,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54))
            ]
          ],
        ),
      ),
    );
  }

  Widget _gradientButton(
      String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8F6BFF), Color(0xFF6A4DFF)],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(text,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}