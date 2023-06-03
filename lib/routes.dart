import 'package:flutter/material.dart';
import 'package:iskolarsafe/models/entry_model.dart';
import 'package:iskolarsafe/screens/edit_profile.dart';
import 'package:iskolarsafe/screens/home.dart';
import 'package:iskolarsafe/screens/login.dart';
import 'package:iskolarsafe/screens/login/signup.dart';
import 'package:iskolarsafe/screens/entry_editor.dart';
import 'package:iskolarsafe/screens/settings.dart';
import 'package:iskolarsafe/screens/settings/about.dart';

class IskolarSafeRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    Home.routeName: (context) => const Home(),
    Login.routeName: (context) => const Login(),
    EditProfile.routeName: (context) => const EditProfile(),
    Settings.routeName: (context) => const Settings(),
    About.routeName: (context) => const About()
  };

  static Route<dynamic>? dynamicRouteHandler(RouteSettings settings) {
    switch (settings.name) {
      case SignUp.routeName:
        final args =
            settings.arguments != null ? settings.arguments as bool : false;
        return MaterialPageRoute(builder: (context) {
          return SignUp(isGoogleSignUp: args);
        });
      case EntryEditor.routeName:
        final args = settings.arguments != null
            ? settings.arguments as HealthEntry
            : null;
        return MaterialPageRoute(builder: (context) {
          return EntryEditor(entry: args);
        });
    }
    return null;
  }
}
