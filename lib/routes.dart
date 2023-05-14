import 'package:flutter/material.dart';
import 'package:iskolarsafe/screens/home.dart';

class IskolarSafeRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    Home.routeName: (context) => const Home(),
  };

  static Route<dynamic>? dynamicRouteHandler(RouteSettings settings) {
    return null;
  }
}
