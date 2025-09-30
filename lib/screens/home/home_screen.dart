import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videohub/components/video_player_widget.dart';
import 'package:videohub/constants/color_class.dart';
import 'package:videohub/constants/image_class.dart';
import 'package:videohub/constants/textstyle_class.dart';
import 'package:videohub/screens/feed_post/feed_post_screen.dart';
import 'package:videohub/screens/home/model/home_model.dart';
import 'package:videohub/screens/home/provider/category_provider.dart';
import 'package:videohub/screens/home/provider/home_provider.dart';
import 'package:videohub/components/base_shimmer.dart';
import 'package:videohub/screens/home/shimmer/category_list_shimer.dart';
import 'package:videohub/screens/home/shimmer/video_feed_shimmer.dart';
import 'package:videohub/screens/login_screen/provider/auth_provider.dart';
import 'package:videohub/utils/app_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    // Defer API calls until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategoryData(context);
      Provider.of<HomeProvider>(context, listen: false).fetchHomeData(context);
    });
  }

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
          InkWell(
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
                border: Border.all(color: ColorClass.primaryColor, width: 2),
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
    return SizedBox(
      height: 50,
      child: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          // Show shimmer while loading
          if (categoryProvider.isLoading) {
            return CategoryListShimmer();
          }
          
          // Show categories when loaded
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            itemCount: categoryProvider.categories.length,
            itemBuilder: (context, index) {
              final category = categoryProvider.categories[index];
              final isSelected = selectedCategoryIndex == index;
        
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategoryIndex = index;
                  });
                  debugPrint('Category selected: ${category.title}');
                },
                child: Padding(
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
                    child: Center(
                      child: Text(
                        category.title ?? '',
                        style: TextStyleClass.buttonRegular(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }


  Widget _buildVideoFeed() {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        // Show shimmer when loading
        if (homeProvider.isLoading) {
          return const VideoFeedShimmer();
        }
        
        // Show actual content when loaded
        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: homeProvider.homeItems.length,
          itemBuilder: (context, index) {
            final video = homeProvider.homeItems[index];
            return _buildVideoCard(context, video);
          },
        );
      }
    );
  }

  Widget _buildVideoCard(BuildContext context, HomeItem video) {
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
                  child: CachedNetworkImage(
                    imageUrl: video.user?.image ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const BaseShimmer(
                      width: 40,
                      height: 40,
                      borderRadius: 40,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.person, size: 40, color: ColorClass.tertiaryColor),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.user?.name ?? '',
                        style: TextStyleClass.bodyMedium(),
                      ),
                      Text(
                       AppUtils.timeAgoFull(video.createdAt?.toString()),
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

          // Video Player
          VideoPlayerWidget(
            videoUrl: video.video ?? '',
            thumbnailUrl: video.image ?? '',
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 12),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              video.description ?? '',
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
       AppUtils.navigateTo(context, AddVideoScreen());
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
              color: ColorClass.red.withValues(alpha: 0.7),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
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
                      border: Border.all(color: ColorClass.red.withValues(alpha: 0.7), width: 3),
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
                      onPressed:
                          () => AppUtils.showLogoutConfirmation(
                            context,
                            () => Provider.of<AuthProvider>(
                              context,
                              listen: false,
                            ).handleLogout(context),
                          ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorClass.red.withValues(alpha: 0.7),
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
            color: ColorClass.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: ColorClass.red.withValues(alpha: 0.7), size: 20),
        ),
        title: Text(title, style: TextStyleClass.buttonRegular()),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        hoverColor: ColorClass.red.withValues(alpha: 0.1),
      ),
    );
  }
}


