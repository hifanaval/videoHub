import 'package:flutter/material.dart';
import 'package:videohub/constants/color_class.dart';
import 'package:videohub/constants/textstyle_class.dart';
import 'package:videohub/screens/home/model/category_model.dart';

class CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? ColorClass.red.withValues(alpha: 0.4)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected
                    ? ColorClass.red.withValues(alpha: 0.2)
                    : Colors.grey.shade700,
            width: 1,
          ),
        ),
        child: Text(
          category.title ?? "",
          style: TextStyleClass.h5(
            color: isSelected ? ColorClass.primaryColor : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}
