import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iskolarsafe/api/accounts_api.dart';
import 'package:iskolarsafe/models/user_model.dart';

class AccountsProvider with ChangeNotifier {
  late AccountsAPI _accounts;
  late Stream<User?> _userStream;
  late AccountsStatus _authStatus;
  late User? _user;
  late bool _userInfoAvailable;

  Stream<User?> get stream => _userStream;

  User? get user => _user;
  Future<AppUserInfo?> get userInfo => _accounts.getUserInfo(_user);
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

  Future<void> updateProfile(Map<String, dynamic> userInfo) async {
    _userInfoAvailable = await _accounts.updateUserInfo(userInfo: userInfo);
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
    await _accounts.signOut();
    _authStatus = AccountsStatus.userNotLoggedIn;
    _user = null;
    GoogleSignIn().disconnect();
    notifyListeners();
  }
}
