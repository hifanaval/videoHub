// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:videohub/constants/string_class.dart';
import 'package:videohub/screens/home/provider/category_provider.dart';
import 'package:videohub/screens/home/provider/home_provider.dart';
import 'package:videohub/utils/api_urls.dart';
import 'package:videohub/utils/app_utils.dart';
import 'package:videohub/utils/shared_utils.dart';

class FeedPostProvider extends ChangeNotifier {
  File? _selectedVideo;
  bool _isVideoSelected = false;
  File? _selectedThumbnail;
  bool _isThumbnailSelected = false;
  bool _isPosting = false;
  final TextEditingController _descriptionController = TextEditingController();

  // Getters
  File? get selectedVideo => _selectedVideo;
  bool get isVideoSelected => _isVideoSelected;
  File? get selectedThumbnail => _selectedThumbnail;
  bool get isThumbnailSelected => _isThumbnailSelected;
  bool get isPosting => _isPosting;
  TextEditingController get descriptionController => _descriptionController;

  // Set video file
  void setVideoFile(File? videoFile) {
    _selectedVideo = videoFile;
    _isVideoSelected = videoFile != null;
    notifyListeners();
  }

  // Set thumbnail file
  void setThumbnailFile(File? thumbnailFile) {
    _selectedThumbnail = thumbnailFile;
    _isThumbnailSelected = thumbnailFile != null;
    notifyListeners();
  }

  // Clear video
  void clearVideo() {
    _selectedVideo = null;
    _isVideoSelected = false;
    notifyListeners();
  }

  // Clear thumbnail
  void clearThumbnail() {
    _selectedThumbnail = null;
    _isThumbnailSelected = false;
    notifyListeners();
  }

  // Set description
  void setDescription(String description) {
    _descriptionController.text = description;
    notifyListeners();
  }


  // Set posting state
  void setPosting(bool isPosting) {
    _isPosting = isPosting;
    notifyListeners();
  }

  // Post feed data
  Future<void> postFeed(BuildContext context) async {
    setPosting(true);
    
    try {
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      
      // Validate required fields
      if (_selectedVideo == null) {
        AppUtils.showToast(context, 'Error', 'Please select a video', false);
        return;
      }
      
      if (_descriptionController.text.trim().isEmpty) {
        AppUtils.showToast(context, 'Error', 'Please enter a description', false);
        return;
      }
      
      if (categoryProvider.selectedCategoryIds.isEmpty) {
        AppUtils.showToast(context, 'Error', 'Please select at least one category', false);
        return;
      }

      // Validate file sizes (80MB limit)
      const int maxFileSize = 60 * 1024 * 1024; // 80MB in bytes
      
      if (_selectedVideo != null) {
        final videoSize = await _selectedVideo!.length();
        debugPrint('📤 Video file size: ${(videoSize / (1024 * 1024)).toStringAsFixed(2)} MB');
        
        if (videoSize > maxFileSize) {
          AppUtils.showToast(context, 'Error', 'Video file size must be less than 60MB', false);
          return;
        }
      }
      
      if (_selectedThumbnail != null) {
        final imageSize = await _selectedThumbnail!.length();
        debugPrint('📤 Image file size: ${(imageSize / (1024 * 1024)).toStringAsFixed(2)} MB');
        
        if (imageSize > maxFileSize) {
          AppUtils.showToast(context, 'Error', 'Image file size must be less than 80MB', false);
          return;
        }
      }

      debugPrint('📤 Creating multipart form data');
      
      // Create FormData for multipart upload
      FormData formData = FormData.fromMap({
        "desc": _descriptionController.text.trim(),
        "category": categoryProvider.selectedCategoryIds,
      });

      // Add video file
      if (_selectedVideo != null) {
        String videoFileName = _selectedVideo!.path.split('/').last;
        formData.files.add(MapEntry(
          "video",
          await MultipartFile.fromFile(
            _selectedVideo!.path,
            filename: videoFileName,
          ),
        ));
        debugPrint('📤 Added video file: $videoFileName');
      }

      // Add thumbnail image if selected
      if (_selectedThumbnail != null) {
        String imageFileName = _selectedThumbnail!.path.split('/').last;
        formData.files.add(MapEntry(
          "image",
          await MultipartFile.fromFile(
            _selectedThumbnail!.path,
            filename: imageFileName,
          ),
        ));
        debugPrint('📤 Added image file: $imageFileName');
      }

      debugPrint('📤 Description: ${_descriptionController.text.trim()}');
      debugPrint('📤 Categories: ${categoryProvider.selectedCategoryIds}');
      debugPrint('📤 Has video: ${_selectedVideo != null}');
      debugPrint('📤 Has thumbnail: ${_selectedThumbnail != null}');

      final accessToken = await SharedUtils.getString(StringClass.token);

      // Make API call
      final response = await Dio().post(
        ApiUrls.postFeedData(), 
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer $accessToken",
          },
        ),
      );

      debugPrint('📤 Feed post response status: ${response.statusCode}');
      debugPrint('📤 Feed post response data: ${response.data}');

      if (response.statusCode == 202) {
        final responseData = response.data;
        if (responseData['status'] == true) {
          String successMessage = responseData['message'] ?? 'Feed posted successfully!';
          AppUtils.showToast(context, 'Success', successMessage, true);
          debugPrint('✅ Feed posted successfully: $successMessage');
          Provider.of<HomeProvider>(context, listen: false).fetchHomeData(context);
          // Reset form after successful post
          reset(context);
          Navigator.pop(context);
        } else {
          String errorMessage = responseData['message'] ?? 'Failed to post feed';
          AppUtils.showToast(context, 'Error', errorMessage, false);
          debugPrint('❌ Feed post failed: $errorMessage');
        }
      } else {
        String errorMessage = 'Failed to post feed - Status: ${response.statusCode}';
        AppUtils.showToast(context, 'Error', errorMessage, false);
        debugPrint('❌ $errorMessage');
      }
    } catch (e) {
      debugPrint('❌ Error posting feed: $e');
      AppUtils.showToast(context, 'Error', 'Error posting feed: $e', false);
    } finally {
      setPosting(false);
      debugPrint('📤 Feed post process completed');
    }
  }

  // Reset all data
  void reset(BuildContext context) {
    debugPrint('🔄 Resetting feed post provider');
    clearVideo();
    clearThumbnail();
    _descriptionController.clear();
    setPosting(false);
    
    // Clear categories from CategoryProvider
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.clearCategories();
    
    notifyListeners();
  }

  @override
  void dispose() {
    debugPrint('🧹 Disposing feed post provider resources');
    _descriptionController.dispose();
    super.dispose();
  }
}