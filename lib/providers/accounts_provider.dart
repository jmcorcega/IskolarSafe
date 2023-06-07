import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iskolarsafe/api/accounts_api.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/entries_provider.dart';
import 'package:provider/provider.dart';

class AccountsProvider with ChangeNotifier {
  late AccountsAPI _accounts;
  late Stream<User?> _userStream;
  late AccountsStatus _authStatus;
  late User? _user;
  late bool _userInfoAvailable;
  late IskolarInfo? _userInfo;

  // Getters
  Stream<User?> get stream => _userStream;
  Stream<QuerySnapshot> get students => _accounts.getAllUsers();
  Stream<QuerySnapshot> get quarantined => _accounts.getUsersUnderQuarantine();
  Stream<QuerySnapshot> get monitored => _accounts.getUsersUnderMonitoring();
  User? get user => _user;
  IskolarInfo? get userInfo => _userInfo;
  AccountsStatus get status => _authStatus;
  bool get editStatus => _userInfoAvailable;

  AccountsProvider() {
    _authStatus = AccountsStatus.unknown;
    _accounts = AccountsAPI();
    _userStream = _accounts.getUserStream();
    _user = _accounts.user;
    _userInfoAvailable = true;
    _fetchUserInfo();

    if (_user == null) {
      _authStatus = AccountsStatus.userNotLoggedIn;
      _userInfoAvailable = false;
    }
    notifyListeners();
  }

  _fetchUserInfo() async {
    _userInfo = await _accounts.getUserInfo(_user);
    if (_userInfo != null) {
      _authStatus = AccountsStatus.success;
    } else if (_user != null && _userInfo == null) {
      _authStatus = AccountsStatus.noInternetConnection;
    }
    notifyListeners();
  }

  fetchInfo() {
    _authStatus = AccountsStatus.unknown;
    notifyListeners();

    _accounts = AccountsAPI();
    _userStream = _accounts.getUserStream();
    _user = _accounts.user;
    _userInfoAvailable = true;
    _fetchUserInfo();

    if (_user == null) {
      _authStatus = AccountsStatus.userNotLoggedIn;
      _userInfoAvailable = false;
    }
    notifyListeners();
  }

  Future<void> signUp(BuildContext context, bool isGoogle,
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
    _userInfo = await _accounts.getUserInfo(_user);
    if (context.mounted) {
      context.read<HealthEntryProvider>().fetchEntries(context);
    }

    notifyListeners();
  }

  Future<void> updateType(IskolarInfo userInfo, IskolarType newType) async {
    await _accounts.updateUserType(IskolarInfo.toJson(userInfo), newType);
    notifyListeners();
  }

  Future<void> updateStatus(
      IskolarHealthStatus status, IskolarInfo user) async {
    await _accounts.updateHealthStatus(status, user);

    notifyListeners();
  }

  Future<void> updateProfile(
      {required Map<String, dynamic> userInfo, File? photo}) async {
    _userInfoAvailable =
        await _accounts.updateUserInfo(userInfo: userInfo, photoFile: photo);
    _user = _accounts.user;
    await _fetchUserInfo();
    notifyListeners();

    _userInfoAvailable = true;
  }

  Future<void> signInWithEmail(BuildContext context,
      {required String email, required String password}) async {
    _authStatus =
        await _accounts.signInWithEmail(email: email, password: password);

    // Fetch user information
    _user = _accounts.user;
    _userInfo = await _accounts.getUserInfo(_user);
    _userInfoAvailable = true;
    if (context.mounted && _userInfo != null) {
      context.read<HealthEntryProvider>().fetchEntries(context);
    }

    notifyListeners();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
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
      _userInfo = await _accounts.getUserInfo(_user);
      _userInfoAvailable = true;
      if (context.mounted && _userInfo != null) {
        context.read<HealthEntryProvider>().fetchEntries(context);
      }
    } catch (e) {
      _authStatus = AccountsStatus.unknown;
    }

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
    _userInfo = null;
    _userInfoAvailable = false;
    notifyListeners();
  }
}
