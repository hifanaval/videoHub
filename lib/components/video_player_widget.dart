import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:videohub/constants/color_class.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String thumbnailUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.thumbnailUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isVisible = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();

    // Set initial visibility state - assume first video is visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isVisible = true; // Assume first video is visible on load
        });
      }
    });
  }

  Future<void> _initializeVideo() async {
    try {
      // Skip initialization if URL is empty
      if (widget.videoUrl.isEmpty) {
        return;
      }

      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        // Add listener to handle video state changes
        _controller!.addListener(_videoListener);

        // Auto-play if this is the first video and it's visible
        // Add a small delay to ensure the widget is properly mounted
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted && _isInitialized && _isVisible) {
            _playVideo();
          }
        });
      }
    } catch (e) {
      // Silently handle errors - just show thumbnail
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  void _playVideo() {
    if (_controller != null && _isInitialized) {
      _controller!.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _pauseVideo() {
    if (_controller != null && _isInitialized) {
      _controller!.pause();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _videoListener() {
    if (_controller != null && mounted) {
      final isPlaying = _controller!.value.isPlaying;
      if (isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = isPlaying;
        });
      }
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    final isVisible =
        info.visibleFraction > 0.3; // Lower threshold for better responsiveness

    if (isVisible != _isVisible) {
      setState(() {
        _isVisible = isVisible;
      });

      if (isVisible && _isInitialized) {
        // Add a small delay to ensure smooth transition
        Future.delayed(const Duration(milliseconds: 50), () {
          if (mounted && _isVisible && _isInitialized) {
            _playVideo();
          }
        });
      } else if (!isVisible && _isPlaying) {
        _pauseVideo();
      }
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video_${widget.videoUrl}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: GestureDetector(
        onTap: () {
          if (_isPlaying) {
            _pauseVideo();
          } else {
            _playVideo();
          }
        },
        child: Container(
          width: widget.width,
          height: widget.height,
          child: Stack(
            children: [
              // Video player or thumbnail background
              if (_isInitialized && !_hasError)
                SizedBox.expand(
                  child: FittedBox(
                    fit: widget.fit,
                    child: SizedBox(
                      width: _controller!.value.size.width,
                      height: _controller!.value.size.height,
                      child: VideoPlayer(_controller!),
                    ),
                  ),
                )
              else
                // Thumbnail background - always show this as fallback
                Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.thumbnailUrl),
                      fit: widget.fit,
                    ),
                  ),
                ),

              // Play button overlay - only show when not playing
              if (!_isPlaying)
                Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorClass.primaryColor.withValues(alpha: 0.25),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),

              // Loading indicator
              if (!_isInitialized && !_hasError && widget.videoUrl.isNotEmpty)
                Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                    child: CupertinoActivityIndicator(
                      color: Colors.white,
                      radius: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
