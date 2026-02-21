import 'package:flutter/material.dart';

class ContinueReadingSlider extends StatelessWidget {
  const ContinueReadingSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8)
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20)),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Book Title",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      LinearProgressIndicator(
                        value: 0.6,
                        backgroundColor: Colors.black12,
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}