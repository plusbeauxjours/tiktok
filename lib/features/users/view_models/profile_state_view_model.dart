import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileStateModel extends StateNotifier<Map<String, dynamic>> {
  ProfileStateModel() : super({'isEditMode': false});

  void toggleEditMode() {
    state = {...state, 'isEditMode': !state['isEditMode']};
  }
}

final editProvider =
    StateNotifierProvider<ProfileStateModel, Map<String, dynamic>>(
  (ref) => ProfileStateModel(),
);
