import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:videohub/constants/textstyle_class.dart';
import 'package:videohub/screens/feed_post/provider/feed_post_provider.dart';
import 'package:videohub/screens/feed_post/widgets/dotted_border.dart';
import 'package:video_player/video_player.dart';

class VideoPicker extends StatefulWidget {
  const VideoPicker({super.key});

  @override
  State<VideoPicker> createState() => _VideoPickerState();
}

class _VideoPickerState extends State<VideoPicker> {
  final ImagePicker _picker = ImagePicker();
  VideoPlayerController? _videoController;
  bool _isInitializing = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedPostProvider>(
      builder: (context, feedPostProvider, child) {
        final hasVideo = feedPostProvider.isVideoSelected;

        if (hasVideo) {
          return _buildVideoPreview();
        } else {
          return DottedBorderContainer(
            height: 380,
            onTap: _showVideoOptions,
            child: _buildPlaceholder(),
          );
        }
      },
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.video_library_outlined,
          size: 64,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 16),
        Text('Select a video', style: TextStyleClass.h4()),
        const SizedBox(height: 8),
        Text(
          'Tap to record or choose from gallery',
          style: TextStyleClass.bodyRegular(),
        ),
      ],
    );
  }

  Widget _buildVideoPreview() {
    return Consumer<FeedPostProvider>(
      builder: (context, feedPostProvider, child) {
        final videoFile = feedPostProvider.selectedVideo;

        if (videoFile == null) {
          return _buildPlaceholder();
        }

        return _videoController != null && _videoController!.value.isInitialized
            ? ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 200, maxHeight: 500),
              child: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: Stack(
                      children: [
                        // Video player
                        VideoPlayer(_videoController!),

                        // Play button overlay
                        Center(
                          child: GestureDetector(
                            onTap: _toggleVideoPlayback,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _videoController?.value.isPlaying == true
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        // Remove button
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: _removeVideo,
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
                ),
              ),
            )
            : SizedBox(
              height: 380,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.grey.shade800,
                  child: Center(
                    child:
                        _isInitializing
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Icon(
                              Icons.video_library,
                              size: 64,
                              color: Colors.white,
                            ),
                  ),
                ),
              ),
            );
      },
    );
  }

  void _showVideoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
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
                Text('Select Video', style: TextStyleClass.h5(color: Colors.black)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOption(
                      icon: Icons.videocam,
                      title: 'Record Video',
                      onTap: () {
                        Navigator.pop(context);
                        _pickVideo(source: ImageSource.camera);
                      },
                    ),
                    _buildOption(
                      icon: Icons.video_library,
                      title: 'Video Gallery',
                      onTap: () {
                        Navigator.pop(context);
                        _pickVideo(source: ImageSource.gallery);
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
            child: Icon(icon, size: 24, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyleClass.bodyRegular(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _pickVideo({required ImageSource source}) async {
    debugPrint('🎥 Starting video picker with source: $source');

    try {
      final XFile? pickedFile = await _picker.pickVideo(source: source);
      debugPrint('🎥 Video picker result: ${pickedFile?.path ?? 'null'}');

      if (pickedFile != null) {
        final videoFile = File(pickedFile.path);
        debugPrint('🎥 Video file created: ${videoFile.path}');

        // Store in provider
        final feedPostProvider = Provider.of<FeedPostProvider>(
          context,
          listen: false,
        );
        feedPostProvider.setVideoFile(videoFile);

        // Initialize video controller
        await _initializeVideoController(videoFile);
      }
    } catch (e) {
      debugPrint('❌ Error picking video: $e');
    }
  }

  Future<void> _initializeVideoController(File videoFile) async {
    debugPrint('🎬 Initializing video controller for: ${videoFile.path}');

    setState(() {
      _isInitializing = true;
    });

    try {
      _videoController?.dispose();
      _videoController = VideoPlayerController.file(videoFile);

      await _videoController!.initialize();
      debugPrint('🎬 Video controller initialized successfully');

      setState(() {
        _isInitializing = false;
      });
    } catch (e) {
      debugPrint('❌ Error initializing video controller: $e');
      setState(() {
        _isInitializing = false;
      });
    }
  }

  void _toggleVideoPlayback() {
    debugPrint('▶️ Toggling video playback');

    if (_videoController != null) {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
        debugPrint('⏸️ Video paused');
      } else {
        _videoController!.play();
        debugPrint('▶️ Video playing');
      }
    }
  }

  void _removeVideo() {
    debugPrint('🗑️ Removing video');

    _videoController?.dispose();
    _videoController = null;

    final feedPostProvider = Provider.of<FeedPostProvider>(
      context,
      listen: false,
    );
    feedPostProvider.clearVideo();
  }

  @override
  void dispose() {
    debugPrint('🧹 Disposing video picker resources');
    _videoController?.dispose();
    super.dispose();
  }
}
