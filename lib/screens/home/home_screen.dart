import 'package:flutter/material.dart';
import 'package:videohub/constants/color_class.dart';
import 'package:videohub/constants/image_class.dart';
import 'package:videohub/constants/textstyle_class.dart';

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
            _buildHeader(),
            const SizedBox(height: 20),
            
            // Category Bar
            _buildCategoryBar(),
            const SizedBox(height: 20),
            
            // Video Feed
            Expanded(
              child: _buildVideoFeed(),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello Maria',
                style: TextStyleClass.h2(),
              ),
              const SizedBox(height: 4),
              Text(
                'Welcome back to Section',
                style: TextStyleClass.bodyRegular(
                  color: ColorClass.secondaryColor,
                ),
              ),
            ],
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
            
            ),
            child: Image.asset(ImageClass.profileImage),
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category['isSelected'] as bool;
          
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.red.shade600 : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(25),
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
                    style: TextStyleClass.buttonRegular(
                      color: Colors.white,
                    ),
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
        'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
        'thumbnail': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=225&fit=crop',
        'description': 'Lorem ipsum dolor sit amet consectetur. Leo ac lorem faucli bus facilisis tellus. At vitae dis commodo sollicitudin elementum suspendisse...',
      },
      {
        'creator': 'Gokul Krishna',
        'time': '5 days ago',
        'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        'thumbnail': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=225&fit=crop',
        'description': 'Lorem ipsum dolor sit amet consectetur. Leo ac lorem faucli bus facilisis tellus. At vitae dis commodo nunc sollicitudin elementum suspendisse... See More',
      },
      {
        'creator': 'Michel Jhon',
        'time': '5 days ago',
        'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        'thumbnail': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=225&fit=crop',
        'description': 'Lorem ipsum dolor sit amet consectetur. Leo ac lorem faucli bus facilisis tellus. At vitae dis commodo sollicitudin elementum suspendisse...',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return _buildVideoCard(video);
      },
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Creator Info
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                  image: DecorationImage(
                    image: NetworkImage(video['avatar']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video['creator'],
                      style: TextStyleClass.buttonRegular(
                        color: Colors.white,
                      ),
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
          const SizedBox(height: 12),
          
          // Video Thumbnail
          GestureDetector(
            onTap: () {
              debugPrint('Video tapped: ${video['creator']}');
            },
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade800,
                image: DecorationImage(
                  image: NetworkImage(video['thumbnail']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Description
          Text(
            video['description'],
            style: TextStyleClass.bodyRegular(
              color: ColorClass.quaternaryColor,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        debugPrint('Create video button pressed');
      },
      backgroundColor: Colors.red.shade600,
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}