import 'dart:ui';
import 'package:flutter/material.dart';

class ReviewDashboardScreen extends StatefulWidget {
  const ReviewDashboardScreen({super.key});

  @override
  State<ReviewDashboardScreen> createState() =>
      _ReviewDashboardScreenState();
}

class _ReviewDashboardScreenState
    extends State<ReviewDashboardScreen> {

  int selectedStars = 4;
  final TextEditingController reviewController =
      TextEditingController();

  List<double> ratingPercentages = [0.75, 0.15, 0.05, 0.03, 0.02];

  List<Map<String, dynamic>> reviews = [
    {
      "name": "Alexia R",
      "rating": 4,
      "review":
          "Amazing book with deep emotional storytelling.",
      "likes": 12,
      "liked": false,
    },
    {
      "name": "Alexia R",
      "rating": 5,
      "review":
          "One of the best sci-fi novels I’ve ever read.",
      "likes": 20,
      "liked": false,
    },
  ];

  void toggleLike(int index) {
    setState(() {
      reviews[index]["liked"] =
          !reviews[index]["liked"];
      reviews[index]["liked"]
          ? reviews[index]["likes"]++
          : reviews[index]["likes"]--;
    });
  }

  void submitReview() {
    if (reviewController.text.isEmpty) return;

    setState(() {
      reviews.insert(0, {
        "name": "You",
        "rating": selectedStars,
        "review": reviewController.text,
        "likes": 0,
        "liked": false,
      });
      reviewController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF251A3F),
        content: Text(
          "Review Submitted",
          style: TextStyle(color: Color(0xFFF5C84C)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1533),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD76A)
                  .withOpacity(0.3),
              blurRadius: 18,
              spreadRadius: 1,
            )
          ],
        ),
        child: FloatingActionButton(
          backgroundColor:
              const Color(0xFFF5C84C),
          child: const Icon(Icons.mic,
              color: Color(0xFF1F1533)),
          onPressed: () {},
        ),
      ),
      bottomNavigationBar: _bottomNav(),
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  /// HEADER
                  Container(
                    padding:
                        const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFF251A3F),
                      borderRadius:
                          BorderRadius.circular(
                              26),
                      border: Border.all(
                          color: const Color(
                              0xFF3A2D5C)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 80,
                          width: 60,
                          decoration:
                              BoxDecoration(
                            borderRadius:
                                BorderRadius
                                    .circular(
                                        18),
                            gradient:
                                const LinearGradient(
                              colors: [
                                Color(
                                    0xFF2A1E47),
                                Color(
                                    0xFF140F26)
                              ],
                              begin: Alignment
                                  .topLeft,
                              end: Alignment
                                  .bottomRight,
                            ),
                          ),
                        ),
                        const SizedBox(
                            width: 18),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                "Project Hail Mary",
                                style: TextStyle(
                                    color: Colors
                                        .white,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    fontSize:
                                        18),
                              ),
                              SizedBox(
                                  height: 4),
                              Text(
                                "Andy Weir",
                                style: TextStyle(
                                    color: Color(
                                        0xFFCFC8E8)),
                              )
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.more_vert,
                          color: Color(
                              0xFFF5C84C),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// OVERALL RATING
                  const Text(
                    "Overall Rating",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Text(
                        "4.8",
                        style: TextStyle(
                          fontSize: 46,
                          fontWeight:
                              FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                          width: 12),
                      Row(
                        children: List.generate(
                            5,
                            (index) =>
                                const Icon(
                                  Icons.star,
                                  color: Color(
                                      0xFFF5C84C),
                                )),
                      ),
                      const SizedBox(
                          width: 10),
                      const Text(
                        "2,439 Reviews",
                        style: TextStyle(
                          color: Color(
                              0xFF9F96C8),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// BREAKDOWN
                  const Text(
                    "Rating Breakdown",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold),
                  ),
                  const SizedBox(height: 14),

                  Column(
                    children: List.generate(
                        5,
                        (index) =>
                            _ratingBar(
                                5 - index,
                                ratingPercentages[
                                    index])),
                  ),

                  const SizedBox(height: 32),

                  /// WRITE REVIEW CARD
                  _writeReviewCard(),

                  const SizedBox(height: 28),

                  const Text(
                    "User Reviews",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Column(
                    children: List.generate(
                        reviews.length,
                        (index) =>
                            _reviewCard(
                                index)),
                  ),

                  const SizedBox(
                      height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _writeReviewCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius:
            BorderRadius.circular(28),
        border: Border.all(
            color: const Color(
                0xFF3A2D5C)),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            "Write Your Review",
            style: TextStyle(
                color: Colors.white,
                fontWeight:
                    FontWeight.bold),
          ),
          const SizedBox(height: 14),
          Row(
            children: List.generate(
                5,
                (index) =>
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedStars =
                              index + 1;
                        });
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets
                                .only(
                                    right: 6),
                        child: Icon(
                          Icons.star,
                          color: index <
                                  selectedStars
                              ? const Color(
                                  0xFFF5C84C)
                              : const Color(
                                  0xFF3A2D5C),
                        ),
                      ),
                    )),
          ),
          const SizedBox(height: 14),
          TextField(
            controller:
                reviewController,
            style: const TextStyle(
                color: Colors.white),
            decoration:
                InputDecoration(
              hintText:
                  "Share your thoughts...",
              hintStyle:
                  const TextStyle(
                      color: Color(
                          0xFF9F96C8)),
              filled: true,
              fillColor:
                  const Color(
                      0xFF1F1533),
              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius
                        .circular(
                            20),
                borderSide:
                    const BorderSide(
                        color: Color(
                            0xFF3A2D5C)),
              ),
              enabledBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius
                        .circular(
                            20),
                borderSide:
                    const BorderSide(
                        color: Color(
                            0xFF3A2D5C)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius
                      .circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                          0xFFFFD76A)
                      .withOpacity(
                          0.3),
                  blurRadius: 20,
                )
              ],
            ),
            child: ElevatedButton(
              style:
                  ElevatedButton
                      .styleFrom(
                backgroundColor:
                    const Color(
                        0xFFF5C84C),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                              30),
                ),
                padding:
                    const EdgeInsets
                        .symmetric(
                            vertical:
                                14),
              ),
              onPressed:
                  submitReview,
              child:
                  const Text(
                "Submit",
                style: TextStyle(
                    color: Color(
                        0xFF1F1533),
                    fontWeight:
                        FontWeight
                            .bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _reviewCard(int index) {
    final review = reviews[index];

    return Container(
      margin:
          const EdgeInsets.symmetric(
              vertical: 10),
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius:
            BorderRadius.circular(24),
        border: Border.all(
            color: const Color(
                0xFF3A2D5C)),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
            children: [
              Text(
                review["name"],
                style:
                    const TextStyle(
                        color: Colors
                            .white,
                        fontWeight:
                            FontWeight
                                .bold),
              ),
              TextButton(
                onPressed: () =>
                    toggleLike(
                        index),
                child: Text(
                  review["liked"]
                      ? "Liked"
                      : "Like",
                  style:
                      const TextStyle(
                          color: Color(
                              0xFFF5C84C)),
                ),
              )
            ],
          ),
          Row(
            children: List.generate(
                review["rating"],
                (i) =>
                    const Icon(
                      Icons.star,
                      color: Color(
                          0xFFF5C84C),
                      size: 16,
                    )),
          ),
          const SizedBox(height: 8),
          Text(
            review["review"],
            style:
                const TextStyle(
                    color: Color(
                        0xFFCFC8E8)),
          ),
          const SizedBox(height: 8),
          Text(
            "👍 ${review["likes"]} likes",
            style:
                const TextStyle(
                    color: Color(
                        0xFF9F96C8)),
          ),
        ],
      ),
    );
  }

  Widget _ratingBar(
      int star, double percent) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
              vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            child: Text(
              "$star",
              style:
                  const TextStyle(
                      color: Color(
                          0xFFCFC8E8)),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration:
                      BoxDecoration(
                    color: const Color(
                        0xFF3A2D5C),
                    borderRadius:
                        BorderRadius
                            .circular(
                                10),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor:
                      percent,
                  child: Container(
                    height: 8,
                    decoration:
                        BoxDecoration(
                      gradient:
                          const LinearGradient(
                        colors: [
                          Color(
                              0xFFF5C84C),
                          Color(
                              0xFFE6B93E),
                        ],
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(
                                  10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "${(percent * 100).toInt()}%",
            style:
                const TextStyle(
                    color: Color(
                        0xFF9F96C8)),
          ),
        ],
      ),
    );
  }

  Widget _bottomNav() {
    return BottomNavigationBar(
      backgroundColor:
          const Color(0xFF251A3F),
      selectedItemColor:
          const Color(0xFFF5C84C),
      unselectedItemColor:
          const Color(0xFF9F96C8),
      type:
          BottomNavigationBarType
              .fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Discover"),
        BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Library"),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile"),
      ],
    );
  }
}