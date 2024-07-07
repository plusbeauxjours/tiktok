import 'package:flutter/material.dart';
import 'package:tiktok/common/widgets/web_container.dart';
import 'package:tiktok/constants/breakpoints.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/user/widgets/user_profile_body.dart';
import 'package:tiktok/features/user/widgets/user_profile_header.dart';
import 'package:tiktok/utils/utils.dart';

class UserInfo extends StatelessWidget {
  final String name;
  final String username;
  final bool hasAvatar;
  final String uid;
  final String bio;
  final String link;

  const UserInfo({
    super.key,
    required this.name,
    required this.username,
    required this.hasAvatar,
    required this.uid,
    required this.bio,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return isWebScreen(context)
        ? WebContainer(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size96,
            ),
            maxWidth: Breakpoints.md,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                UserProfileHeader(
                  name: name,
                  username: username,
                  hasAvatar: hasAvatar,
                  uid: uid,
                ),
                UserProfileBody(
                  bio: bio,
                  link: link,
                ),
              ],
            ),
          )
        : Column(
            children: [
              Gaps.v20,
              UserProfileHeader(
                name: name,
                username: username,
                hasAvatar: hasAvatar,
                uid: uid,
              ),
              Gaps.v14,
              UserProfileBody(
                bio: bio,
                link: link,
              ),
              Gaps.v20,
            ],
          );
  }
}
