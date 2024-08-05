import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok/constants/breakpoints.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
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
  final Duration _duration = const Duration(milliseconds: 300);

  // 아이템 추가 메서드
  void _addItem() {
    if (_key.currentState != null) {
      _key.currentState!.insertItem(
        _items.length,
        duration: _duration,
      );
      _items.add(_items.length);
    }
  }

  // 아이템 삭제 메서드
  void _deleteItem(int index, AsyncSnapshot<List<UserProfileModel>> snapshot) {
    if (_key.currentState != null) {
      _key.currentState!.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: Container(
            color: Colors.red,
            child: _buildListTile(index, snapshot),
          ),
        ),
        duration: _duration,
      );
      _items.removeAt(index);
    }
  }

  // 사용자 탭 처리 메서드
  Future<void> _onUserTap(
    int index,
    AsyncSnapshot<List<UserProfileModel>> snapshot,
  ) async {
    final chatRoomNotifier = ref.read(chatRoomsProvider.notifier);
    final personIdA = ref.read(userProvider).value!.uid;
    final personIdB = snapshot.data![index].uid;

    var chatRoomId = await chatRoomNotifier.findChatRoom(personIdA, personIdB);
    chatRoomId ??= await chatRoomNotifier.createChatRoom(personIdA, personIdB);

    if (!mounted) return;
    context.pushNamed(
      ChatDetailScreen.routeName,
      params: {"chatId": chatRoomId.chatId},
    );
  }

  // ListTile 위젯 생성 메서드
  ListTile _buildListTile(
      int index, AsyncSnapshot<List<UserProfileModel>> snapshot) {
    final user = snapshot.data![index];
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: Sizes.size10,
        horizontal: Sizes.size12,
      ),
      onLongPress: () => _deleteItem(index, snapshot),
      onTap: () => _onUserTap(index, snapshot),
      leading: _buildAvatar(user),
      trailing: _buildTrailingIcon(),
      subtitle: _buildSubtitle(user),
      title: _buildTitle(user),
    );
  }

  // 아바타 위젯 생성 메서드
  Widget _buildAvatar(UserProfileModel user) {
    return CircleAvatar(
      radius: 30,
      foregroundImage: NetworkImage(
        "https://firebasestorage.googleapis.com/v0/b/tiktok-10313.appspot.com/o/avatars%2F${user.uid}?alt=media&date=${DateTime.now().toString()}",
      ),
      child: Text(user.name[0]),
    );
  }

  // 트레일링 아이콘 위젯 생성 메서드
  Widget _buildTrailingIcon() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.size12,
      ),
      child: FaIcon(
        FontAwesomeIcons.paperPlane,
        size: Sizes.size20,
      ),
    );
  }

  // 서브타이틀 위젯 생성 메서드
  Widget _buildSubtitle(UserProfileModel user) {
    return Text(
      user.bio,
      style: const TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: Sizes.size14,
        color: Colors.grey,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  // 타이틀 위젯 생성 메서드
  Widget _buildTitle(UserProfileModel user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          user.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: Sizes.size18,
          ),
        ),
        Gaps.h16,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Direct messages'),
      ),
      body: FutureBuilder<List<UserProfileModel>>(
        future: ref
            .read(chatRoomsProvider.notifier)
            .getUserList(ref.read(userProvider).value!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildUserList(snapshot);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  // 사용자 목록 위젯 생성 메서드
  Widget _buildUserList(AsyncSnapshot<List<UserProfileModel>> snapshot) {
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
          itemBuilder: (context, index) => _buildListTile(index, snapshot),
        ),
      ),
    );
  }
}
