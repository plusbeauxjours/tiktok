import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/inbox/models/chat_model.dart';

class ChatRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addChat(ChatModel chat) async {
    await _db.collection('chat_rooms').add(chat.toJson());
  }
}

final chatRepo = Provider(
  (ref) => ChatRepo(),
);
