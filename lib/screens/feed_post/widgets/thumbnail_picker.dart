import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:videohub/screens/feed_post/provider/feed_post_provider.dart';
import 'package:videohub/screens/feed_post/widgets/dotted_border.dart';

class ThumbnailPicker extends StatefulWidget {
  const ThumbnailPicker({super.key});

  @override
  State<ThumbnailPicker> createState() => _ThumbnailPickerState();
}

class _ThumbnailPickerState extends State<ThumbnailPicker> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedPostProvider>(
      builder: (context, feedPostProvider, child) {
        final hasThumbnail = feedPostProvider.isThumbnailSelected;
        
        if (hasThumbnail) {
          return _buildThumbnailPreview();
        } else {
          return DottedBorderContainer(
            height: 180,
            onTap: _showThumbnailOptions,
            child: _buildPlaceholder(),
          );
        }
      },
    );
  }

  Widget _buildPlaceholder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.image_outlined,
          size: 32,
          color: Colors.grey.shade400,
        ),
        const SizedBox(width: 12),
        Text(
          'Add a Thumbnail',
          style: TextStyle(
            color: Colors.grey.shade300,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnailPreview() {
    return Consumer<FeedPostProvider>(
      builder: (context, feedPostProvider, child) {
        final thumbnailFile = feedPostProvider.selectedThumbnail;
        
        if (thumbnailFile == null) {
          return _buildPlaceholder();
        }

        return ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 120,
            maxHeight: 300,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Thumbnail image - dynamic sizing
                Image.file(
                  thumbnailFile,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              
              // Remove button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: _removeThumbnail,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      },
    );
  }

  void _showThumbnailOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Thumbnail',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOption(
                  icon: Icons.camera_alt,
                  title: 'Take Photo',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(source: ImageSource.camera);
                  },
                ),
                _buildOption(
                  icon: Icons.photo_library,
                  title: 'Photo Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(source: ImageSource.gallery);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage({required ImageSource source}) async {
    debugPrint('🖼️ Starting image picker with source: $source');
    
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      debugPrint('🖼️ Image picker result: ${pickedFile?.path ?? 'null'}');

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        debugPrint('🖼️ Image file created: ${imageFile.path}');
        
        // Store in provider
        final feedPostProvider = Provider.of<FeedPostProvider>(context, listen: false);
        feedPostProvider.setThumbnailFile(imageFile);
      }
    } catch (e) {
      debugPrint('❌ Error picking image: $e');
    }
  }

  void _removeThumbnail() {
    debugPrint('🗑️ Removing thumbnail');
    
    final feedPostProvider = Provider.of<FeedPostProvider>(context, listen: false);
    feedPostProvider.clearThumbnail();
  }
}
