import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tiktok/utils/utils.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool get isLoggedIn => user != null;
  User? get user => _firebaseAuth.currentUser;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<void> emailSignUp(
      String email, String password, BuildContext context) async {
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .catchError((err) {
        showFirebaseErrorSnack(context, err);
        throw err;
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _firebaseAuth.signOut().catchError((err) {
        showFirebaseErrorSnack(context, err);
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      await _firebaseAuth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .catchError((err) {
        showFirebaseErrorSnack(context, err);
        throw err;
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> githubSignIn(BuildContext context) async {
    try {
      GithubAuthProvider githubProvider = GithubAuthProvider();

      await FirebaseAuth.instance
          .signInWithProvider(githubProvider)
          .catchError((err) {
        showFirebaseErrorSnack(context, err);
        throw err;
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> googleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .catchError((err) {
        showFirebaseErrorSnack(context, err);
        throw err;
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}

final authRepo = Provider((ref) => AuthenticationRepository());

final authState = StreamProvider((ref) {
  final repo = ref.read(authRepo);
  return repo.authStateChanges();
});
