import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/inbox/repos/chat_room_repo.dart';
import 'package:tiktok/features/users/models/user_profile_model.dart';
import 'package:tiktok/features/users/repos/user_repo.dart';

class CharRoomViewModel extends AsyncNotifier<void> {
  late final ChatRoomRepository _chatRoomRepo;
  late final UserRepository _userRepo;

  @override
  FutureOr<void> build() {
    _chatRoomRepo = ref.read(chatRoomRepo);
    _userRepo = ref.read(userRepo);
  }

  Future<List<UserProfileModel>> getUserList() async {
    final result = await _chatRoomRepo.getUserList();
    final users = result.docs.map((doc) {
      return UserProfileModel.fromJson(doc.data());
    });
    return users.toList();
  }
}

final chatRoomsProvider = AsyncNotifierProvider<CharRoomViewModel, void>(
  () => CharRoomViewModel(),
);
