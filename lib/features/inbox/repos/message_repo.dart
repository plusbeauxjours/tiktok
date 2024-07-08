import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/inbox/models/message_model.dart';

class MessageRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessage(String chatId, MessageModel message) async {
    await _db
        .collection("chat_rooms")
        .doc(chatId)
        .collection("messages")
        .add(message.toJson())
        .then((value) async => await value.update({
              "messageId": value.id,
            }));
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    await _db
        .collection("chat_rooms")
        .doc(chatId)
        .collection("messages")
        .doc(messageId)
        .update({"hasDeleted": true});
  }
}

final messageRepo = Provider(
  (ref) => MessageRepo(),
);
