import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/inbox/models/chat_room_model.dart';

class ChatRoomRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getUserList(String userId) async {
    return await _db
        .collection("users")
        .limit(20)
        .where("uid", isNotEqualTo: userId)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getChatRoomList(
      String userId) async {
    return _db
        .collection("chat_rooms")
        .where(Filter.or(
          Filter("personIdA", isEqualTo: userId),
          Filter("personIdB", isEqualTo: userId),
        ))
        .orderBy("createdAt", descending: true)
        .limit(20)
        .get();
  }

  Future<Map<String, dynamic>?> createChatRoom(ChatRoomModel chatRoom) async {
    await _db
        .collection("chat_rooms")
        .doc(chatRoom.chatId)
        .set(chatRoom.toJson());
    await _db
        .collection("users")
        .doc(chatRoom.personIdA)
        .collection("chat_rooms")
        .doc("${chatRoom.personIdA}___${chatRoom.personIdB}")
        .set(chatRoom.toJson());
    await _db
        .collection("users")
        .doc(chatRoom.personIdB)
        .collection("chat_rooms")
        .doc("${chatRoom.personIdA}___${chatRoom.personIdB}")
        .set(chatRoom.toJson());
    return null;
  }

  Future<Map<String, dynamic>?> findChatRoom(
      String userId, String targetUserId) async {
    _db.collection("chat_rooms").where(Filter.or(
          Filter("chatId", isEqualTo: "${userId}___$targetUserId"),
          Filter("chatId", isEqualTo: "${targetUserId}___$userId"),
        ));
    return null;
  }

  Future<void> updateChatRoom(String chatId, Map<String, dynamic> data) async {
    await _db.collection("chat_rooms").doc(chatId).update(data);
  }
}

final chatRoomRepo = Provider((ref) => ChatRoomRepository());
