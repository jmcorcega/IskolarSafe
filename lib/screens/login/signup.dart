import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum ConditionsList {
  hypertension,
  tubercolosis,
  diabetes,
  cancer,
  kidney_disease,
  cardiac_disease,
  autoimmune_disease,
  asthma
}

extension StringExtension on String {
  String capitalizeByWord() {
    if (trim().isEmpty) {
      return '';
    }
    return split(' ')
        .map((element) =>
            "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}")
        .join(" ");
  }
}

class SignUp extends StatefulWidget {
  static const String routeName = "/login/signup";

  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _authErr = false;
  bool _loadingButton = false;

  List<String> _conditionsList = [];
  List<String> _allergiesList = [];

  static final List<String> colleges = [
    "Makalipad",
    "Maging Invisible",
    "Mapaibig siya",
    "Mapabago ang isip niya",
    "Mapalimot siya",
    "Mabalik ang nakaraan",
    "Mapaghiwalay sila",
    "Makarma siya",
    "Mapasagasaan siya sa pison",
    "Mapaitim ang tuhod ng iniibig niya"
  ];

  static const Size _buttonSize = Size(225.0, 47.5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 36.0),
          children: [
            Text(
              "Sign Up to IskolarSafe",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.apply(
                    fontWeightDelta: 1,
                    fontSizeDelta: 4,
                  ),
            ),
            const SizedBox(height: 56.0),
            Container(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: null,
                icon: const Icon(Symbols.login_rounded, size: 28.0),
                label: Text("Login Details",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .apply(fontSizeDelta: 4)),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
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
              validator: (value) {
                if (value == null || value.isEmpty) {
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
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .apply(fontSizeDelta: 4)),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    // controller: firstNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "First name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: TextFormField(
                    // controller: lastNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Last name",
                    ),
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
              // controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Symbols.account_circle_rounded),
                border: OutlineInputBorder(),
                labelText: "Username",
              ),
              validator: (value) {
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              // controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Symbols.badge_rounded),
                border: OutlineInputBorder(),
                labelText: "Student ID Number",
              ),
              validator: (value) {
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              // controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Symbols.school_rounded),
                border: OutlineInputBorder(),
                labelText: "Course",
              ),
              validator: (value) {
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              // value: formValues["superPowerValue"],
              onChanged: (String? value) {},
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "College",
              ),
              items: colleges.map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
              onSaved: (newValue) {
                // formValues["superPowerValue"] = newValue!;
              },
            ),
            const SizedBox(height: 32.0),
            Container(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: null,
                icon:
                    const Icon(Symbols.medical_information_rounded, size: 28.0),
                label: Text("Health Information",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .apply(fontSizeDelta: 4)),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.onBackground,
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
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _conditionsList.add(conditionName);
                      } else {
                        _conditionsList.remove(conditionName);
                      }
                    });
                  },
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
            TextFormField(
              controller: _controller,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                prefixIcon: const Icon(Symbols.masks_rounded),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _allergiesList.add(_controller.text);
                    });
                  },
                  icon: const Icon(Symbols.add_rounded),
                ),
              ),
              onFieldSubmitted: (value) {
                setState(() {
                  _allergiesList.add(value);
                });
              },
            ),
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
                    onPressed: () {
                      setState(() {
                        _allergiesList.remove(allergy);
                      });
                    },
                    onDeleted: () {
                      setState(() {
                        _allergiesList.remove(allergy);
                      });
                    },
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 48.0),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: _buttonSize),
              onPressed: _loadingButton
                  ? null
                  : () async {
                      _authErr = false;
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _loadingButton = true;
                        });

                        if (context.mounted) {
                          if (_authErr) {
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
                  : const Text('Sign up to IskolarSafe'),
            ),
            const SizedBox(height: 64.0),
          ],
        ),
      ),
    );
  }
}
