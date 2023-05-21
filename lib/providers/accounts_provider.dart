import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iskolarsafe/api/accounts_api.dart';
import 'package:iskolarsafe/models/user_model.dart';

class AccountsProvider with ChangeNotifier {
  late AccountsAPI _accounts;
  late Stream<User?> _userStream;
  late FirebaseAuthStatus _authStatus;
  late User? _user;
  late Future<AppUserInfo?>? _userInfo;

  Stream<User?> get stream => _userStream;
  String _type = "none";

  User? get user => _user;
  String get type => _type;
  Future<AppUserInfo?>? get userInfo => _userInfo;
  FirebaseAuthStatus get status => _authStatus;

  AccountsProvider() {
    _accounts = AccountsAPI();
    _userStream = _accounts.getUserStream();
    _user = _accounts.user;
    _userInfo = _accounts.userInfo;
    notifyListeners();
  }

  Future<void> signUp(
      {required String email,
      required String password,
      required Map<String, dynamic> userInfo}) async {
    _authStatus = await _accounts.signUp(
        email: email, password: password, userInfo: userInfo);

    // Fetch user information
    _user = _accounts.user;
    _userInfo = _accounts.userInfo;
    _type = "new";

    notifyListeners();
  }

  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    _authStatus =
        await _accounts.signInWithEmail(email: email, password: password);

    // Fetch user information
    _user = _accounts.user;
    _userInfo = _accounts.userInfo;
    _type = "email";

    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    // Start the sign-in process
    GoogleSignInAccount? credentials = await GoogleSignIn().signIn();
    if (credentials == null) {
      _authStatus = FirebaseAuthStatus.unknown;
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
    _userInfo = _accounts.userInfo;
    _type = "google";

    notifyListeners();
  }

  Future<void> signOut() async {
    await _accounts.signOut();
    _authStatus = FirebaseAuthStatus.userNotLoggedIn;
    _user = null;
    _userInfo = null;
    notifyListeners();
  }
}
