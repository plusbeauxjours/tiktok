import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<void> _onAvatarTap(BuildContext context, WidgetRef ref) async {
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxHeight: 150,
      maxWidth: 150,
    );
    if (xfile != null) {
      final File file = File(xfile.path);
      if (!context.mounted) return;
      ref.read(avatarProvider.notifier).uploadAvatar(context, file);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(avatarProvider).isLoading;
    return GestureDetector(
      onTap: isLoading ? null : () => _onAvatarTap(context, ref),
      child: isLoading
          ? Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(),
            )
          : Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 50,
                foregroundImage: hasAvatar
                    ? NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/tiktok-10313.appspot.com/o/avatars%2F$uid?alt=media&date=${DateTime.now().toString()}")
                    : null,
                child: Text(name),
              ),
            ),
    );
  }
}
