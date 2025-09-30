import 'package:flutter/material.dart';
import 'package:videohub/constants/color_class.dart';
import 'package:videohub/constants/textstyle_class.dart';

class CountryDropdown extends StatelessWidget {
  final String selectedCountryCode;
  final void Function(String) onChanged;
  final List<String> countryCodes;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final IconData? icon;

  const CountryDropdown({
    super.key,
    required this.selectedCountryCode,
    required this.onChanged,
    this.countryCodes = const ['+91', '+1', '+44', '+61', '+971'],
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 12.0,
    this.padding,
    this.textStyle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        // color: backgroundColor ?? Colors.grey.shade900,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: ColorClass.primaryColor.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          padding: EdgeInsets.zero,
          value: selectedCountryCode,
          isDense: true,
          // dropdownColor: backgroundColor ?? Colors.grey.shade900,
          icon: Icon(
            icon ?? Icons.arrow_drop_down_rounded,
            color: Colors.white,
            // size: 24,
          ),
          style: TextStyleClass.h2(),
          items:
              countryCodes.map((code) {
                return DropdownMenuItem(value: code, child: Text(code));
              }).toList(),
          onChanged: (value) {
            if (value != null) {
              debugPrint('CountryDropdown: Country code changed to: $value');
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}
