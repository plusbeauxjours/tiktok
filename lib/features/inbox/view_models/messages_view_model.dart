import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/authentications/repos/authentication_repo.dart';
import 'package:tiktok/features/inbox/models/message_model.dart';
import 'package:tiktok/features/inbox/repos/message_repo.dart';

class MessagesViewModel extends FamilyAsyncNotifier<void, String> {
  late final MessageRepo _repo;
  late final String _chatRoomId;

  @override
  FutureOr<void> build(String arg) {
    _chatRoomId = arg;
    _repo = ref.read(messageRepo);
  }

  Future<void> sendMessage(String text) async {
    final user = ref.read(authRepo).user;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final message = MessageModel(
        messageId: "",
        text: text,
        userId: user!.uid,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        hasDeleted: false,
      );
      await _repo.sendMessage(_chatRoomId, message);
    });
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    state = await AsyncValue.guard(() async {
      await _repo.deleteMessage(chatId, messageId);
    });
  }
}

final messagesProvider =
    AsyncNotifierProvider.family<MessagesViewModel, void, String>(
  () => MessagesViewModel(),
);

final chatProvider = StreamProvider.family
    .autoDispose<List<MessageModel>, String>((ref, chatRoomId) {
  final db = FirebaseFirestore.instance;

  return db
      .collection("chat_rooms")
      .doc(chatRoomId)
      .collection("messages")
      .orderBy("createdAt")
      .snapshots()
      .map((event) => event.docs
          .map((doc) => MessageModel.fromJson(doc.data()))
          .toList()
          .reversed
          .toList());
});
