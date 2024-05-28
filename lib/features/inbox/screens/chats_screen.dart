import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/rawData/foreground_image.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok/features/inbox/screens/chat_detail_screen.dart';

class ChatsScreen extends StatefulWidget {
  static const String routeName = 'chats';
  static const String routeURL = '/chats';

  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
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

  void _deleteItem(int index) {
    if (_key.currentState != null) {
      _key.currentState!.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: Container(
            color: Colors.red,
            child: _makeTile(
              index,
            ),
          ),
        ),
        duration: duration,
      );
      _items.removeAt(index);
    }
  }

  void _onChatTap(index) {
    context.pushNamed(ChatDetailScreen.routeName, params: {"chatId": "$index"});
  }

  ListTile _makeTile(int index) {
    return ListTile(
      onLongPress: () => _deleteItem(index),
      onTap: () => _onChatTap(index),
      leading: const CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(foregroundImage),
        child: Text('plusbeauxjours'),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            "hannah",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "5:12 PM",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: Sizes.size12,
            ),
          ),
        ],
      ),
      subtitle: const Text("Let's having fun things!"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Direct messages'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const FaIcon(FontAwesomeIcons.plus),
          ),
        ],
      ),
      body: AnimatedList(
        key: _key,
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size10,
        ),
        itemBuilder: (context, index, animation) {
          return FadeTransition(
            key: Key('$index'),
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              child: _makeTile(index),
            ),
          );
        },
      ),
    );
  }
}
