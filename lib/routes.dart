import 'package:flutter/material.dart';
import 'package:iskolarsafe/screens/home.dart';
import 'package:iskolarsafe/screens/login.dart';
import 'package:iskolarsafe/screens/login/signup.dart';
import 'package:iskolarsafe/screens/settings.dart';
import 'package:iskolarsafe/screens/settings/about.dart';

class IskolarSafeRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    Home.routeName: (context) => const Home(),
    Login.routeName: (context) => const Login(),
    SignUp.routeName: (context) => const SignUp(),
    Settings.routeName: (context) => const Settings(),
    About.routeName: (context) => const About()
  };

  static Route<dynamic>? dynamicRouteHandler(RouteSettings settings) {
    return null;
  }
}
