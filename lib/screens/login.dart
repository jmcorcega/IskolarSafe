import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:iskolarsafe/api/accounts_api.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
import 'package:iskolarsafe/screens/login/signup.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  static const String routeName = "/login";

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loginErr = false;
  bool _loadingButton = false;
  bool _loadingGoogleButton = false;

  static const Size _buttonSize = Size(225.0, 47.5);

  void signInWithEmail() async {
    _loginErr = false;

    setState(() {
      _loadingButton = true;
    });

    await context.read<AccountsProvider>().signInWithEmail(
          email: emailController.text,
          password: passwordController.text,
        );

    if (context.mounted) {
      var status = context.read<AccountsProvider>().status;
      _loginErr = status != AccountsStatus.success;

      if (status == AccountsStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Logged in successfully.'),
          ),
        );

        return;
      }

      if (_loginErr) {
        _formKey.currentState!.validate();
        setState(() {
          _loadingButton = false;
        });
      }
    }

    setState(() {
      _loadingButton = false;
    });
  }

  void signInWithGoogle() async {
    _loginErr = false;

    setState(() {
      _loadingGoogleButton = true;
    });

    await context.read<AccountsProvider>().signInWithGoogle();
    if (context.mounted) {
      var status = context.read<AccountsProvider>().status;
      _loginErr = status != AccountsStatus.success &&
          status != AccountsStatus.needsSignUp;

      if (status == AccountsStatus.needsSignUp) {
        const snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Account not found. Sign up is required.'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushNamed(context, SignUp.routeName, arguments: true);
        return;
      }

      if (status == AccountsStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Logged in successfully.'),
          ),
        );

        return;
      }

      if (_loginErr) {
        setState(() {
          _loadingGoogleButton = false;
        });
      }
    }

    setState(() {
      _loadingGoogleButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Text("IskolarSafe",
                  style: Theme.of(context).textTheme.titleLarge!.apply(
                        fontWeightDelta: 1,
                        fontSizeDelta: 4,
                      )),
            ),
            Expanded(
              flex: 9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Text(
                        "Log in to your account",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .apply(fontSizeDelta: -8),
                      ),
                      const SizedBox(height: 48.0),
                      FilledButton.icon(
                        style:
                            OutlinedButton.styleFrom(minimumSize: _buttonSize),
                        onPressed: _loadingButton || _loadingGoogleButton
                            ? null
                            : signInWithGoogle,
                        icon: _loadingGoogleButton
                            ? Container()
                            : const Icon(
                                Bootstrap.google,
                                size: 18.0,
                              ),
                        label: _loadingGoogleButton
                            ? Transform.scale(
                                scale: 0.5,
                                child: const CircularProgressIndicator(),
                              )
                            : const Text("Log in via Google"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(height: 48.0),
                          const Expanded(child: Divider()),
                          const SizedBox(width: 14.0),
                          Text(
                            "OR",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(width: 14.0),
                          const Expanded(child: Divider()),
                          const SizedBox(height: 48.0),
                        ],
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Symbols.email_rounded),
                                border: OutlineInputBorder(),
                                labelText: "Email",
                              ),
                              enabled: !_loadingButton && !_loadingGoogleButton,
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
                            const SizedBox(height: 20.0),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Symbols.key_rounded),
                                border: OutlineInputBorder(),
                                labelText: "Password",
                              ),
                              enabled: !_loadingButton && !_loadingGoogleButton,
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 14.0),
                      TextButton(
                        style: TextButton.styleFrom(
                            minimumSize: const Size(280.0, 20.0)),
                        onPressed: () {},
                        child: const Text("Forgot your password?"),
                      ),
                      const SizedBox(height: 14.0),
                      OutlinedButton.icon(
                        style:
                            OutlinedButton.styleFrom(minimumSize: _buttonSize),
                        icon: _loadingButton
                            ? Container()
                            : const Icon(Symbols.login_rounded),
                        onPressed: _loadingButton || _loadingGoogleButton
                            ? null
                            : signInWithEmail,
                        label: _loadingButton
                            ? Transform.scale(
                                scale: 0.5,
                                child: const CircularProgressIndicator(),
                              )
                            : const Text('Log in via email'),
                      ),
                      const SizedBox(height: 48.0),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                            minimumSize: const Size(280.0, 40.0)),
                        onPressed: () {
                          Navigator.pushNamed(context, SignUp.routeName,
                              arguments: false);
                        },
                        icon: const Icon(Symbols.person_add_rounded),
                        label: const Text("Don't have an account? Sign up."),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      "By using IskolarSafe, you agree to the app's terms and conditions and privacy policy.",
                      style: Theme.of(context).textTheme.labelSmall,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
