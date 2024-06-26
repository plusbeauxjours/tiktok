import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/authentications/repos/authentication_repo.dart';
import 'package:tiktok/features/authentications/view_models/signup_view_model.dart';
import 'package:tiktok/features/users/models/user_profile_models.dart';
import 'package:tiktok/features/users/repos/user_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _usersRepository;
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    _usersRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);
    if (_authenticationRepository.isLoggedIn) {
      final profile = await _usersRepository
          .findProfile(_authenticationRepository.user!.uid);
      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }

    return UserProfileModel.empty();
  }

  Future<void> createProfile(UserCredential userCredential) async {
    if (userCredential.user == null) {
      throw Exception("Account not created");
    }
    final form = ref.read(signUpForm.notifier).state;
    state = const AsyncValue.loading();
    final profile = UserProfileModel(
      email: userCredential.user!.email ?? "anon@anon.com",
      uid: userCredential.user!.uid,
      name: userCredential.user!.displayName ?? "Anon",
      bio: "udefined",
      link: "undefined",
      username: form['username'] ?? "undefined",
      birthday: form['birthday'] ?? "undefined",
      hasAvatar: false,
    );
    await _usersRepository.createProfile(profile);
    state = AsyncValue.data(profile);
  }

  Future<void> onAvatarUpload() async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));
    await _usersRepository.updateUser(state.value!.uid, {"hasAvatar": true});
  }

  Future<void> onUpdateUserBio(String bio) async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(bio: bio));
    await _usersRepository.updateUser(state.value!.uid, {"bio": bio});
  }

  Future<void> onUpdateUserLink(String link) async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(link: link));
    await _usersRepository.updateUser(state.value!.uid, {"link": link});
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
