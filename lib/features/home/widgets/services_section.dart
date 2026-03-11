import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:book_app/features/home/widgets/home_services.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: const Color(0xFF2F2B4D),
              border: Border.all(
                color: const Color(0xFF3A3A5A),
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
                    color: Color(0xFFE2E2E5),
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 Services Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: services.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 18,
                    childAspectRatio: 0.60, // ✅ FIXED (prevents overflow)
                  ),
                  itemBuilder: (context, index) {
                    final service = services[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () =>
                          Navigator.pushNamed(context, service.route),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          /// 🔹 Icon Circle
                          Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFFFD600),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                height: 44,
                                width: 44,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF2B3250),
                                ),
                                child: Icon(
                                  service.icon,
                                  size: 26,
                                  color: const Color(0xFFFFD600),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// 🔹 Title
                          Text(
                            service.title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFE2E2E5),
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






