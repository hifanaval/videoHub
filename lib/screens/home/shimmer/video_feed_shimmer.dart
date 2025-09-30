import 'package:flutter/material.dart';
import 'package:videohub/screens/home/shimmer/base_shimmer.dart';

class VideoFeedShimmer extends StatelessWidget {
  const VideoFeedShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: 3, // Show 3 shimmer items
      itemBuilder: (context, index) {
        return _buildVideoCardShimmer(context, index);
      },
    );
  }

  Widget _buildVideoCardShimmer(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Creator Info Shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              children: [
                // Avatar shimmer
                BaseShimmer(
                  width: 40,
                  height: 40,
                  borderRadius: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name shimmer
                      BaseShimmer(
                        width: 120 + (index * 20), // Varying widths
                        height: 16,
                        borderRadius: 8,
                      ),
                      const SizedBox(height: 4),
                      // Time shimmer
                      BaseShimmer(
                        width: 80,
                        height: 12,
                        borderRadius: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Video Thumbnail Shimmer
          BaseShimmer(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2,
            borderRadius: 0,
          ),
          const SizedBox(height: 12),

          // Description Shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First line of description
                BaseShimmer(
                  width: double.infinity,
                  height: 16,
                  borderRadius: 8,
                ),
                const SizedBox(height: 8),
                // Second line of description
                BaseShimmer(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 16,
                  borderRadius: 8,
                ),
                const SizedBox(height: 8),
                // Third line of description (shorter)
                BaseShimmer(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 16,
                  borderRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
