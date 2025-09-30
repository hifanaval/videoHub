
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:videohub/constants/color_class.dart';

class DottedBorderContainer extends StatelessWidget {
  final Widget child;
  final double height;
  final VoidCallback? onTap;

  const DottedBorderContainer({
    super.key,
    required this.child,
    this.height = 200,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        color: ColorClass.primaryColor,
        strokeWidth: 2,
        dashPattern: const [8, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: ColorClass.backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
        ),
      ),
    );
  }
}
