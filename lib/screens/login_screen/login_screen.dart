import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:videohub/components/country_dropdown.dart';
import 'package:videohub/components/custom_text_field.dart';
import 'package:videohub/constants/color_class.dart';
import 'package:videohub/constants/textstyle_class.dart';
import 'package:videohub/screens/login_screen/provider/auth_provider.dart';

// Login Screen
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          backgroundColor: ColorClass.backgroundColor,
          body: SafeArea(
            child: Form(
              key: authProvider.formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Enter Your\nMobile Number',
                      style: TextStyleClass.h1(),
                    ),
                    const SizedBox(height: 11),
                    Text(
                      'Lorem ipsum dolor sit amet consectetur. Porta at id hac vitae. Et tortor at vehicula euismod mi viverra.',
                      style: TextStyleClass.bodyRegular(
                        color: ColorClass.quaternaryColor,
                      ),
                    ),
                    const SizedBox(height: 36),
                    Row(
                      children: [
                        // Country Code Dropdown
                        CountryDropdown(
                          selectedCountryCode: authProvider.selectedCountryCode,
                          onChanged: (value) {
                            debugPrint('Country code changed to: $value');
                            authProvider.updateCountryCode(value);
                          },
                          errorText: authProvider.phoneError,
                        ),
                        const SizedBox(width: 12),
                        // Phone Number Input
                        Expanded(
                          child: CustomTextField(
                            controller: authProvider.phoneNumber,
                            hintText: 'Enter Mobile Number',
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: authProvider.validatePhoneNumber,
                            errorText: authProvider.phoneError,
                            onChanged: (value) {
                              debugPrint('Phone number changed: $value');
                              // Real-time validation to clear errors when input becomes valid
                              authProvider.validatePhoneNumberRealtime(value);
                            },
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Continue Button
                    Center(
                      child: InkWell(
                        onTap:
                            authProvider.isLoading
                                ? null
                                : () async {
                                  debugPrint('Login button pressed');
                                  // Validate form before proceeding
                                  if (authProvider.formKey.currentState!
                                      .validate()) {
                                    debugPrint(
                                      'Form is valid, proceeding with login',
                                    );
                                    await authProvider.verifyLogin(context);
                                  } else {
                                    debugPrint('Form validation failed');
                                  }
                                },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 14,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(47),
                            border: Border.all(
                              color: ColorClass.primaryColor.withValues(
                                alpha: 0.28,
                              ),
                            ),
                          ),
                          child:
                              authProvider.isLoading
                                  ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CupertinoActivityIndicator(
                                      color: Colors.white,
                                      radius: 10,
                                    ),
                                  )
                                  : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Continue',
                                        style: TextStyleClass.buttonRegular(),
                                      ),
                                      SizedBox(width: 8),
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor: ColorClass.red,
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 20,
                                          color: ColorClass.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                        ),
                      ),
                    ),
                    // const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
