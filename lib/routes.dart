import 'package:flutter/material.dart';
import 'package:iskolarsafe/screens/home.dart';
import 'package:iskolarsafe/screens/login.dart';
import 'package:iskolarsafe/screens/login/signup.dart';

class IskolarSafeRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    Home.routeName: (context) => const Home(),
    Login.routeName: (context) => const Login(),
    SignUp.routeName: (context) => const SignUp(),
  };

  static Route<dynamic>? dynamicRouteHandler(RouteSettings settings) {
    return null;
  }
}
