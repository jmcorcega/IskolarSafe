import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iskolarsafe/api/accounts_api.dart';
import 'package:iskolarsafe/models/user_model.dart';

class AccountsProvider with ChangeNotifier {
  late AccountsAPI _accounts;
  late Stream<User?> _userStream;
  late Stream<QuerySnapshot> _studentStream;
  late AccountsStatus _authStatus;
  late User? _user;
  late bool _userInfoAvailable;
  late IskolarInfo? _userInfo;

  // Getters
  Stream<User?> get stream => _userStream;
  Stream<QuerySnapshot> get students => _studentStream;
  User? get user => _user;
  Future<IskolarInfo?> get userInfo => _accounts.getUserInfo(_user);
  AccountsStatus get status => _authStatus;
  bool get editStatus => _userInfoAvailable;

  AccountsProvider() {
    _authStatus = AccountsStatus.unknown;
    _accounts = AccountsAPI();
    _userStream = _accounts.getUserStream();
    _user = _accounts.user;
    if (_user != null) {
      _authStatus = AccountsStatus.success;
    }
    _userInfoAvailable = true;
    fetchStudents();
  }

  fetchStudents() async {
    _studentStream = _accounts.getAllUsersFromStore();
    notifyListeners();
  }

  Future<void> refetchStudents() async {
    await fetchStudents();
    notifyListeners();
  }

  Future<void> signUp(bool isGoogle,
      {required String email,
      required String password,
      required Map<String, dynamic> userInfo}) async {
    _authStatus = await _accounts.signUp(
        email: email, password: password, userInfo: userInfo);

    // Sign in
    if (!isGoogle && _authStatus == AccountsStatus.success) {
      _authStatus =
          await _accounts.signInWithEmail(email: email, password: password);
    }

    // Fetch user information
    _userStream = _accounts.getUserStream();
    _user = _accounts.user;

    notifyListeners();
  }

  Future<void> updateType(
      Map<String, dynamic> currentInfo, IskolarType type, String uID) async {
    _accounts.updateUserType(currentInfo, type, uID);
    notifyListeners();
  }

  Future<void> updateStatus(IskolarHealthStatus status, String uID) async {
    String stat = IskolarHealthStatus.toJson(status);

    _accounts.updateHealthStatus(stat, uID);

    notifyListeners();
  }

  Future<void> updateProfile(
      {required Map<String, dynamic> userInfo, File? photo}) async {
    _userInfoAvailable =
        await _accounts.updateUserInfo(userInfo: userInfo, photoFile: photo);
    _user = _accounts.user;
    notifyListeners();

    _userInfoAvailable = true;
  }

  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    _authStatus =
        await _accounts.signInWithEmail(email: email, password: password);

    // Fetch user information
    _user = _accounts.user;

    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    // Start the sign-in process
    GoogleSignInAccount? credentials = await GoogleSignIn().signIn();
    if (credentials == null) {
      _authStatus = AccountsStatus.unknown;
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication token = await credentials.authentication;

    // Create a new credential
    final OAuthCredential auth = GoogleAuthProvider.credential(
      accessToken: token.accessToken,
      idToken: token.idToken,
    );

    // Once signed in, return the UserCredential
    _authStatus = await _accounts.signInWithGoogle(auth);

    // Fetch user information
    _user = _accounts.user;

    notifyListeners();
  }

  Future<void> signOut() async {
    _authStatus = AccountsStatus.loggingOut;
    notifyListeners();

    await _accounts.signOut();
    await Future.delayed(const Duration(seconds: 3));

    try {
      await GoogleSignIn().disconnect();
      // ignore: empty_catches
    } catch (e) {}

    _authStatus = AccountsStatus.userNotLoggedIn;
    _user = null;
    notifyListeners();
  }
}
