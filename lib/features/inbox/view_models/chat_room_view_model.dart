import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/inbox/models/chat_room_model.dart';
import 'package:tiktok/features/inbox/repos/chat_room_repo.dart';
import 'package:tiktok/features/user/models/user_profile_model.dart';
import 'package:tiktok/features/user/repos/user_repo.dart';

class CharRoomViewModel extends AsyncNotifier<void> {
  late final ChatRoomRepository _chatRoomRepo;
  late final UserRepository _userRepo;

  @override
  FutureOr<void> build() {
    _chatRoomRepo = ref.read(chatRoomRepo);
    _userRepo = ref.read(userRepo);
  }

  Future<List<UserProfileModel>> getUserList(String userId) async {
    final result = await _chatRoomRepo.getUserList(userId);
    final users = result.docs.map((doc) {
      return UserProfileModel.fromJson(doc.data());
    });
    return users.toList();
  }

  Future<List<ChatRoomModel>> getChatRoomList(String userId) async {
    final result = await _chatRoomRepo.getChatRoomList(userId);
    final chatRooms = result.docs.map((doc) {
      return ChatRoomModel.fromJson(doc.data());
    });
    return chatRooms.toList();
  }
}

final chatRoomsProvider = AsyncNotifierProvider<CharRoomViewModel, void>(
  () => CharRoomViewModel(),
);
