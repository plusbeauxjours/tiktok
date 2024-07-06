import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getUserList() async {
    return await _db.collection("users").limit(20).get();
  }
}

final chatRoomRepo = Provider((ref) => ChatRoomRepository());
