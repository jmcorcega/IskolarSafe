import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:iskolarsafe/models/user_model.dart';

enum AccountsStatus {
  success,
  wrongPassword,
  userNotFound,
  weakPassword,
  userAlreadyExist,
  unknown,
  userNotLoggedIn,
  needsSignUp,
  loggingOut,
  noInternetConnection,
}

class AccountsAPI {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static const String _storeName = "users";

  static User? _user;
  User? get user => _user;

  static IskolarInfo? _userInfo;
  IskolarInfo? get userInfo => _userInfo;

  Stream<User?> getUserStream() {
    _user = _auth.currentUser;
    return _auth.authStateChanges();
  }

  Future<IskolarInfo?> getUserInfo(User? user) async {
    try {
      _db.settings = _db.settings.copyWith(
        persistenceEnabled: false,
      );

      var info = await _db.collection(_storeName).doc(user!.uid).get();

      Map<String, dynamic>? data = info.data();
      return IskolarInfo.fromJson(data!);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  // Gets all data from collection("users")
  Stream<QuerySnapshot> getAllUsers() {
    return _db.collection(_storeName).snapshots();
  }

  Stream<QuerySnapshot> getUsersUnderQuarantine() {
    return _db
        .collection(_storeName)
        .where("status", isEqualTo: "quarantined")
        .snapshots();
  }

  Stream<QuerySnapshot> getUsersUnderMonitoring() {
    return _db
        .collection(_storeName)
        .where("status", isEqualTo: "monitored")
        .snapshots();
  }

  //update users' health status
  Future<bool> updateHealthStatus(
      IskolarHealthStatus status, IskolarInfo user) async {
    try {
      int dateQuarantined = 0;
      int dateMonitored = 0;

      switch (status) {
        case IskolarHealthStatus.quarantined:
          dateQuarantined =
              Timestamp.fromDate(DateTime.now()).millisecondsSinceEpoch;
          break;
        case IskolarHealthStatus.monitored:
          dateMonitored =
              Timestamp.fromDate(DateTime.now()).millisecondsSinceEpoch;
          break;
        default:
          break;
      }

      await _db.collection(_storeName).doc(user.id).update({
        "status": IskolarHealthStatus.toJson(status),
        "dateQuarantined": dateQuarantined,
        "dateMonitored": dateMonitored,
      });
      return true;
    } on FirebaseException catch (e) {
      // print("${e.code} : ${e.message} ");
      return false;
    }
  }

  Future<bool> updateUserType(
      Map<String, dynamic> userInfo, IskolarType type) async {
    try {
      userInfo["type"] = IskolarType.toJson(type);
      await _db.collection(_storeName).doc(userInfo["id"]).update(userInfo);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserInfo(
      {required Map<String, dynamic> userInfo, File? photoFile}) async {
    try {
      final profileRef =
          _storage.ref().child("users/${_user!.uid}/profile.png");

      // Update information to database
      await _db.collection(_storeName).doc(user!.uid).update(userInfo);

      // Update display name as well
      _user?.updateDisplayName(
          "${userInfo['firstName']} ${userInfo['lastName']}");

      if (photoFile != null) {
        // Update information to database
        await profileRef.putFile(photoFile);

        var url = await profileRef.getDownloadURL();
        _user?.updatePhotoURL(url);
        await _db
            .collection(_storeName)
            .doc(user!.uid)
            .update({"photoUrl": url});

        _user?.updatePhotoURL(url);
      }

      // Update current user information
      await Future.delayed(const Duration(seconds: 3));
      _user = _auth.currentUser;

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<AccountsStatus> signInWithGoogle(OAuthCredential auth) async {
    try {
      final credential = await _auth.signInWithCredential(auth);

      _user = credential.user;

      // Get extra user information
      _userInfo = await getUserInfo(credential.user);
      if (_userInfo == null) {
        return AccountsStatus.needsSignUp;
      }

      // Update first and last name from added userInfo by user as necessary
      _user
          ?.updateDisplayName("${_userInfo!.firstName} ${_userInfo!.lastName}");

      // Update photoURL in database if there is none
      if (_userInfo!.photoUrl == null) {
        await _db
            .collection(_storeName)
            .doc(_user?.uid)
            .update({"photoUrl": _user?.photoURL});
      }

      // Return success
      return AccountsStatus.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return AccountsStatus.userNotFound;
      } else if (e.code == 'wrong-password') {
        return AccountsStatus.wrongPassword;
      }
    } catch (e) {
      return AccountsStatus.unknown;
    }

    return AccountsStatus.unknown;
  }

  Future<AccountsStatus> signInWithEmail(
      {required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      _user = credential.user;

      // Get extra user information
      _userInfo = await getUserInfo(credential.user);

      // Return success
      return AccountsStatus.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return AccountsStatus.userNotFound;
      } else if (e.code == 'wrong-password') {
        return AccountsStatus.wrongPassword;
      }
    } catch (e) {
      return AccountsStatus.unknown;
    }

    return AccountsStatus.unknown;
  }

  Future<AccountsStatus> signUp(
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

      await Future.delayed(const Duration(seconds: 1));
      _user?.updateDisplayName(
          "${userInfo['firstName']} ${userInfo['lastName']}");

      _userInfo = await getUserInfo(_user);
      await Future.delayed(const Duration(seconds: 2));

      // Update photoURL in database if there is none
      if (_userInfo!.photoUrl == null) {
        await _db
            .collection(_storeName)
            .doc(_user?.uid)
            .update({"photoUrl": _user?.photoURL});
      }

      // Return success
      return AccountsStatus.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return AccountsStatus.weakPassword;
      } else if (e.code == 'email-already-in-use' ||
          e.code == 'account-exists-with-different-credential') {
        return AccountsStatus.userAlreadyExist;
      }
    } catch (e) {
      return AccountsStatus.unknown;
    }

    return AccountsStatus.unknown;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _userInfo = null;
  }
}
