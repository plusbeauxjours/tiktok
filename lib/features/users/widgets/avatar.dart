import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok/constants/rawData/foreground_image.dart';
import 'package:tiktok/features/users/view_models/avatar_view_model.dart';

class Avatar extends ConsumerWidget {
  final String uid;
  final String name;
  final bool hasAvatar;

  const Avatar({
    super.key,
    required this.uid,
    required this.name,
    required this.hasAvatar,
  });

  Future<void> _onAvatarTap(WidgetRef ref) async {
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxHeight: 150,
      maxWidth: 150,
    );
    if (xfile != null) {
      final file = File(xfile.path);
      await ref.read(avatarProvider.notifier).uploadAvatar(file);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(avatarProvider).isLoading;
    return GestureDetector(
      onTap: isLoading ? null : () => _onAvatarTap(ref),
      child: isLoading
          ? Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(),
            )
          : CircleAvatar(
              radius: 50,
              foregroundImage: const NetworkImage(foregroundImage),
              child: Text(name),
            ),
    );
  }
}
