import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/inbox/screens/activity_screen.dart';
import 'package:tiktok/features/inbox/screens/chats_screen.dart';
import 'package:tiktok/utils/utils.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  void _onDmPressed(BuildContext context) {
    navPush(context, const ChatsScreen());
  }

  void _onActivityTap(BuildContext context) {
    navPush(context, const ActivityScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListView(
        children: [
          _buildActivityTile(context),
          _buildDivider(),
          _buildNewFollowersTile(),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 1,
      title: const Text('Inbox'),
      actions: [
        IconButton(
          onPressed: () => _onDmPressed(context),
          icon: const FaIcon(
            FontAwesomeIcons.message,
            size: Sizes.size20,
          ),
        ),
      ],
    );
  }

  ListTile _buildActivityTile(BuildContext context) {
    return ListTile(
      onTap: () => _onActivityTap(context),
      title: const Text(
        'Activity',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: Sizes.size16,
        ),
      ),
      trailing: const FaIcon(
        FontAwesomeIcons.chevronRight,
        size: Sizes.size14,
        color: Colors.black,
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      height: Sizes.size1,
      color: Colors.grey.shade200,
    );
  }

  ListTile _buildNewFollowersTile() {
    return ListTile(
      leading: Container(
        width: Sizes.size52,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
        child: const Center(
          child: FaIcon(
            FontAwesomeIcons.users,
            color: Colors.white,
          ),
        ),
      ),
      title: const Text(
        'New followers',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: Sizes.size16,
        ),
      ),
      subtitle: const Text(
        'Messages from followers will appear here.',
        style: TextStyle(
          fontSize: Sizes.size14,
        ),
      ),
      trailing: const FaIcon(
        FontAwesomeIcons.chevronRight,
        size: Sizes.size14,
        color: Colors.black,
      ),
    );
  }
}
