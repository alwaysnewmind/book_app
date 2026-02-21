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
          content: Text("Review Submitted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E2FF),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7B4DFF),
        child: const Icon(Icons.mic),
        onPressed: () {},
      ),
      bottomNavigationBar: _bottomNav(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE9E2FF),
              Color(0xFFCBB6FF)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(35),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding:
                        const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.9),
                      borderRadius:
                          BorderRadius.circular(
                              35),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [

                          /// BOOK HEADER
                          Row(
                            children: [
                              Container(
                                height: 70,
                                width: 50,
                                decoration:
                                    BoxDecoration(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              10),
                                  color: Colors
                                      .purple
                                      .shade100,
                                ),
                              ),
                              const SizedBox(
                                  width: 15),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Text(
                                      "Project Hail Mary",
                                      style: TextStyle(
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          fontSize:
                                              18),
                                    ),
                                    Text(
                                      "Andy Weir",
                                      style: TextStyle(
                                          color: Colors
                                              .black54),
                                    )
                                  ],
                                ),
                              ),
                              const Icon(Icons.more_vert)
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// OVERALL RATING
                          const Text(
                            "Overall Rating",
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text(
                                "4.8",
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight:
                                        FontWeight
                                            .bold),
                              ),
                              const SizedBox(
                                  width: 10),
                              Row(
                                children: List.generate(
                                    5,
                                    (index) =>
                                        const Icon(
                                          Icons.star,
                                          color: Colors
                                              .amber,
                                        )),
                              ),
                              const SizedBox(
                                  width: 10),
                              const Text(
                                  "2,439 Reviews"),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// RATING BREAKDOWN
                          const Text(
                            "Rating Breakdown",
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.bold),
                          ),
                          const SizedBox(height: 10),

                          Column(
                            children: List.generate(
                                5,
                                (index) =>
                                    _ratingBar(
                                        5 - index,
                                        ratingPercentages[
                                            index])),
                          ),

                          const SizedBox(height: 25),

                          /// WRITE REVIEW
                          Container(
                            padding:
                                const EdgeInsets
                                    .all(15),
                            decoration:
                                BoxDecoration(
                              color: Colors.grey
                                  .shade100,
                              borderRadius:
                                  BorderRadius
                                      .circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                const Text(
                                  "Write Your Review",
                                  style: TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .bold),
                                ),
                                const SizedBox(
                                    height: 10),
                                Row(
                                  children:
                                      List.generate(
                                          5,
                                          (index) =>
                                              GestureDetector(
                                                onTap:
                                                    () {
                                                  setState(
                                                      () {
                                                    selectedStars =
                                                        index +
                                                            1;
                                                  });
                                                },
                                                child:
                                                    Icon(
                                                  Icons
                                                      .star,
                                                  color: index <
                                                          selectedStars
                                                      ? Colors.amber
                                                      : Colors.grey,
                                                ),
                                              )),
                                ),
                                const SizedBox(
                                    height: 10),
                                TextField(
                                  controller:
                                      reviewController,
                                  decoration:
                                      const InputDecoration(
                                    hintText:
                                        "Share your thoughts...",
                                    border:
                                        OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius
                                              .all(
                                                  Radius.circular(
                                                      15)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    height: 10),
                                ElevatedButton(
                                  style:
                                      ElevatedButton
                                          .styleFrom(
                                    backgroundColor:
                                        const Color(
                                            0xFF7B4DFF),
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                                  30),
                                    ),
                                  ),
                                  onPressed:
                                      submitReview,
                                  child:
                                      const Text(
                                          "Submit"),
                                )
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            "User Reviews List",
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.bold),
                          ),
                          const SizedBox(height: 10),

                          Column(
                            children: List.generate(
                                reviews.length,
                                (index) =>
                                    _reviewCard(
                                        index)),
                          ),

                          const SizedBox(
                              height: 80),
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

  Widget _ratingBar(
      int star, double percent) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
              vertical: 4),
      child: Row(
        children: [
          SizedBox(
              width: 20,
              child: Text("$star")),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration:
                      BoxDecoration(
                    color: Colors.grey
                        .shade300,
                    borderRadius:
                        BorderRadius
                            .circular(10),
                  ),
                ),
                Container(
                  height: 8,
                  width: MediaQuery.of(context)
                          .size
                          .width *
                      percent *
                      0.6,
                  decoration:
                      BoxDecoration(
                    gradient:
                        const LinearGradient(
                      colors: [
                        Color(0xFF8F6BFF),
                        Color(0xFF6A4DFF)
                      ],
                    ),
                    borderRadius:
                        BorderRadius
                            .circular(10),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text("${(percent * 100).toInt()}%"),
        ],
      ),
    );
  }

  Widget _reviewCard(int index) {
    final review = reviews[index];

    return Container(
      margin:
          const EdgeInsets.symmetric(
              vertical: 8),
      padding:
          const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius:
            BorderRadius.circular(20),
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
              Text(review["name"],
                  style: const TextStyle(
                      fontWeight:
                          FontWeight.bold)),
              TextButton(
                onPressed: () =>
                    toggleLike(index),
                child: Text(
                    review["liked"]
                        ? "Liked"
                        : "Like"),
              )
            ],
          ),
          Row(
            children: List.generate(
                review["rating"],
                (i) => const Icon(
                      Icons.star,
                      color: Colors
                          .amber,
                      size: 16,
                    )),
          ),
          const SizedBox(height: 5),
          Text(review["review"]),
          const SizedBox(height: 5),
          Text(
              "👍 ${review["likes"]} likes"),
        ],
      ),
    );
  }

  Widget _bottomNav() {
    return BottomNavigationBar(
      selectedItemColor:
          const Color(0xFF7B4DFF),
      unselectedItemColor:
          Colors.grey,
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