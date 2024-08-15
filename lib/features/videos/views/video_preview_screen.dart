import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';
import 'package:tiktok/common/widgets/cst_text_form_field.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/videos/view_models/upload_videos_view_model.dart';
import 'package:tiktok/utils/utils.dart';

class VideoPreviewScreen extends ConsumerStatefulWidget {
  final XFile video;
  final bool isPicked;

  const VideoPreviewScreen({
    Key? key,
    required this.video,
    required this.isPicked,
  }) : super(key: key);

  @override
  VideoPreviewScreenState createState() => VideoPreviewScreenState();
}

class VideoPreviewScreenState extends ConsumerState<VideoPreviewScreen> {
  late final VideoPlayerController _videoPlayerController;
  bool _hasVideoSaved = false;
  Map<String, String> formData = {};

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> _initVideo() async {
    _videoPlayerController =
        VideoPlayerController.file(File(widget.video.path));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.setVolume(0);
    setState(() {});
  }

  Future<void> _saveToGallery() async {
    if (_hasVideoSaved) return;
    await GallerySaver.saveVideo(widget.video.path, albumName: "TikTok");
    setState(() => _hasVideoSaved = true);
  }

  void _onUploadPressed() {
    ref.read(uploadVideoProvider.notifier).uploadVideo(
          File(widget.video.path),
          context,
          formData,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Preview video'),
      actions: [
        if (!widget.isPicked)
          IconButton(
            onPressed: _saveToGallery,
            icon: FaIcon(_hasVideoSaved
                ? FontAwesomeIcons.check
                : FontAwesomeIcons.download),
          ),
        IconButton(
          onPressed: ref.watch(uploadVideoProvider).isLoading
              ? null
              : _onUploadPressed,
          icon: ref.watch(uploadVideoProvider).isLoading
              ? const CircularProgressIndicator()
              : const FaIcon(FontAwesomeIcons.cloudArrowUp),
        )
      ],
    );
  }

  Widget _buildBody() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildVideoPlayer(),
        _buildInputForm(),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    return Positioned.fill(
      child: _videoPlayerController.value.isInitialized
          ? VideoPlayer(_videoPlayerController)
          : Container(color: Colors.black),
    );
  }

  Widget _buildInputForm() {
    return Positioned(
      bottom: 100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent.withOpacity(0.35),
        ),
        width: getWinWidth(context) * 0.7,
        height: getWinHeight(context) * 0.15,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTextField('title'),
              _buildTextField('description'),
              Gaps.v10,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String fieldName) {
    return Expanded(
      child: CstTextFormField(
        hintText: fieldName,
        onChanged: (newValue) => formData[fieldName] = newValue,
      ),
    );
  }
}
