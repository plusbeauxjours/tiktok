import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:tiktok/features/authentications/repos/authentication_repo.dart';
import 'package:tiktok/features/user/view_models/user_view_model.dart';
import 'package:tiktok/features/videos/models/video_model.dart';
import 'package:tiktok/features/videos/repos/videos_repo.dart';
import 'package:tiktok/utils/utils.dart';

class UploadVideoViewModel extends AsyncNotifier<void> {
  late final VideosRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(videosRepo);
  }

  Future<void> uploadVideo(
    File video,
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    final user = ref.read(authRepo).user;
    final userProfile = ref.read(userProvider).value;

    final videoPlayerController = VideoPlayerController.file(video);
    await videoPlayerController.initialize();
    final videoDuration = videoPlayerController.value.duration;
    final videoSize = await video.length();

    if (videoDuration > const Duration(seconds: 20)) {
      if (!context.mounted) return;
      showFirebaseErrorSnack(context, "Video must be less than 20 seconds.");
      return;
    }
    if (videoSize > 35 * 1024 * 1024) {
      if (!context.mounted) return;
      showFirebaseErrorSnack(context, "Video must be less than 35MB.");
      return;
    }

    if (userProfile != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final task = await _repository.uploadVideoFile(
          video,
          user!.uid,
        );
        if (task.metadata != null) {
          await _repository.saveVideo(
            VideoModel(
              id: "",
              title: data['title'],
              description: data['description'],
              fileUrl: await task.ref.getDownloadURL(),
              thumbnailUrl: "",
              creatorUid: user.uid,
              creator: userProfile.username != "undefined"
                  ? userProfile.username
                  : userProfile.name,
              likes: 0,
              comments: 0,
              createdAt: DateTime.now().millisecondsSinceEpoch,
            ),
          );
          if (!context.mounted) return;
          if (state.hasError) {
            showFirebaseErrorSnack(context, state.error);
          } else {
            context.pop();
            context.pop();
          }
        }
      });
    }
  }
}

final uploadVideoProvider = AsyncNotifierProvider<UploadVideoViewModel, void>(
  () => UploadVideoViewModel(),
);
