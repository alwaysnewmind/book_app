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
      backgroundColor: const Color(0xFF1F1533),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1F1533),
              Color(0xFF2A1E47),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF251A3F).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFF3A2D5C)),
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
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            Icon(
                              Icons.headset_mic,
                              size: 28,
                              color: Color(0xFFF5C84C),
                            )
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "How can we help you today?",
                          style: TextStyle(
                            color: Color(0xFFCFC8E8),
                          ),
                        ),
                        const SizedBox(height: 25),

                        /// SEARCH BAR
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: const Color(0xFF251A3F),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: const Color(0xFF3A2D5C)),
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(
                                color: Color(0xFFFFFFFF)),
                            decoration: const InputDecoration(
                              icon: Icon(Icons.search,
                                  color: Color(0xFFCFC8E8)),
                              hintText: "Search help topics...",
                              hintStyle: TextStyle(
                                  color: Color(0xFF9F96C8)),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// QUICK HELP
                        const Text(
                          "Quick Help Categories",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        const SizedBox(height: 18),

                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
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

                        const SizedBox(height: 30),

                        /// FAQ
                        const Text(
                          "FAQs",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        const SizedBox(height: 15),

                        Column(
                          children: List.generate(
                            faqs.length,
                            (index) => _faqTile(
                              index,
                              faqs[index]["question"]!,
                              faqs[index]["answer"]!,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// CONTACT SUPPORT
                        const Text(
                          "Contact Support",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        const SizedBox(height: 18),

                        _goldButton(
                            "Chat with Support", chatWithSupport),
                        const SizedBox(height: 14),
                        _goldButton("Email Us", emailSupport),

                        const SizedBox(height: 20),

                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF251A3F),
                            borderRadius:
                                BorderRadius.circular(18),
                            border: Border.all(
                                color: const Color(0xFF3A2D5C)),
                          ),
                          child: const Text(
                            "Support response time: < 1 hour",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9F96C8),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// FOOTER
                        const Center(
                          child: Column(
                            children: [
                              Text(
                                "App Version 1.0.0",
                                style: TextStyle(
                                    color: Color(0xFF9F96C8)),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Privacy Policy • Terms of Service",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF9F96C8),
                                ),
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
    );
  }

  Widget _categoryCard(IconData icon, String title) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFF5C84C),
            child: Icon(icon,
                color: const Color(0xFF1F1533), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFFCFC8E8),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _faqTile(int index, String question, String answer) {
    final bool isOpen = expandedIndex == index;

    return GestureDetector(
      onTap: () => toggleFAQ(index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF251A3F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF3A2D5C)),
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
                  child: Text(
                    question,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                Icon(
                  isOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xFFF5C84C),
                )
              ],
            ),
            if (isOpen) ...[
              const SizedBox(height: 12),
              Text(
                answer,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFFCFC8E8),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _goldButton(
      String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5C84C),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD76A)
                  .withOpacity(0.3),
              blurRadius: 18,
              spreadRadius: 1,
            )
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF1F1533),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}