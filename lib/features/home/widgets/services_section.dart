import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../shared/widgets/data/home_services.dart';

class ServicesSection extends StatelessWidget {
  final String title;
  final List<HomeService> services;
  final int crossAxisCount;

  const ServicesSection({
    Key? key,
    required this.title,
    required this.services,
    this.crossAxisCount = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.white.withOpacity(0.14),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔹 Section Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F0322),
                  ),
                ),

                const SizedBox(height: 14),

                /// 🔹 Services Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: services.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1, // Compact layout
                  ),
                  itemBuilder: (context, index) {
                    final service = services[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () =>
                          Navigator.pushNamed(context, service.route),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          /// 🔹 Icon Circle
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color.fromARGB(255, 47, 47, 48).withOpacity(0.12),
                            ),
                            child: Icon(
                              service.icon,
                              size: 30, // Balanced size
                              color: Colors.deepPurple,
                            ),
                          ),

                          const SizedBox(height: 6),

                          /// 🔹 Title
                          Text(
                            service.title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F0322),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}