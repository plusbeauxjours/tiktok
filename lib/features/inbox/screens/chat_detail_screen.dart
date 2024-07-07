import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/authentications/repos/authentication_repo.dart';
import 'package:tiktok/features/inbox/view_models/messages_view_model.dart';
import 'package:tiktok/features/user/models/user_profile_model.dart';
import 'package:tiktok/features/user/view_models/user_view_model.dart';
import 'package:tiktok/utils/utils.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = 'chatDetail';
  static const String routeURL = ':chatId';

  final String chatId;
  const ChatDetailScreen({
    Key? key,
    required this.chatId,
  }) : super(key: key);

  @override
  ChatDetailScreenState createState() => ChatDetailScreenState();
}

class ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _editingController =
      TextEditingController(text: '');

  late bool _isThereMessage = _editingController.text.isNotEmpty;
  final bool isLoading = false;

  void _onMessageChanged(String text) {
    setState(() {
      _isThereMessage = text.isNotEmpty;
    });
  }

  void _onSendPress() {
    if (!_isThereMessage) return;
    final text = _editingController.text;
    ref.read(messagesProvider(widget.chatId).notifier).sendMessage(text);
    _editingController.clear();
    setState(() {
      _isThereMessage = false;
    });
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(messagesProvider(widget.chatId)).isLoading;
    final userId = ref.read(userProvider).value!.uid;
    final targetUserId =
        widget.chatId.split("___").firstWhere((id) => id != userId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode(context, ref)
            ? Colors.grey.shade800
            : Colors.grey.shade100,
        title: FutureBuilder<UserProfileModel>(
          future: ref.read(userProvider.notifier).findProfile(targetUserId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                horizontalTitleGap: Sizes.size8,
                leading: CircleAvatar(
                  radius: 24,
                  foregroundImage: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/tiktok-10313.appspot.com/o/avatars%2F$targetUserId?alt=media&date=${DateTime.now().toString()}",
                  ),
                  child: Text(
                    snapshot.data!.name[0],
                    style: const TextStyle(
                      fontSize: Sizes.size16,
                    ),
                  ),
                ),
                title: Text(
                  snapshot.data!.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Sizes.size14,
                  ),
                ),
              );
            } else {
              return const Text('Unknown');
            }
          },
        ),
      ),
      body: GestureDetector(
        onTap: () => focusout(context),
        child: Container(
          color: isDarkMode(context, ref)
              ? Colors.grey.shade700
              : Colors.grey.shade100,
          child: Stack(
            children: [
              ref.watch(chatProvider(widget.chatId)).when(
                    data: (data) {
                      return ListView.separated(
                        reverse: true,
                        padding: EdgeInsets.only(
                          top: Sizes.size20,
                          bottom: MediaQuery.of(context).padding.bottom +
                              Sizes.size96,
                          left: Sizes.size14,
                          right: Sizes.size14,
                        ),
                        itemBuilder: (context, index) {
                          final message = data[index];
                          final isMine =
                              message.userId == ref.watch(authRepo).user!.uid;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: isMine
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(Sizes.size14),
                                decoration: BoxDecoration(
                                  color: isMine
                                      ? Colors.blue
                                      : Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(
                                      Sizes.size20,
                                    ),
                                    topRight: const Radius.circular(
                                      Sizes.size20,
                                    ),
                                    bottomLeft: Radius.circular(
                                      isMine ? Sizes.size20 : Sizes.size5,
                                    ),
                                    bottomRight: Radius.circular(
                                      !isMine ? Sizes.size20 : Sizes.size5,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  message.text,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: Sizes.size16,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) => Gaps.v10,
                        itemCount: data.length,
                      );
                    },
                    error: (error, stackTrace) => Center(
                      child: Text(
                        error.toString(),
                      ),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              Positioned(
                bottom: 0,
                width: getWinWidth(context),
                child: KeyboardVisibilityBuilder(
                  builder: (BuildContext context, bool isKeyboardVisible) {
                    return BottomAppBar(
                      notchMargin: 0,
                      height: 85,
                      elevation: 0,
                      color: isDarkMode(context, ref)
                          ? Colors.grey.shade800
                          : Colors.grey.shade100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Sizes.size4,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _editingController,
                                onChanged: _onMessageChanged,
                                decoration: InputDecoration(
                                  hintText: 'Send a message...',
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: Sizes.size12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      Sizes.size20,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: isDarkMode(context, ref)
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade200,
                                ),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: _isThereMessage
                                    ? Theme.of(context).primaryColor
                                    : isDarkMode(context, ref)
                                        ? Colors.grey.shade700
                                        : Colors.grey.shade200,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(
                                  Sizes.size10,
                                ),
                              ),
                              onPressed:
                                  isLoading ? null : () => _onSendPress(),
                              child: FaIcon(
                                isLoading
                                    ? FontAwesomeIcons.hourglass
                                    : FontAwesomeIcons.solidPaperPlane,
                                color: Colors.white,
                                size: Sizes.size20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
