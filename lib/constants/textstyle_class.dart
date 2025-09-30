import 'package:flutter/material.dart';
import 'package:videohub/constants/color_class.dart';

class TextStyleClass {
  static const String primaryFont = 'Montserrat';
  static const double lineHeight = 1.5;

  // ==================== HEADING STYLES ====================

  
  /// Heading 1 - 23px, Medium (500)
  static TextStyle h1({Color? color}) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: 23,
      fontWeight: FontWeight.w500,
      color: color ?? ColorClass.primaryColor,
      height: lineHeight,
    );
  }

  /// Heading 2 - 16px, SemiBold (600)
  static TextStyle h2({Color? color}) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color ?? ColorClass.primaryColor,
      height: lineHeight,
    );
  }

  /// Heading 3 - 16px, Medium (500)
  static TextStyle h3({Color? color}) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: color ?? ColorClass.primaryColor,
      height: lineHeight,
    );
  }

  /// Heading 4 - 15px, Regular (400)
  static TextStyle h4({Color? color}) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: color ?? ColorClass.primaryColor,
      height: lineHeight,
    );
  }

  /// Heading 5 - 14px, Medium (500)
  static TextStyle h5({Color? color}) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color ?? ColorClass.primaryColor,
      height: lineHeight,
    );
  }

  // ==================== BODY STYLES ====================

  /// Body Medium - 13px, Medium (500)
  static TextStyle bodyMedium({Color? color}) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: color ?? ColorClass.primaryColor,
      height: lineHeight,
    );
  }

  /// Body Regular - 12px, Regular (400)
  static TextStyle bodyRegular({Color? color}) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: color ?? ColorClass.primaryColor,
      height: lineHeight,
    );
  }

  /// Body Light - 12.5px, Light (300)
  static TextStyle bodyLight({Color? color}) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: 12.5,
      fontWeight: FontWeight.w300,
      color: color ?? ColorClass.primaryColor,
      height: lineHeight,
    );
  }

  /// Body Light Small - 11px, Light (300)
  static TextStyle bodyLightSmall({Color? color}) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: 11,
      fontWeight: FontWeight.w300,
      color: color ?? ColorClass.primaryColor,
      height: lineHeight,
    );
  }

  /// Body Medium Small - 10px, Medium (500)
  static TextStyle bodyMediumSmall({Color? color}) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: color ?? ColorClass.primaryColor,
      height: lineHeight,
    );
  }

  // ==================== SPECIAL PURPOSE STYLES ====================

  /// Button Regular - 14px, Regular (400)
  static TextStyle buttonRegular({Color? color}) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color ?? ColorClass.primaryColor,
      height: lineHeight,
    );
  }

  /// Hint Text - 13px, Regular (400)
  static TextStyle hintText({Color? color}) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: color ?? ColorClass.tertiaryColor,
      height: lineHeight,
    );
  }

  /// Caption - 10px, Regular (400)
  static TextStyle caption({Color? color}) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: color ?? ColorClass.primaryColor,
      height: lineHeight,
    );
  }
}
