import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/videos/view_models/timeline_view_model.dart';
import 'package:tiktok/features/videos/views/widgets/video_post.dart';

class VideoTimelineScreen extends ConsumerStatefulWidget {
  const VideoTimelineScreen({Key? key}) : super(key: key);

  @override
  VideoTimelineScreenState createState() => VideoTimelineScreenState();
}

class VideoTimelineScreenState extends ConsumerState<VideoTimelineScreen> {
  final PageController _pageController = PageController();
  final Duration _scrollDuration = const Duration(milliseconds: 250);
  final Curve _scrollCurve = Curves.linear;
  int _itemCount = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    _pageController.animateToPage(
      page,
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
    if (page == _itemCount - 1) {
      ref.read(timelineProvider.notifier).fetchNextPage();
    }
  }

  void _onVideoFinished() {
    _pageController.nextPage(
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
  }

  Future<void> _onRefresh() {
    return ref.read(timelineProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(timelineProvider).when(
          loading: _buildLoadingIndicator,
          error: _buildErrorMessage,
          data: _buildVideoTimeline,
        );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorMessage(Object error, StackTrace? stackTrace) {
    return Center(
      child: Text(
        'Could not load videos: $error',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildVideoTimeline(List<dynamic> videos) {
    _itemCount = videos.length;
    return RefreshIndicator(
      onRefresh: _onRefresh,
      displacement: 50,
      edgeOffset: 20,
      color: Theme.of(context).primaryColor,
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: _onPageChanged,
        itemCount: videos.length,
        itemBuilder: (context, index) => _buildVideoPost(videos[index], index),
      ),
    );
  }

  Widget _buildVideoPost(dynamic videoData, int index) {
    return VideoPost(
      onVideoFinished: _onVideoFinished,
      index: index,
      videoData: videoData,
    );
  }
}
