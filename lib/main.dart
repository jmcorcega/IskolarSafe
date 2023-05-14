import 'package:flutter/material.dart';
import 'package:iskolarsafe/routes.dart';
import 'package:iskolarsafe/theme.dart';

void main() {
  runApp(const IskolarSafeApp());
}

class IskolarSafeApp extends StatelessWidget {
  const IskolarSafeApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IskolarSafe',
      theme: IskolarSafeTheme.lightTheme,
      darkTheme: IskolarSafeTheme.darkTheme,
      initialRoute: "/",
      routes: IskolarSafeRoutes.routes,
      onGenerateRoute: (settings) =>
          IskolarSafeRoutes.dynamicRouteHandler(settings),
    );
  }
}
