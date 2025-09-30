import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:videohub/constants/color_class.dart';

class BaseShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const BaseShimmer({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorClass.tertiaryColor.withValues(alpha: 0.1),
      highlightColor: ColorClass.tertiaryColor.withValues(alpha: 0.3),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
