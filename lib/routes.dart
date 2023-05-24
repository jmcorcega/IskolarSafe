import 'package:flutter/material.dart';
import 'package:iskolarsafe/screens/edit_profile.dart';
import 'package:iskolarsafe/screens/home.dart';
import 'package:iskolarsafe/screens/login.dart';
import 'package:iskolarsafe/screens/login/signup.dart';
import 'package:iskolarsafe/screens/new_entry.dart';

class IskolarSafeRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    Home.routeName: (context) => const Home(),
    Login.routeName: (context) => const Login(),
    NewEntry.routeName: (context) => const NewEntry(),
    EditProfile.routeName: (context) => const EditProfile(),
  };

  static Route<dynamic>? dynamicRouteHandler(RouteSettings settings) {
    switch (settings.name) {
      case SignUp.routeName:
        final args =
            settings.arguments != null ? settings.arguments as bool : false;
        return MaterialPageRoute(builder: (context) {
          return SignUp(isGoogleSignUp: args);
        });
    }
    return null;
  }
}
