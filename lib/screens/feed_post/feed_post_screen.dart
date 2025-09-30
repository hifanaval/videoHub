import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videohub/components/custom_text_field.dart';
import 'package:videohub/constants/color_class.dart';
import 'package:videohub/screens/feed_post/provider/feed_post_provider.dart';
import 'package:videohub/screens/feed_post/widgets/all_category_bs.dart';
import 'package:videohub/screens/feed_post/widgets/category_chip.dart';
import 'package:videohub/screens/feed_post/widgets/video_picker.dart';
import 'package:videohub/screens/feed_post/widgets/thumbnail_picker.dart';
import 'package:videohub/screens/home/provider/category_provider.dart';

class AddVideoScreen extends StatefulWidget {
  const AddVideoScreen({super.key});

  @override
  State<AddVideoScreen> createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  
  

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }


  void _showAllCategories() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AllCategoriesBottomSheet(
        categories: context.read<CategoryProvider>().categories,
      ),
    );
  }

  void _sharePost() async {
    final feedPostProvider = context.read<FeedPostProvider>();
    final categoryProvider = context.read<CategoryProvider>();
    
    // Set description in provider
    feedPostProvider.setDescription(_descriptionController.text.trim());
    
    debugPrint('📤 Starting feed post from UI');
    debugPrint('📤 Selected Category IDs: ${categoryProvider.selectedCategoryIds}');
    debugPrint('📤 Description: ${_descriptionController.text.trim()}');
    
    // Call the post method from FeedPostProvider
    await feedPostProvider.postFeed(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorClass.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorClass.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
            context.read<FeedPostProvider>().reset(context);
          },
        ),
        title: const Text(
          'Add Feeds',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: _sharePost,
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Share Post',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Selection
            VideoPicker(),

            const SizedBox(height: 16),

            // Thumbnail Selection
            ThumbnailPicker(),

            const SizedBox(height: 24),

            // Description
            const Text(
              'Add Description',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _descriptionController,
              hintText: 'Add Description',
                 keyboardType: TextInputType.multiline,
              // maxLength: 500,
              maxLines: 5,
              backgroundColor: Colors.grey.shade900,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              textStyle: TextStyle(color: Colors.grey.shade300),
              hintStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 24),

            // Categories
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Categories This Project',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (context.read<CategoryProvider>().categories.length > 5)
                  GestureDetector(
                    onTap: _showAllCategories,
                    child: Row(
                      children: [
                        Text(
                          'View All',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Category Chips (Show only 5)
             // Category Chips (Show selected categories or first 5)
            Consumer<CategoryProvider>(
              builder: (context, categoryProvider, child) {
                // Get selected categories
                final selectedCategories = context.read<CategoryProvider>().categories
                    .where((cat) => categoryProvider.isSelected(cat.id.toString()))
                    .toList();
                
                // If no categories selected, show first 5
                final displayCategories = selectedCategories.isEmpty
                    ? context.read<CategoryProvider>().categories.take(5).toList()
                    : selectedCategories;
                
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: displayCategories.map((category) {
                    final isSelected = categoryProvider.isSelected(category.id.toString());
                    return CategoryChip(
                      category: category,
                      isSelected: isSelected,
                      onTap: () => categoryProvider.toggleCategory(category.id.toString()),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}