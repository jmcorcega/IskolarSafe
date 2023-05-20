import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iskolarsafe/firebase_options.dart';
import 'package:iskolarsafe/routes.dart';
import 'package:iskolarsafe/theme.dart';

void main() async {
  // Ensure widgets have been initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the application
  runApp(const IskolarSafeApp());
}

class IskolarSafeApp extends StatelessWidget {
  const IskolarSafeApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
