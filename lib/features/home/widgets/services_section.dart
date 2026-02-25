import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../shared/widgets/animated_tap_wrapper.dart';
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
              color:const Color(0xFF2F2B4D),
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
                    childAspectRatio: 1.05, // Compact layout
                  ),
                  itemBuilder: (context, index) {
                    final service = services[index];

                    return AnimatedTapWrapper(
                      onTap: () => Navigator.pushNamed(context, service.route),
                      borderRadius: BorderRadius.circular(14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          /// 🔹 Icon Circle
                           Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFFD600), // Gold Ring
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF2B3250), // Inner Purple
                          ),
                          child: Icon(
                            service.icon,
                            size: 28,
                            color: Color(0xFFFFD600),
                            ),
                          ),
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