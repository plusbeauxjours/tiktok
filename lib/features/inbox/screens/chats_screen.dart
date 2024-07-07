import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok/features/inbox/models/chat_room_model.dart';
import 'package:tiktok/features/inbox/screens/chat_detail_screen.dart';
import 'package:tiktok/features/inbox/screens/chat_user_list_screen.dart';
import 'package:tiktok/features/inbox/view_models/chat_room_view_model.dart';
import 'package:tiktok/features/user/view_models/user_view_model.dart';

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

  void _deleteItem(int index, AsyncSnapshot<List<ChatRoomModel>> snapshot) {}

  void _onChatRoomTap(index) {
    context.pushNamed(
      ChatDetailScreen.routeName,
      params: {"chatId": "$index"},
    );
  }

  ListTile _makeTile(int index, AsyncSnapshot<List<ChatRoomModel>> snapshot) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: Sizes.size10,
        horizontal: Sizes.size12,
      ),
      onLongPress: () => _deleteItem(index, snapshot),
      onTap: () => _onChatRoomTap(index),
      leading: CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
          "https://firebasestorage.googleapis.com/v0/b/tiktok-10313.appspot.com/o/avatars%2F${snapshot.data![index].personIdA}?alt=media&date=${DateTime.now().toString()}",
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
        snapshot.data![index].lastText,
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
            snapshot.data![index].personIdA == ref.read(userProvider).value!.uid
                ? snapshot.data![index].personIdB
                : snapshot.data![index].personIdA,
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
    print("⭐️");
    print("⭐️");

    print("🔥");
    Future<List<ChatRoomModel>> chatRoomList = ref
        .read(chatRoomsProvider.notifier)
        .getChatRoomList(ref.read(userProvider).value!.uid);
    print("🔥$chatRoomList");
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
          child: Text("to do: chatroom list11"),
        ));
  }
}
