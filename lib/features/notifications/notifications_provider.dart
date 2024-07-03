import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/authentications/repos/authentication_repo.dart';

class NotificationsProvider extends AsyncNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  FutureOr build() async {
    final token = await _messaging.getToken();
    if (token == null) return;
    await updateToken(token);
    _messaging.onTokenRefresh.listen((newToken) async {
      await updateToken(newToken);
    });
  }

  Future<void> updateToken(String token) async {
    final user = ref.read(authRepo).user;
    await _db.collection('users').doc(user!.uid).update({'token': token});
  }
}

final notificationsProvider = AsyncNotifierProvider(
  () => NotificationsProvider(),
);
