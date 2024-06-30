import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/rawData/video_data.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/videos/models/video_model.dart';
import 'package:tiktok/features/videos/view_models/playback_config_view_model.dart';
import 'package:tiktok/features/videos/view_models/video_post_view_model.dart';
import 'package:tiktok/features/videos/views/widgets/video_bgm_info.dart';
import 'package:tiktok/features/videos/views/widgets/video_button.dart';
import 'package:tiktok/features/videos/views/widgets/video_comments.dart';
import 'package:tiktok/features/videos/views/widgets/video_intro_text.dart';
import 'package:tiktok/utils/utils.dart';
import 'package:tiktok/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoPost extends ConsumerStatefulWidget {
  final VoidCallback onVideoFinished;
  final VideoModel videoData;
  final int index;

  const VideoPost({
    Key? key,
    required this.onVideoFinished,
    required this.videoData,
    required this.index,
  }) : super(key: key);

  @override
  VideoPostState createState() => VideoPostState();
}

class VideoPostState extends ConsumerState<VideoPost>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;
  late AnimationController _animationController;

  bool _isPaused = false;
  bool _isMute = false;

  final List<String> _tags = tags;
  final String _bgmInfo = bgmInfo;
  final Duration _animationDuration = const Duration(milliseconds: 200);

  void _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoData.fileUrl),
    );
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    if (kIsWeb) {
      await _videoPlayerController.setVolume(0);
    }
    _videoPlayerController.addListener(_onVideoChange);
    _onPlaybackConfigChanged();
    if (mounted) setState(() {});
  }

  void _onVideoChange() {
    if (!mounted || _videoPlayerController.value.hasError) return;
    if (_videoPlayerController.value.duration ==
        _videoPlayerController.value.position) {
      widget.onVideoFinished();
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted || _videoPlayerController.value.hasError) return;
    if (info.visibleFraction == 1 &&
        !_videoPlayerController.value.isPlaying &&
        !_isPaused) {
      if (ref.read(playbackConfigProvider).autoplay) {
        _videoPlayerController.play();
      }
    } else if (_videoPlayerController.value.isPlaying &&
        info.visibleFraction == 0) {
      _onTogglePause();
    }
  }

  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse();
    } else {
      _videoPlayerController.play();
      _animationController.forward();
    }
    if (mounted) {
      setState(() {
        _isPaused = !_isPaused;
      });
    }
  }

  void _onCommentsTap(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const VideoComments(),
      backgroundColor: Colors.transparent,
    );
    _onTogglePause();
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();

    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPlaybackConfigChanged({bool toggle = false}) {
    if (!mounted) return;
    _isMute = toggle ? !_isMute : ref.read(playbackConfigProvider).muted;
    _videoPlayerController.setVolume(_isMute ? 0 : 1);
    setState(() {});
  }

  void _onLikeTap() {
    ref.read(videoPostProvider(widget.videoData.id).notifier).likeVideo();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('${widget.index}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Image.network(
                    widget.videoData.thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned.fill(
            child: GestureDetector(onTap: _onTogglePause),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.scale(
                      scale: _animationController.value,
                      child: child,
                    );
                  },
                  child: AnimatedOpacity(
                    opacity: _isPaused ? 1 : 0,
                    duration: _animationDuration,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size52,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 40,
            child: IconButton(
              icon: FaIcon(
                _isMute
                    ? FontAwesomeIcons.volumeOff
                    : FontAwesomeIcons.volumeHigh,
                color: Colors.white,
              ),
              onPressed: () => _onPlaybackConfigChanged(toggle: true),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            child: SizedBox(
              width: getWinWidth(context) - 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '@${widget.videoData.creator}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: Sizes.size20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gaps.v10,
                  VideoIntroText(
                    descText: widget.videoData.description,
                    mainTextBold: FontWeight.normal,
                  ),
                  Gaps.v10,
                  VideoIntroText(
                    descText: _tags.join(', '),
                    mainTextBold: FontWeight.w600,
                  ),
                  Gaps.v10,
                  VideoBgmInfo(bgmInfo: _bgmInfo),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: Sizes.size20,
            right: Sizes.size10,
            child: Column(
              children: [
                CircleAvatar(
                  radius: Sizes.size24,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/tiktok-10313.appspot.com/o/avatars%2F${widget.videoData.creatorUid}?alt=media",
                  ),
                  child: Text(
                    widget.videoData.creator,
                    style: const TextStyle(
                      fontSize: Sizes.size8,
                    ),
                  ),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: _onLikeTap,
                  child: VideoButton(
                    icon: FontAwesomeIcons.solidHeart,
                    text: S.of(context).likeCount(widget.videoData.likes),
                  ),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: () => _onCommentsTap(context),
                  child: VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    text: S.of(context).commentCount(widget.videoData.comments),
                  ),
                ),
                Gaps.v24,
                const VideoButton(
                  icon: FontAwesomeIcons.share,
                  text: 'Share',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
