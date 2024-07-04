import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/users/widgets/avatar.dart';

class UserProfileHeader extends StatelessWidget {
  static const double _fontSize = Sizes.size18;
  static const double _iconSize = Sizes.size16;
  static const double _dividerThickness = Sizes.size1;
  static const double _dividerWidth = Sizes.size32;
  static const double _dividerIndent = Sizes.size14;

  final String name;
  final String username;
  final bool hasAvatar;
  final String uid;

  const UserProfileHeader({
    Key? key,
    required this.name,
    required this.username,
    required this.hasAvatar,
    required this.uid,
  }) : super(key: key);

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
        _buildUsernameRow(),
        Gaps.v24,
        SizedBox(
          height: Sizes.size52 + 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatColumn('37', 'Following'),
              _buildVerticalDivider(),
              _buildStatColumn('10.5M', 'Followers'),
              _buildVerticalDivider(),
              _buildStatColumn('149.3M', 'Likes'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          username != "undefined" ? '@$username' : '@$name',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: _fontSize,
          ),
        ),
        Gaps.h5,
        FaIcon(
          FontAwesomeIcons.solidCircleCheck,
          color: Colors.blue.shade500,
          size: _iconSize,
        ),
      ],
    );
  }

  Widget _buildStatColumn(String count, String text) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _fontSize,
          ),
        ),
        Gaps.v3,
        Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return VerticalDivider(
      color: Colors.grey.shade400,
      thickness: _dividerThickness,
      width: _dividerWidth,
      indent: _dividerIndent,
      endIndent: _dividerIndent,
    );
  }
}
