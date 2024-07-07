import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/breakpoints.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok/features/inbox/models/chat_room_model.dart';
import 'package:tiktok/features/inbox/screens/chat_detail_screen.dart';
import 'package:tiktok/features/inbox/screens/chat_user_list_screen.dart';
import 'package:tiktok/features/inbox/view_models/chat_room_view_model.dart';
import 'package:tiktok/features/user/models/user_profile_model.dart';
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
    final userId = ref.read(userProvider).value!.uid;
    final targetUserId = snapshot.data![index].personIdA == userId
        ? snapshot.data![index].personIdB
        : snapshot.data![index].personIdA;
    final Future<UserProfileModel> targetUserProfile =
        ref.read(userProvider.notifier).findProfile(targetUserId);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: Sizes.size10,
        horizontal: Sizes.size12,
      ),
      onLongPress: () => _deleteItem(index, snapshot),
      onTap: () => _onChatRoomTap(index),
      leading: SizedBox(
        width: 50,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 20,
              foregroundImage: NetworkImage(
                "https://firebasestorage.googleapis.com/v0/b/tiktok-10313.appspot.com/o/avatars%2F$targetUserId?alt=media&date=${DateTime.now().toString()}",
              ),
            ),
            Positioned(
              right: -5,
              bottom: -15,
              child: CircleAvatar(
                radius: 20,
                foregroundImage: NetworkImage(
                  "https://firebasestorage.googleapis.com/v0/b/tiktok-10313.appspot.com/o/avatars%2F$userId?alt=media&date=${DateTime.now().toString()}",
                ),
              ),
            )
          ],
        ),
      ),
      trailing: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.size12,
        ),
        child: FaIcon(
          FontAwesomeIcons.chevronRight,
          size: Sizes.size20,
        ),
      ),
      subtitle: Text(
        snapshot.data![index].lastText,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: Sizes.size10,
          color: Colors.grey,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FutureBuilder<UserProfileModel>(
            future: targetUserProfile,
            builder: (context, profileSnapshot) {
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (profileSnapshot.hasData) {
                return Text(
                  profileSnapshot.data!.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Sizes.size18,
                  ),
                );
              } else {
                return const Text('Unknown');
              }
            },
          ),
          Gaps.h16,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<List<ChatRoomModel>> chatRoomList = ref
        .read(chatRoomsProvider.notifier)
        .getChatRoomList(ref.read(userProvider).value!.uid);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Direct messages'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: Sizes.size10,
            ),
            child: IconButton(
              iconSize: Sizes.size20,
              onPressed: _onIconTap,
              icon: const FaIcon(FontAwesomeIcons.userPlus),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: chatRoomList,
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
