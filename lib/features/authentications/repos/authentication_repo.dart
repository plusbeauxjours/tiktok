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

  Future<UserCredential> emailSignUp(
      String email, String password, BuildContext context) async {
    try {
      final userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .catchError((err) {
        showFirebaseErrorSnack(context, err);
        throw err;
      });
      return userCredential;
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

  Future<UserCredential?> githubSignIn(BuildContext context) async {
    try {
      GithubAuthProvider githubProvider = GithubAuthProvider();

      final userCredential = await FirebaseAuth.instance
          .signInWithProvider(githubProvider)
          .catchError((err) {
        showFirebaseErrorSnack(context, err);
        throw err;
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        if (e.code == 'account-exists-with-different-credential') {
          showFirebaseErrorSnack(context,
              'The account already exists with a different credential.');
        } else if (e.code == 'invalid-credential') {
          showFirebaseErrorSnack(
            context,
            'Error occurred while accessing credentials. Try again.',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        showFirebaseErrorSnack(
          context,
          'Error occurred using Google Sign-In. Try again.',
        );
      }
    }
    return null;
  }

  Future<UserCredential?> googleSignIn(BuildContext context) async {
    try {
      final googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/userinfo.email',
        ],
      );
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential)
          .catchError((err) {
        showFirebaseErrorSnack(context, err);
        throw err;
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        if (e.code == 'account-exists-with-different-credential') {
          showFirebaseErrorSnack(context,
              'The account already exists with a different credential.');
        } else if (e.code == 'invalid-credential') {
          showFirebaseErrorSnack(
            context,
            'Error occurred while accessing credentials. Try again.',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        showFirebaseErrorSnack(
          context,
          'Error occurred using Google Sign-In. Try again.',
        );
      }
    }
    return null;
  }
}

final authRepo = Provider((ref) => AuthenticationRepository());

final authState = StreamProvider((ref) {
  final repo = ref.read(authRepo);
  return repo.authStateChanges();
});
