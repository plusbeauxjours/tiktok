import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok/features/inbox/screens/chat_user_list_screen.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  static const String routeName = 'chats';
  static const String routeURL = '/chats';

  const ChatsScreen({super.key});

  @override
  ChatsScreenState createState() => ChatsScreenState();
}

class ChatsScreenState extends ConsumerState<ChatsScreen> {
  void _onIconTap() {
    context.pushNamed(
      ChatUserListScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 1,
            title: const Text('Direct messages'),
            actions: [
              Padding(
                  padding: const EdgeInsets.only(right: Sizes.size10),
                  child: IconButton(
                      onPressed: _onIconTap,
                      icon: const FaIcon(FontAwesomeIcons.userPlus))),
            ]),
        body: const Center(
          child: Text("to do: chatroom list"),
        ));
  }
}
