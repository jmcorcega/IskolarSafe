// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iskolarsafe/college_data.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/extensions.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  static const String routeName = "/profile/edit";
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late final Future<AppUserInfo?> _userInfo =
      context.read<AccountsProvider>().userInfo;
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController studentNumController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  String college = CollegeData.colleges.first;
  String? photoUrl;
  String? userId;

  TextEditingController _controller = TextEditingController();
  final _allergyKey = GlobalKey<FormState>();
  List<String> _conditionsList = [];
  List<String> _allergiesList = [];

  bool _editError = false;
  bool _loadingButton = false;
  bool _deferEditing = false;
  bool _gotData = false;

  void updateProfile() async {
    _editError = false;
    _deferEditing = true;
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loadingButton = true;
      });

      // Save the form
      _formKey.currentState?.save();

      AppUserInfo userInfo = AppUserInfo(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        userName: userNameController.text,
        studentNumber: studentNumController.text,
        course: courseController.text,
        college: college,
        condition: _conditionsList,
        allergies: _allergiesList,
        photoUrl: photoUrl,
        id: userId,
      );
      await context
          .read<AccountsProvider>()
          .updateProfile(AppUserInfo.toJson(userInfo));

      if (context.mounted) {
        var status = context.read<AccountsProvider>().editStatus;
        if (status) {
          const snackBar = SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Profile edited successfully.'),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pop(context);
        }

        if (!status) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('An error has occured. Try again later.'),
          ));
        }

        if (_editError) {
          _formKey.currentState!.validate();
          setState(() {
            _loadingButton = false;
            _deferEditing = false;
          });
        }
      }
    }

    setState(() {
      _loadingButton = false;
      _deferEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = context.read<AccountsProvider>().user;
    var userPhoto = user!.photoURL;

    return Scaffold(
      appBar: AppBar(
        title: const AppBarHeader(
          icon: Symbols.account_circle_rounded,
          title: "Update Profile",
          hasAction: false,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _userInfo,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              // Show a message where the user can add an entry if list is empty
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Symbols.sentiment_dissatisfied,
                      size: 64.0,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.5)),
                  const SizedBox(height: 16.0),
                  Text(
                    "An error has occured. Please try again.",
                    style: Theme.of(context).textTheme.titleMedium!.apply(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.5),
                        ),
                  ),
                ],
              ),
            );
          }

          if (!_gotData) {
            AppUserInfo userInfo = snapshot.data;
            firstNameController.text = userInfo.firstName;
            lastNameController.text = userInfo.lastName;
            userNameController.text = userInfo.userName;
            studentNumController.text = userInfo.studentNumber;
            courseController.text = userInfo.course;
            college = userInfo.college;
            photoUrl = userInfo.photoUrl;
            userId = userInfo.id;

            _allergiesList = userInfo.allergies;
            _conditionsList = userInfo.condition;

            _gotData = true;
          }

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
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
                  const SizedBox(height: 18.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: userPhoto != null
                            ? CircleAvatar(
                                radius: 64,
                                foregroundImage:
                                    CachedNetworkImageProvider(userPhoto),
                              )
                            : CircleAvatar(
                                radius: 64,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: Text(
                                  user.displayName!.substring(0, 1),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ),
                              ),
                        // TODO: Add image picker and upload file so we
                        // can save it as the user's profile photo
                        onPressed: () => {},
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: firstNameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "First name",
                              ),
                              enabled: !_deferEditing,
                              validator: (value) {
                                if (firstNameController.text.isEmpty ||
                                    value == null ||
                                    value.isEmpty) {
                                  return 'This field is required.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12.0),
                            TextFormField(
                              controller: lastNameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Last name",
                              ),
                              enabled: !_deferEditing,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required.';
                                }
                                return null;
                              },
                            ),
                          ],
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
                    enabled: !_deferEditing,
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
                    enabled: !_deferEditing,
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
                    enabled: !_deferEditing,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required.";
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  DropdownButtonFormField<String>(
                    onChanged: !_deferEditing
                        ? (String? value) {
                            college = value!;
                          }
                        : null,
                    disabledHint: Text(college),
                    value: college,
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
                    children:
                        ConditionsList.values.map((ConditionsList condition) {
                      String conditionName = condition.name
                          .replaceAll("_", " ")
                          .toLowerCase()
                          .capitalizeByWord();
                      return FilterChip(
                        label: Text(conditionName),
                        selected: _conditionsList.contains(conditionName),
                        onSelected: !_deferEditing
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
                        enabled: !_deferEditing,
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
                          if (_deferEditing) return null;
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
                          onPressed: !_deferEditing
                              ? () {
                                  setState(() {
                                    _allergiesList.remove(allergy);
                                  });
                                }
                              : null,
                          onDeleted: !_deferEditing
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
                  const SizedBox(height: 64.0),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FutureBuilder(
        future: _userInfo,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              backgroundColor: _deferEditing
                  ? Theme.of(context).colorScheme.background
                  : null,
              foregroundColor: _deferEditing
                  ? Theme.of(context).colorScheme.onBackground.withOpacity(0.75)
                  : null,
              onPressed: _deferEditing ? null : updateProfile,
              label: Text("Save Changes"),
              icon: Icon(Symbols.save_rounded),
            );
          }
          return Container();
        },
      ),
    );
  }
}
