import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/breakpoints.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok/features/inbox/screens/chat_detail_screen.dart';
import 'package:tiktok/features/inbox/view_models/chat_room_view_model.dart';
import 'package:tiktok/features/user/models/user_profile_model.dart';
import 'package:tiktok/features/user/view_models/user_view_model.dart';

class ChatUserListScreen extends ConsumerStatefulWidget {
  static const String routeName = 'chatUserList';
  static const String routeURL = '/chatUserList';

  const ChatUserListScreen({super.key});

  @override
  ChatUserListScreenState createState() => ChatUserListScreenState();
}

class ChatUserListScreenState extends ConsumerState<ChatUserListScreen> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  final List<int> _items = [];

  final Duration duration = const Duration(milliseconds: 300);

  void _addItem() {
    if (_key.currentState != null) {
      _key.currentState!.insertItem(
        _items.length,
        duration: duration,
      );
      _items.add(_items.length);
    }
  }

  void _deleteItem(int index, AsyncSnapshot<List<UserProfileModel>> snapshot) {
    if (_key.currentState != null) {
      _key.currentState!.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: Container(
            color: Colors.red,
            child: _makeTile(index, snapshot),
          ),
        ),
        duration: duration,
      );
      _items.removeAt(index);
    }
  }

  void _onUserTap(index) {
    context.pushNamed(
      ChatDetailScreen.routeName,
      params: {"chatId": "$index"},
    );
  }

  ListTile _makeTile(
      int index, AsyncSnapshot<List<UserProfileModel>> snapshot) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: Sizes.size10,
        horizontal: Sizes.size12,
      ),
      onLongPress: () => _deleteItem(index, snapshot),
      onTap: () => _onUserTap(index),
      leading: CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
          "https://firebasestorage.googleapis.com/v0/b/tiktok-10313.appspot.com/o/avatars%2F${snapshot.data![index].uid}?alt=media&date=${DateTime.now().toString()}",
        ),
        child: Text(
          snapshot.data![index].name[0],
        ),
      ),
      trailing: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.size12,
        ),
        child: FaIcon(
          FontAwesomeIcons.paperPlane,
          size: Sizes.size20,
        ),
      ),
      subtitle: Text(
        snapshot.data![index].bio,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: Sizes.size14,
          color: Colors.grey,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            snapshot.data![index].name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size18,
            ),
          ),
          Gaps.h16,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<List<UserProfileModel>> userList = ref
        .read(chatRoomsProvider.notifier)
        .getUserList(ref.read(userProvider).value!.uid);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Direct messages'),
      ),
      body: FutureBuilder(
        future: userList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: Breakpoints.lg,
                ),
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    thickness: 0.5,
                    indent: Sizes.size12,
                    endIndent: Sizes.size12,
                    height: 0.5,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.size10,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        _makeTile(index, snapshot),
                      ],
                    );
                  },
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
