import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}

final chatRoomRepo = Provider((ref) => ChatRoomRepository());
