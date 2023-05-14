import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:iskolarsafe/screens/login/email.dart';
import 'package:material_symbols_icons/symbols.dart';

class Login extends StatelessWidget {
  static const String routeName = "/login";
  static const Size _buttonSize = Size(225.0, 50.0);

  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 90),
            const SizedBox(height: 24.0),
            Text("Welcome to IskolarSafe",
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 72.0),
            FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: _buttonSize),
              onPressed: () {},
              icon: const Icon(
                Bootstrap.google,
                size: 18.0,
              ),
              label: const Text("Log in via Google"),
            ),
            const SizedBox(height: 18.0),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: _buttonSize),
              onPressed: () {
                Navigator.pushNamed(context, LoginViaEmail.routeName);
              },
              icon: const Icon(Symbols.email_rounded),
              label: const Text("Log in via Email"),
            ),
            const SizedBox(height: 140.0),
            TextButton.icon(
              style: TextButton.styleFrom(minimumSize: const Size(240.0, 40.0)),
              onPressed: () {},
              icon: const Icon(Symbols.person_add_rounded),
              label: const Text("Don't have an account yet?"),
            ),
          ],
        ),
      ),
    );
  }
}
