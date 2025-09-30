import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:videohub/constants/color_class.dart';
import 'package:videohub/constants/textstyle_class.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.maxLength,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 12.0,
    this.contentPadding,
    this.textStyle,
    this.hintStyle,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            // color: backgroundColor ?? Colors.grey.shade900,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: errorText != null 
                  ? Colors.red.withOpacity(0.8)
                  : ColorClass.primaryColor.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: TextFormField(
                  controller: controller,
                  style: TextStyleClass.buttonRegular(),
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  maxLength: maxLength,
                  obscureText: obscureText,
                  readOnly: readOnly,
                  onChanged: onChanged,
                  onTap: onTap,
                  validator: (value) {
                    // Call the validator but don't show the result inside the field
                    validator!(value);
                    return null; // Always return null to hide internal error text
                  },
                  decoration: InputDecoration(
                    hintText: hintText,
                    contentPadding:
                        contentPadding ??
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                    hintStyle: TextStyleClass.hintText(),
                    border: InputBorder.none,
                    isDense: true,
                    prefixIcon: prefixIcon,
                    suffixIcon: suffixIcon,
                    counterText: '', // Hide character counter
                    errorStyle: const TextStyle(
                      height: 0,
                      fontSize: 0,
                      color: Colors.transparent,
                    ), // Completely hide default error text
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  ),
                )
            
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
