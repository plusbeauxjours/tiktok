import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/constants/rawData/video_data.dart';
import 'package:tiktok/features/videos/view_models/timeline_view_model.dart';
import 'package:tiktok/features/videos/views/widgets/video_post.dart';

class VideoTimelineScreen extends ConsumerStatefulWidget {
  const VideoTimelineScreen({Key? key}) : super(key: key);

  @override
  VideoTimelineScreenState createState() => VideoTimelineScreenState();
}

class VideoTimelineScreenState extends ConsumerState<VideoTimelineScreen> {
  final PageController _pageController = PageController();

  final _scrollDuration = const Duration(milliseconds: 250);
  final _scrollCurve = Curves.linear;
  List<String> _videos = [...videos];

  void _onPageChanged(int page) {
    _pageController.animateToPage(
      page,
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
    if (page == _videos.length - 1) {
      _videos = [..._videos, ...videos];
      setState(() {});
    }
  }

  void _onVideoFinished() {
    _pageController.nextPage(
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
  }

  Future<void> _onRefresh() {
    return Future.delayed(
      const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(timelineProvider).when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              'Could not load videos: $error',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          data: (videos) => RefreshIndicator(
            onRefresh: _onRefresh,
            displacement: 50,
            edgeOffset: 20,
            color: Theme.of(context).primaryColor,
            child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: _onPageChanged,
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final videoData = videos[index];
                  return VideoPost(
                    onVideoFinished: _onVideoFinished,
                    videoData: videoData,
                    index: index,
                  );
                }),
          ),
        );
  }
}
