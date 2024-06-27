import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/authentications/repos/authentication_repo.dart';
import 'package:tiktok/features/users/view_models/users_view_models.dart';
import 'package:tiktok/features/videos/models/video_model.dart';
import 'package:tiktok/features/videos/repos/videos_repo.dart';

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
    final userProfile = ref.read(usersProvider).value;
    if (userProfile != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final task = await _repository.uploadVideoFile(
          video,
          user!.uid,
        );
        if (task.metadata != null) {
          await _repository.saveVideo(VideoModel(
            title: data['title'],
            description: data['description'],
            fileUrl: await task.ref.getDownloadURL(),
            thumbnailUrl: "",
            creatorUid: user.uid,
            likes: 0,
            comments: 0,
            createdAt: DateTime.now().millisecondsSinceEpoch,
          ));
        }
      });
    }
  }
}

final uploadVideoProvider = AsyncNotifierProvider<UploadVideoViewModel, void>(
  () => UploadVideoViewModel(),
);
