import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class LoginViaEmail extends StatefulWidget {
  static const String routeName = "/login/email";

  const LoginViaEmail({super.key});
  @override
  LoginViaEmailState createState() => LoginViaEmailState();
}

class LoginViaEmailState extends State<LoginViaEmail> {
  static const Size _buttonSize = Size(225.0, 50.0);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _loginErr = false;
  bool _loadingButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            children: <Widget>[
              const FlutterLogo(size: 90),
              const SizedBox(height: 24.0),
              Text(
                "Login via Email",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 48.0),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Symbols.email_rounded),
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required.';
                  } else if (!EmailValidator.validate(value)) {
                    return 'Email is invalid.';
                  } else if (_loginErr) {
                    return 'Email may be incorrect.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 18.0),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Symbols.key_rounded),
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required.';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long.';
                  } else if (_loginErr) {
                    return 'Password may be incorrect.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18.0),
              Padding(
                key: const Key('loginButton'),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: FilledButton(
                  style: FilledButton.styleFrom(minimumSize: _buttonSize),
                  onPressed: _loadingButton
                      ? null
                      : () async {
                          _loginErr = false;
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _loadingButton = true;
                            });

                            if (context.mounted) {
                              if (_loginErr) {
                                _formKey.currentState!.validate();
                                setState(() {
                                  _loadingButton = false;
                                });
                              }
                            }
                          }

                          setState(() {
                            _loadingButton = false;
                          });
                        },
                  child: _loadingButton
                      ? Transform.scale(
                          scale: 0.5,
                          child: const CircularProgressIndicator(),
                        )
                      : const Text('Log in'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
