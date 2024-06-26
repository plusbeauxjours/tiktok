import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/users/widgets/avatar.dart';

class UserProfileHeader extends StatelessWidget {
  final String name;
  final String username;
  final bool hasAvatar;
  final String uid;

  const UserProfileHeader({
    super.key,
    required this.name,
    required this.username,
    required this.hasAvatar,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Avatar(
          name: username != "undefined" ? username : name,
          hasAvatar: hasAvatar,
          uid: uid,
        ),
        Gaps.v20,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              username != "undefined" ? '@$username' : '@$name',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Sizes.size18,
              ),
            ),
            Gaps.h5,
            FaIcon(
              FontAwesomeIcons.solidCircleCheck,
              color: Colors.blue.shade500,
              size: Sizes.size16,
            ),
          ],
        ),
        Gaps.v24,
        SizedBox(
          height: Sizes.size52 + 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    '37',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Sizes.size18,
                    ),
                  ),
                  Gaps.v3,
                  Text(
                    'Following',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              VerticalDivider(
                color: Colors.grey.shade400,
                thickness: Sizes.size1,
                width: Sizes.size32,
                indent: Sizes.size14,
                endIndent: Sizes.size14,
              ),
              Column(
                children: [
                  const Text(
                    '10.5M',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Sizes.size18,
                    ),
                  ),
                  Gaps.v3,
                  Text(
                    'Followers',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              VerticalDivider(
                color: Colors.grey.shade400,
                thickness: Sizes.size1,
                width: Sizes.size32,
                indent: Sizes.size14,
                endIndent: Sizes.size14,
              ),
              Column(
                children: [
                  const Text(
                    '149.3M',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Sizes.size18,
                    ),
                  ),
                  Gaps.v3,
                  Text(
                    'Likes',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
