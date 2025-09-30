import 'package:flutter/material.dart';
import 'package:videohub/constants/color_class.dart';
import 'package:videohub/components/base_shimmer.dart';

class CategoryListShimmer extends StatelessWidget {
  const CategoryListShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      itemCount: 5, // Show 5 shimmer items
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: ColorClass.primaryColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Shimmer for category icon
                BaseShimmer(
                  width: 15,
                  height: 15,
                  borderRadius: 47,
                ),
                const SizedBox(width: 8),
                // Shimmer for category text
                BaseShimmer(
                  width: 80 + (index * 10), // Varying widths for realistic effect
                  height: 16,
                  borderRadius: 8,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}