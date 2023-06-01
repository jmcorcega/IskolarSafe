import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:iskolarsafe/api/accounts_api.dart';
import 'package:iskolarsafe/college_data.dart';
import 'package:iskolarsafe/extensions.dart';
import 'package:iskolarsafe/main.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  static const String routeName = "/login/signup";
  final bool isGoogleSignUp;

  const SignUp({super.key, this.isGoogleSignUp = false});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with RouteAware {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _allergyKey = GlobalKey<FormState>();
  bool _authErr = false;
  bool _loadingButton = false;
  bool _isGoogle = false;
  bool _deferSignOut = false;
  bool _loadingGoogleButton = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController studentNumController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  String college = CollegeData.colleges.first;

  List<String> _conditionsList = [];
  List<String> _allergiesList = [];

  static const Size _buttonSize = Size(225.0, 47.5);

  void getGoogleInfo() async {
    bool loginErr;

    setState(() {
      _loadingGoogleButton = true;
    });

    await context.read<AccountsProvider>().signInWithGoogle(context);
    if (context.mounted) {
      var status = context.read<AccountsProvider>().status;
      loginErr = status != AccountsStatus.success &&
          status != AccountsStatus.needsSignUp;

      if (loginErr) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('An error has occured. Try again later'),
        ));
      }

      if (status == AccountsStatus.success) {
        _deferSignOut = true;
        _loadingGoogleButton = false;
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Account already exists.'),
        ));
      }

      if (status == AccountsStatus.needsSignUp) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Successfully retrieved Google account information.'),
        ));
      }

      if (status == AccountsStatus.needsSignUp) {
        _isGoogle = true;
      }

      setState(() {
        _loadingGoogleButton = false;
      });
    }

    setState(() {
      _loadingGoogleButton = false;
    });
  }

  void signUp() async {
    _authErr = false;
    _deferSignOut = true;
    if (_isGoogle || _formKey.currentState!.validate()) {
      setState(() {
        _loadingButton = true;
      });

      // Save the form
      _formKey.currentState?.save();

      IskolarInfo userInfo = IskolarInfo(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        userName: userNameController.text,
        studentNumber: studentNumController.text,
        course: courseController.text,
        college: college,
        condition: _conditionsList,
        allergies: _allergiesList,
      );
      await context.read<AccountsProvider>().signUp(context, _isGoogle,
          email: emailController.text,
          password: passwordController.text,
          userInfo: IskolarInfo.toJson(userInfo));

      if (context.mounted) {
        var status = context.read<AccountsProvider>().status;
        if (status == AccountsStatus.success) {
          const snackBar = SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Signed up successfully.'),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pop(context);
        }

        if (status == AccountsStatus.userAlreadyExist) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
                'Account already exists. Try logging in using your Google account.'),
          ));
        }

        if (status != AccountsStatus.success &&
            status != AccountsStatus.userAlreadyExist) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('An error has occured. Try again later.'),
          ));
        }

        if (_authErr) {
          _formKey.currentState!.validate();
          setState(() {
            _loadingButton = false;
            _deferSignOut = false;
          });
        }
      }
    }

    setState(() {
      _loadingButton = false;
      _deferSignOut = false;
    });
  }

  void onLeaveScreen() {
    if (!_deferSignOut) {
      context.read<AccountsProvider>().signOut();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    IskolarSafeApp.routeObserver
        .subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    super.dispose();
    IskolarSafeApp.routeObserver.unsubscribe(this);
  }

  @override
  void didPushNext() {
    onLeaveScreen();
  }

  @override
  void didPop() {
    onLeaveScreen();
  }

  @override
  Widget build(BuildContext context) {
    // Check if we are signing up from log in screen using Google account
    _isGoogle = _isGoogle || widget.isGoogleSignUp;

    if (_isGoogle) {
      emailController.text = context.read<AccountsProvider>().user!.email!;
      passwordController.text = context.read<AccountsProvider>().user!.uid;
    }

    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Sign Up to IskolarSafe",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.apply(
                      fontWeightDelta: 1,
                      fontSizeDelta: 4,
                      heightDelta: 0.75,
                    ),
              ),
              Text(
                "Keep yourself safe inside and outside the campus.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 56.0),
              Container(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: null,
                  icon: const Icon(Symbols.login_rounded, size: 28.0),
                  label: Text("Login Details",
                      style: Theme.of(context).textTheme.labelLarge!.apply(
                            fontSizeDelta: 4,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 0.0),
                    ),
                    foregroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              FilledButton.icon(
                style: OutlinedButton.styleFrom(minimumSize: _buttonSize),
                onPressed: _isGoogle || _loadingGoogleButton || _deferSignOut
                    ? null
                    : getGoogleInfo,
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
                    : const Text("Sign up via Google"),
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
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Symbols.email_rounded),
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
                enabled: !_isGoogle && !_deferSignOut,
                validator: (value) {
                  if (_isGoogle) return null;
                  if (emailController.text.isEmpty ||
                      value == null ||
                      value.isEmpty) {
                    return 'Email is required.';
                  } else if (!EmailValidator.validate(value)) {
                    return 'Email is invalid.';
                  } else if (!CollegeData.isValidEmail(value)) {
                    return 'Only college emails are allowed.';
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
                enabled: !_isGoogle && !_deferSignOut,
                validator: (value) {
                  if (_isGoogle) return null;
                  if (passwordController.text.isEmpty ||
                      value == null ||
                      value.isEmpty) {
                    return 'Password is required.';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              Container(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: null,
                  icon: const Icon(Symbols.face_rounded, size: 28.0),
                  label: Text("User Information",
                      style: Theme.of(context).textTheme.labelLarge!.apply(
                            fontSizeDelta: 4,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 0.0),
                    ),
                    foregroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "First name",
                      ),
                      enabled: !_deferSignOut,
                      validator: (value) {
                        if (firstNameController.text.isEmpty ||
                            value == null ||
                            value.isEmpty) {
                          return 'This field is required.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Last name",
                      ),
                      enabled: !_deferSignOut,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required.';
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: userNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Symbols.account_circle_rounded),
                  border: OutlineInputBorder(),
                  labelText: "Username",
                ),
                enabled: !_deferSignOut,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required.";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: studentNumController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Symbols.badge_rounded),
                  border: OutlineInputBorder(),
                  labelText: "Student ID Number",
                ),
                enabled: !_deferSignOut,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required.";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: courseController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Symbols.school_rounded),
                  border: OutlineInputBorder(),
                  labelText: "Course",
                ),
                enabled: !_deferSignOut,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required.";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                onChanged: !_deferSignOut
                    ? (String? value) {
                        college = value!;
                      }
                    : null,
                disabledHint: Text(college),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Symbols.domain_rounded),
                  labelText: "College",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required.";
                  }

                  return null;
                },
                isExpanded: true,
                items: CollegeData.colleges.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
              const SizedBox(height: 32.0),
              Container(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: null,
                  icon: const Icon(Symbols.medical_information_rounded,
                      size: 28.0),
                  label: Text("Health Information",
                      style: Theme.of(context).textTheme.labelLarge!.apply(
                            fontSizeDelta: 4,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 0.0),
                    ),
                    foregroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Do you experience any of the following?",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .apply(heightDelta: 0.25),
                  ),
                  Text(
                    "Tick all those that apply",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Wrap(
                spacing: 5.0,
                children: ConditionsList.values.map((ConditionsList condition) {
                  String conditionName = condition.name
                      .replaceAll("_", " ")
                      .toLowerCase()
                      .capitalizeByWord();
                  return FilterChip(
                    label: Text(conditionName),
                    selected: _conditionsList.contains(conditionName),
                    onSelected: !_deferSignOut
                        ? (bool selected) {
                            setState(() {
                              if (selected) {
                                _conditionsList.add(conditionName);
                              } else {
                                _conditionsList.remove(conditionName);
                              }
                            });
                          }
                        : null,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Do you have any allergies?",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .apply(heightDelta: 0.25),
                  ),
                  Text(
                    "Enter all that apply and tap the 'add' button",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Form(
                  key: _allergyKey,
                  child: TextFormField(
                    initialValue: null,
                    controller: _controller,
                    textInputAction: TextInputAction.done,
                    enabled: !_deferSignOut,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Symbols.masks_rounded),
                      border: const OutlineInputBorder(),
                      hintText: "Enter your allergy",
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (_controller.text.isEmpty) {
                            _allergyKey.currentState?.validate();
                            return;
                          }
                          setState(() {
                            _allergiesList.add(_controller.text);
                            _allergyKey.currentState?.validate();
                            _controller.clear();
                          });
                        },
                        icon: const Icon(Symbols.add_rounded),
                      ),
                    ),
                    validator: (value) {
                      if (_deferSignOut) return null;
                      if (_controller.text.isEmpty ||
                          value == null ||
                          value.isEmpty) {
                        return "This field cannot be empty before adding";
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      setState(() {
                        if (_controller.text.isEmpty) {
                          _allergyKey.currentState?.validate();
                          return;
                        }

                        _allergiesList.add(_controller.text);
                        _allergyKey.currentState?.validate();
                        _controller.clear();
                      });
                    },
                  )),
              const SizedBox(height: 16.0),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 5.0,
                children: List<Widget>.generate(
                  _allergiesList.length,
                  (int index) {
                    String allergy = _allergiesList[index];
                    return InputChip(
                      label: Text(allergy),
                      onPressed: !_deferSignOut
                          ? () {
                              setState(() {
                                _allergiesList.remove(allergy);
                              });
                            }
                          : null,
                      onDeleted: !_deferSignOut
                          ? () {
                              setState(() {
                                _allergiesList.remove(allergy);
                              });
                            }
                          : null,
                    );
                  },
                ).toList(),
              ),
              const SizedBox(height: 48.0),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: _buttonSize),
                onPressed: _loadingButton ? null : signUp,
                child: _loadingButton
                    ? Transform.scale(
                        scale: 0.5,
                        child: const CircularProgressIndicator(),
                      )
                    : const Text('Sign up to IskolarSafe'),
              ),
              const SizedBox(height: 64.0),
            ],
          ),
        ),
      ),
    );
  }
}
