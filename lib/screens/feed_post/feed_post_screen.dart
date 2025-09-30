import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videohub/components/custom_text_field.dart';
import 'package:videohub/constants/color_class.dart';
import 'package:videohub/constants/textstyle_class.dart';
import 'package:videohub/screens/feed_post/provider/feed_post_provider.dart';
import 'package:videohub/screens/feed_post/shimmer/post_feed_shimmer.dart';
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
  @override
  void dispose() {
    Provider.of<FeedPostProvider>(context, listen: false).dispose();
    super.dispose();
  }

  void _showAllCategories() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => AllCategoriesBottomSheet(
            categories: context.read<CategoryProvider>().categories,
          ),
    );
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
        title: Text('Add Feeds', style: TextStyleClass.h3()),
        actions: [
          Consumer<FeedPostProvider>(
            builder: (context, feedPostProvider, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: TextButton(
                  onPressed:
                      feedPostProvider.isPosting
                          ? null
                          : () async {
                            await feedPostProvider.postFeed(context);
                          },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        feedPostProvider.isPosting
                            ? Colors.grey.shade600
                            : ColorClass.red.withValues(alpha: 0.4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color:
                            feedPostProvider.isPosting
                                ? Colors.grey.shade400
                                : ColorClass.red.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  child:
                      feedPostProvider.isPosting
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CupertinoActivityIndicator(
                              color: Colors.white,
                              radius: 10,
                            ),
                          )
                          : Text(
                            'Share Post',
                            style: TextStyleClass.hintText(
                              color: ColorClass.primaryColor,
                            ),
                          ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<FeedPostProvider>(
        builder: (context, feedPostProvider, child) {
          if (feedPostProvider.isPosting) {
            return PostFeedShimmer();
          }

          return SingleChildScrollView(
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
                Text('Add Description', style: TextStyleClass.h5()),
                const SizedBox(height: 12),
                Consumer<FeedPostProvider>(
                  builder: (context, feedPostProvider, child) {
                    return CustomTextField(
                      controller: feedPostProvider.descriptionController,
                      hintText: 'Add Description',
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      textStyle: TextStyleClass.bodyRegular(),
                      hintStyle: TextStyleClass.hintText(),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Categories
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Categories This Project', style: TextStyleClass.h5()),
                    if (context.read<CategoryProvider>().categories.length > 5)
                      GestureDetector(
                        onTap: _showAllCategories,
                        child: Row(
                          children: [
                            Text(
                              'View All',
                              style: TextStyleClass.bodyMediumSmall(),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: ColorClass.primaryColor,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Category Chips (Show selected categories or first 5)
                Consumer<CategoryProvider>(
                  builder: (context, categoryProvider, child) {
                    // Get selected categories
                    final selectedCategories =
                        context
                            .read<CategoryProvider>()
                            .categories
                            .where(
                              (cat) => categoryProvider.isSelected(
                                cat.id.toString(),
                              ),
                            )
                            .toList();

                    // If no categories selected, show first 5
                    final displayCategories =
                        selectedCategories.isEmpty
                            ? context
                                .read<CategoryProvider>()
                                .categories
                                .take(5)
                                .toList()
                            : selectedCategories;

                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          displayCategories.map((category) {
                            final isSelected = categoryProvider.isSelected(
                              category.id.toString(),
                            );
                            return CategoryChip(
                              category: category,
                              isSelected: isSelected,
                              onTap:
                                  () => categoryProvider.toggleCategory(
                                    category.id.toString(),
                                  ),
                            );
                          }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
