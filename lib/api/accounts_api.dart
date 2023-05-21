import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:iskolarsafe/models/user_model.dart';

enum FirebaseAuthStatus {
  success,
  wrongPassword,
  userNotFound,
  weakPassword,
  userAlreadyExist,
  unknown,
  userNotLoggedIn,
  needsSignUp
}

class AccountsAPI {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _storeName = "users";

  static User? _user;
  User? get user => _user;

  static Future<AppUserInfo?>? _userInfo;
  Future<AppUserInfo?>? get userInfo => _userInfo;

  Stream<User?> getUserStream() {
    _user = _auth.currentUser;
    _userInfo = getUserInfo();
    return _auth.authStateChanges();
  }

  Future<AppUserInfo?> _getUserInfo(User? user) async {
    try {
      var info = await _db.collection(_storeName).doc(user!.uid).get();

      Map<String, dynamic>? data = info.data();
      return AppUserInfo.fromJson(data!);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<AppUserInfo?> getUserInfo() async {
    return _getUserInfo(_auth.currentUser);
  }

  Future<FirebaseAuthStatus> signInWithGoogle(OAuthCredential auth) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithCredential(auth);

      _user = credential.user;

      // Get extra user information
      _userInfo = _getUserInfo(credential.user);

      if (_userInfo == null) {
        return FirebaseAuthStatus.needsSignUp;
      }

      // Return success
      return FirebaseAuthStatus.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return FirebaseAuthStatus.userNotFound;
      } else if (e.code == 'wrong-password') {
        return FirebaseAuthStatus.wrongPassword;
      }
    } catch (e) {
      return FirebaseAuthStatus.unknown;
    }

    return FirebaseAuthStatus.unknown;
  }

  Future<FirebaseAuthStatus> signInWithEmail(
      {required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      _user = credential.user;

      // Get extra user information
      _userInfo = _getUserInfo(credential.user);

      if (await _userInfo == null) {
        return FirebaseAuthStatus.needsSignUp;
      }

      // Return success
      return FirebaseAuthStatus.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return FirebaseAuthStatus.userNotFound;
      } else if (e.code == 'wrong-password') {
        return FirebaseAuthStatus.wrongPassword;
      }
    } catch (e) {
      return FirebaseAuthStatus.unknown;
    }

    return FirebaseAuthStatus.unknown;
  }

  Future<FirebaseAuthStatus> signUp(
      {required String email,
      required String password,
      required Map<String, dynamic> userInfo}) async {
    UserCredential credential;
    try {
      if (_user == null) {
        credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Get user UID for use later
        _user = credential.user;
      }

      // Add new user to the database
      await _db.collection(_storeName).doc(_user?.uid).set(userInfo);
      await _db
          .collection(_storeName)
          .doc(_user?.uid)
          .update({"id": _user?.uid});

      _user?.updateDisplayName(
          "${userInfo['firstName']} ${userInfo['lastName']}");

      _userInfo = getUserInfo();

      // Return success
      return FirebaseAuthStatus.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return FirebaseAuthStatus.weakPassword;
      } else if (e.code == 'email-already-in-use') {
        return FirebaseAuthStatus.userAlreadyExist;
      }
    } catch (e) {
      return FirebaseAuthStatus.unknown;
    }

    return FirebaseAuthStatus.unknown;
  }

  Future<void> signOut() async {
    _user = null;
    _userInfo = null;
    await _auth.signOut();
  }
}
