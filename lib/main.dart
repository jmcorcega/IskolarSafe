import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iskolarsafe/firebase_options.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
import 'package:iskolarsafe/providers/entries_provider.dart';
import 'package:iskolarsafe/routes.dart';
import 'package:iskolarsafe/theme.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

void main() async {
  // Ensure widgets have been initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the application
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => AccountsProvider())),
        ChangeNotifierProvider(create: ((context) => HealthEntryProvider())),
      ],
      child: const IskolarSafeApp(),
    ),
  );
}

class IskolarSafeApp extends StatelessWidget {
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();

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
      navigatorObservers: [routeObserver],
      routes: IskolarSafeRoutes.routes,
      onGenerateRoute: (settings) =>
          IskolarSafeRoutes.dynamicRouteHandler(settings),
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        RelativeTimeLocalizations.delegate,
      ],
    );
  }
}
