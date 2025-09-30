import 'package:flutter/material.dart';
import 'package:videohub/constants/color_class.dart';
import 'package:videohub/constants/global_variables.dart';
import 'package:videohub/constants/image_class.dart';
import 'package:videohub/constants/textstyle_class.dart';
import 'package:videohub/screens/login_screen/login_screen.dart';
import 'package:videohub/utils/shared_utils.dart';
import 'package:videohub/constants/string_class.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorClass.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(context),
            const SizedBox(height: 20),

            // Category Bar
            _buildCategoryBar(),
            const SizedBox(height: 20),

            // Video Feed
            Expanded(child: _buildVideoFeed()),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello Maria', style: TextStyleClass.h2()),
              const SizedBox(height: 4),
              Text(
                'Welcome back to Section',
                style: TextStyleClass.bodyRegular(
                  color: ColorClass.secondaryColor,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              debugPrint('Profile image tapped');
              _showProfileDrawer(context);
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade300,
                border: Border.all(color: Colors.red.shade600, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(ImageClass.profileImage, fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    final categories = [
      {'name': 'Explore', 'icon': Icons.explore, 'isSelected': true},
      {'name': 'Trending', 'icon': Icons.trending_up, 'isSelected': false},
      {'name': 'All Categories', 'icon': Icons.category, 'isSelected': false},
      {'name': 'Photography', 'icon': Icons.camera_alt, 'isSelected': false},
    ];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category['isSelected'] as bool;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? ColorClass.red.withValues(alpha: 0.4)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color:
                      isSelected
                          ? ColorClass.red.withValues(alpha: 0.2)
                          : ColorClass.primaryColor.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category['icon'] as IconData,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category['name'] as String,
                    style: TextStyleClass.buttonRegular(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoFeed() {
    final videos = [
      {
        'creator': 'Anagha Krishna',
        'time': '5 days ago',
        'avatar':
            'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
        'thumbnail':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=225&fit=crop',
        'description':
            'Lorem ipsum dolor sit amet consectetur. Leo ac lorem faucli bus facilisis tellus. At vitae dis commodo sollicitudin elementum suspendisse...',
      },
      {
        'creator': 'Gokul Krishna',
        'time': '5 days ago',
        'avatar':
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        'thumbnail':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=225&fit=crop',
        'description':
            'Lorem ipsum dolor sit amet consectetur. Leo ac lorem faucli bus facilisis tellus. At vitae dis commodo nunc sollicitudin elementum suspendisse... See More',
      },
      {
        'creator': 'Michel Jhon',
        'time': '5 days ago',
        'avatar':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        'thumbnail':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=225&fit=crop',
        'description':
            'Lorem ipsum dolor sit amet consectetur. Leo ac lorem faucli bus facilisis tellus. At vitae dis commodo sollicitudin elementum suspendisse...',
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.zero,
      // padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return _buildVideoCard(context, video);
      },
    );
  }

  Widget _buildVideoCard(BuildContext context, Map<String, dynamic> video) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Creator Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                  child: Image.asset(ImageClass.profileImage),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video['creator'],
                        style: TextStyleClass.bodyMedium(),
                      ),
                      Text(
                        video['time'],
                        style: TextStyleClass.caption(
                          color: ColorClass.quaternaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Video Thumbnail
          GestureDetector(
            onTap: () {
              debugPrint('Video tapped: ${video['creator']}');
            },
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: double.infinity,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade800,
                image: DecorationImage(
                  image: NetworkImage(video['thumbnail']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorClass.primaryColor.withValues(alpha: 0.25),
                    border: Border.all(
                      color: ColorClass.primaryColor,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: ColorClass.primaryColor,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              video['description'],
              style: TextStyleClass.bodyLight(color: ColorClass.secondaryColor),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      shape: CircleBorder(),
      onPressed: () {
        debugPrint('Create video button pressed');
      },
      backgroundColor: ColorClass.red,
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }

  void _showProfileDrawer(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: ColorClass.backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: _buildDrawerContent(context),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
  }

  Widget _buildDrawerContent(BuildContext context) {
    return Material(
      color: ColorClass.backgroundColor,
      child: Column(
        children: [
          // Header with close button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.shade600,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Profile', style: TextStyleClass.h2(color: Colors.white)),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Profile Info Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Image
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red.shade600, width: 3),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        ImageClass.profileImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // User Name
                  Text('Maria Johnson', style: TextStyleClass.h2()),
                  const SizedBox(height: 8),

                  // User Email/Phone
                  Text(
                    '+91 9876543210',
                    style: TextStyleClass.bodyRegular(
                      color: ColorClass.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Menu Items
                  _buildDrawerItem(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    onTap: () {
                      Navigator.of(context).pop();
                      debugPrint('Edit Profile tapped');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {
                      Navigator.of(context).pop();
                      debugPrint('Settings tapped');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      Navigator.of(context).pop();
                      debugPrint('Help & Support tapped');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.info_outline,
                    title: 'About',
                    onTap: () {
                      Navigator.of(context).pop();
                      debugPrint('About tapped');
                    },
                  ),

                  const Spacer(),

                  // Logout Button
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: () => _handleLogout(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: TextStyleClass.buttonRegular(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.shade600.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.red.shade600, size: 20),
        ),
        title: Text(title, style: TextStyleClass.buttonRegular()),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        hoverColor: Colors.red.shade600.withOpacity(0.1),
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
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
