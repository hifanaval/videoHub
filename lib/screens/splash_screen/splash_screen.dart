import 'package:flutter/material.dart';
import 'package:videohub/constants/color_class.dart';
import 'package:videohub/constants/global_variables.dart';
import 'package:videohub/constants/string_class.dart';
import 'package:videohub/constants/textstyle_class.dart';
import 'package:videohub/screens/home/home_screen.dart';
import 'package:videohub/screens/login_screen/login_screen.dart';
import 'package:videohub/utils/shared_utils.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // Check for stored token and navigate accordingly
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    try {
      // Wait for splash animation to complete
      await Future.delayed(const Duration(seconds: 2));
      
      // Check if access token exists in SharedPreferences
      final storedToken = await SharedUtils.getString(StringClass.token);
      debugPrint('Stored token check: ${storedToken?.isNotEmpty ?? false}');
      
      if (mounted) {
        if (storedToken != null && storedToken.isNotEmpty) {
          // Token exists, navigate to home screen
          debugPrint('Access token found, navigating to home screen');
          accessToken = storedToken; // Update global variable
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        } else {
          // No token, navigate to login screen
          debugPrint('No access token found, navigating to login screen');
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error checking auth status: $e');
      // On error, navigate to login screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorClass.backgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade600, Colors.red.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: ColorClass.red,
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Text('Video Hub', style: TextStyleClass.h1()),
                const SizedBox(height: 10),
                Text(
                  'Share Your Moments',
                  style: TextStyleClass.bodyMedium(
                    color: ColorClass.secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}