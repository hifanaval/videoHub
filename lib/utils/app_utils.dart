import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';
import 'package:videohub/constants/color_class.dart';
import 'package:videohub/constants/sized_box.dart';
import 'package:videohub/constants/textstyle_class.dart';

class AppUtils {
  ///To check internet connection
  static Future<bool> hasInternet() async {
    try {
      final url = Uri.parse('https://www.google.com');
      final response = await http.get(url);
      return response.statusCode == 200;
    } catch (e) {
      return false; // Request failed, so no internet connection
    }
  }

  /// Navigate to a new screen/widget with automatic platform detection
  static void navigateTo(BuildContext context, Widget widget) {
    if (Platform.isIOS) {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => widget));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
    }
  }

  static showToast(
    BuildContext context,
    String labelText,
    String message,
    bool isSuccess,
  ) {
    toastification.show(
      context: context,
      autoCloseDuration: const Duration(seconds: 4),
      title: Text(
        labelText,
        style: TextStyleClass.h2(
          color: isSuccess ? const Color(0xFF4CAF50) : ColorClass.red,
        ),
      ),
      description: Text(
        message,
        style: TextStyleClass.h5(
          color: isSuccess ? const Color(0xFF4CAF50) : ColorClass.red,
        ),
      ),
      alignment: Alignment.bottomCenter,
      animationDuration: const Duration(milliseconds: 300),
      icon: Icon(
        isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
        color: isSuccess ? const Color(0xFF4CAF50) : ColorClass.red,
        size: 30,
      ),
      showIcon: true,
      primaryColor: isSuccess ? const Color(0xFF4CAF50) : ColorClass.red,
      backgroundColor: ColorClass.secondaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      borderRadius: BorderRadius.circular(4),

      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: false,
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      style: ToastificationStyle.minimal,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => debugPrint('Toast ${toastItem.id} tapped'),
        onCloseButtonTap:
            (toastItem) =>
                debugPrint('Toast ${toastItem.id} close button tapped'),
        onAutoCompleteCompleted:
            (toastItem) =>
                debugPrint('Toast ${toastItem.id} auto complete completed'),
        onDismissed:
            (toastItem) => debugPrint('Toast ${toastItem.id} dismissed'),
      ),
    );
  }

  /// Show logout confirmation dialog
  static void showLogoutConfirmation(
    BuildContext context,
    VoidCallback onLogoutConfirm,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorClass.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: ColorClass.primaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                color: ColorClass.red,
                size: 26,
              ),
              kWidth(12),
              Text(
                'Logout',
                style: TextStyleClass.h1(color: ColorClass.primaryColor),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to logout?',
                style: TextStyleClass.h4(color: ColorClass.secondaryColor),
              ),
              kHeight(8),
              Text(
                'You will need to sign in again to access your account.',
                style: TextStyleClass.bodyRegular(color: ColorClass.tertiaryColor),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: ColorClass.tertiaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyleClass.h5(color: ColorClass.secondaryColor),
                    ),
                  ),
                ),
                kWidth(12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onLogoutConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorClass.red,
                      foregroundColor: ColorClass.primaryColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadowColor: ColorClass.red.withOpacity(0.3),
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyleClass.h5(color: ColorClass.primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }


  static String timeAgoFull(String? dateTime) {
  if (dateTime == null || dateTime.isEmpty) return '';

  try {
    final date = DateTime.parse(dateTime);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'Just now';
    
    if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return '$m ${m == 1 ? "minute" : "minutes"} ago';
    }
    
    if (diff.inHours < 24) {
      final h = diff.inHours;
      return '$h ${h == 1 ? "hour" : "hours"} ago';
    }
    
    if (diff.inDays < 7) {
      final d = diff.inDays;
      return '$d ${d == 1 ? "day" : "days"} ago';
    }
    
    if (diff.inDays < 30) {
      final w = (diff.inDays / 7).floor();
      return '$w ${w == 1 ? "week" : "weeks"} ago';
    }
    
    if (diff.inDays < 365) {
      final m = (diff.inDays / 30).floor();
      return '$m ${m == 1 ? "month" : "months"} ago';
    }
    
    final y = (diff.inDays / 365).floor();
    return '$y ${y == 1 ? "year" : "years"} ago';
  } catch (e) {
    return '';
  }
}

}
