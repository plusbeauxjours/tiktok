import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/inbox/view_models/messages_view_models.dart';
import 'package:tiktok/features/inbox/widgets/avatar_form.dart';
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
    _isThereMessage = text.isNotEmpty;
    setState(() {});
  }

  void _onSendPress(String text) {
    if (!_isThereMessage) return;
    final text = _editingController.text;
    ref.read(messagesProvider.notifier).sendMessage(text);
    _editingController.text = '';
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(messagesProvider).isLoading;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode(context, ref)
            ? Colors.grey.shade800
            : Colors.grey.shade100,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          leading: const AvatarForm(),
          title: Text(
            'plusbeauxjours (${widget.chatId})',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: const Text('Active now'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.flag,
                color: Theme.of(context).iconTheme.color,
                size: Sizes.size20,
              ),
              Gaps.h32,
              FaIcon(
                FontAwesomeIcons.ellipsis,
                color: Theme.of(context).iconTheme.color,
                size: Sizes.size20,
              )
            ],
          ),
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
              ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.size20,
                  horizontal: Sizes.size14,
                ),
                itemBuilder: (context, index) {
                  final isMine = index % 2 == 0;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: isMine
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(
                          Sizes.size14,
                        ),
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
                        child: const Text(
                          "This is a message!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Sizes.size16,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => Gaps.v10,
                itemCount: 10,
              ),
              Positioned(
                bottom: 0,
                width: getWinWidth(context),
                child: KeyboardVisibilityBuilder(
                  builder: (BuildContext context, bool isKeyboardVisible) {
                    return BottomAppBar(
                      notchMargin: 0,
                      height: Platform.isIOS
                          ? isKeyboardVisible
                              ? 85
                              : 120
                          : 85,
                      elevation: 0,
                      color: isDarkMode(context, ref)
                          ? Colors.grey.shade800
                          : Colors.grey.shade100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Sizes.size10,
                          horizontal: Sizes.size14,
                        ),
                        child: Row(
                          children: [
                            TextField(
                              controller: _editingController,
                              onChanged: _onMessageChanged,
                              onSubmitted: isLoading ? null : _onSendPress,
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
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width - 134,
                                ),
                                filled: true,
                                fillColor: isDarkMode(context, ref)
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade200,
                                suffixIcon: Container(
                                  width: Sizes.size20,
                                  alignment: Alignment.center,
                                  child: FaIcon(
                                    FontAwesomeIcons.faceSmile,
                                    color: isDarkMode(context, ref)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Gaps.h10,
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
                              onPressed: () => isLoading
                                  ? null
                                  : _onSendPress(_editingController.text),
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
