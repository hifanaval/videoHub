import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:videohub/constants/global_variables.dart';
import 'package:videohub/constants/string_class.dart';
import 'package:videohub/screens/home/home_screen.dart';
import 'package:videohub/screens/login_screen/login_screen.dart';
import 'package:videohub/screens/login_screen/model/login_response_model.dart';
import 'package:videohub/utils/api_urls.dart';
import 'package:videohub/utils/app_utils.dart';
import 'package:videohub/utils/shared_utils.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  String currencyCode = '+91';
  TextEditingController phoneNumber = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? phoneError;

  // Model classes for login response
  LoginResponseModel? loginResponseModel;

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // Update country code selection
  void updateCountryCode(String countryCode) {
    currencyCode = countryCode.replaceAll('+', '');
    clearPhoneError(); // Clear any existing errors when country code changes
    notifyListeners();
    debugPrint(
      'Country code updated to: $countryCode, currency: $currencyCode',
    );
  }

  // Clear phone error
  void clearPhoneError() {
    phoneError = null;
    notifyListeners();
  }

  // Set phone error
  void setPhoneError(String error) {
    phoneError = error;
    notifyListeners();
  }

  // Real-time validation as user types
  void validatePhoneNumberRealtime(String value) {
    if (value.isEmpty) {
      clearPhoneError();
      return;
    }

    // If the number is valid, clear any error
    if (value.length == 10 && RegExp(r'^[0-9]+$').hasMatch(value)) {
      clearPhoneError();
    }
  }

  // Validate phone number
  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      setPhoneError('Please enter your phone number');
      return 'Please enter your phone number';
    }
    if (value.length < 10) {
      setPhoneError('Please enter a valid 10-digit phone number');
      return 'Please enter a valid 10-digit phone number';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      setPhoneError('Phone number should contain only digits');
      return 'Phone number should contain only digits';
    }
    // If validation passes, clear any existing error
    clearPhoneError();
    return null;
  }

  // Handle login
  Future<bool> verifyLogin(BuildContext context) async {
    setLoading(true);
    notifyListeners();
    debugPrint('Entered verifyLogin function');

    try {
      // Create FormData for multipart request
      final params = FormData.fromMap({
        "country_code": currencyCode,
        "phone": phoneNumber.text,
      });
      debugPrint(
        'Requesting login with params: country_code=$currencyCode, phone=${phoneNumber.text}',
      );

      // Create dio instance
      final dio = Dio();
      final url = Uri.parse(ApiUrls.verifyMobile()).toString();

      // Make multipart request
      final Response response = await dio.post(
        url,
        data: params,
        options: Options(
          headers: {
            // Remove Content-Type header to let Dio handle multipart automatically
            "Accept": "application/json",
          },
        ),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 202) {
        if (response.data["status"] == true) {
          debugPrint('Login successful, processing response...');
          afterLoginMethod(
            jsonEncode(response.data), // Convert Map to JSON string
            context,
          );
          return true;
        } else {
          setLoading(false);
          debugPrint('Login failed: ${response.data["message"]}');
          setPhoneError(response.data["message"]?.toString() ?? 'Login failed');
          return false;
        }
      } else {
        debugPrint('Login request failed with status: ${response.statusCode}');
        setLoading(false);
        setPhoneError('Server error. Please try again.');
        return false;
      }
    } catch (e) {
      debugPrint('Error in verifyLogin: $e');
      setLoading(false);
      setPhoneError('Something went wrong. Please try again.');
      return false;
    } finally {
      setLoading(false);
    }
  }

  afterLoginMethod(String value, BuildContext context) async {
    debugPrint('-----------------------Login Response: ${value.toString()}');
    try {
      loginResponseModel = loginResponseModelFromJson(value);

      if (loginResponseModel!.status == true) {
        debugPrint('Login successful, saving tokens...');

        // Save access token
        final receivedAccessToken = loginResponseModel!.token?.access ?? "";
        final refreshToken = loginResponseModel!.token?.refresh ?? "";

        if (receivedAccessToken.isNotEmpty) {
          await SharedUtils.setString(StringClass.token, receivedAccessToken);
          await SharedUtils.setString("refresh_token", refreshToken);

          // Set global access token
          accessToken = receivedAccessToken;

          debugPrint('Access token saved: ${accessToken.substring(0, 20)}...');
          debugPrint(
            'Refresh token saved: ${refreshToken.substring(0, 20)}...',
          );

          // Navigate to home screen after successful login
          await Future.delayed(const Duration(seconds: 1), () {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              Future.microtask(() {
                AppUtils.showToast(
                  context,
                  'Welcome',
                  'Login successful!',
                  true,
                );
              });
            });
          });
        } else {
          debugPrint('No access token received');
          setPhoneError('Invalid response from server');
        }
      } else {
        debugPrint('Login failed: status is false');
        setPhoneError('Login failed. Please try again.');
      }
    } catch (e) {
      setLoading(false);
      debugPrint(
        '-----------------------Login processing error: ${e.toString()}',
      );
      setPhoneError('Failed to process login response. Please try again.');
    } finally {
      setLoading(false);
    }
  }

  void handleLogout(BuildContext context) async {
    try {
      // Clear stored tokens
      await SharedUtils.setString(StringClass.token, '');
      await SharedUtils.setString('refresh_token', '');

      // Clear global access token
      accessToken = '';

      debugPrint('User logged out successfully');

      // Navigate to login screen
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }
}
