// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
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
  late final Future<AppUserInfo?> _userInfoFuture =
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
  bool _deferEditing = false;
  AppUserInfo? _userInfo;

  File? _newPhoto;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool listEqual(a, b) {
    var condition1 = a.toSet().difference(b.toSet()).isEmpty;
    var condition2 = a.length == b.length;
    return condition1 && condition2;
  }

  bool checkChanges() {
    if (firstNameController.text != _userInfo!.firstName) return true;
    if (lastNameController.text != _userInfo!.lastName) return true;
    if (userNameController.text != _userInfo!.userName) return true;
    if (studentNumController.text != _userInfo!.studentNumber) return true;
    if (courseController.text != _userInfo!.course) return true;
    if (college != _userInfo!.college) return true;
    // TODO: Compare condition and allergy lists as well

    if (_newPhoto != null) return true;

    return false;
  }

  void _updateProfilePhoto() async {
    final ImagePickerPlatform pickerPlatform = ImagePickerPlatform.instance;
    if (pickerPlatform is ImagePickerAndroid) {
      pickerPlatform.useAndroidPhotoPicker = true;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && context.mounted) {
      setState(() {
        _newPhoto = File(image.path);
      });
    }
  }

  void updateProfile() async {
    setState(() {
      _editError = false;
      _deferEditing = true;
    });
    if (_formKey.currentState!.validate()) {
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
      await context.read<AccountsProvider>().updateProfile(
          userInfo: AppUserInfo.toJson(userInfo), photo: _newPhoto);

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
            _deferEditing = false;
          });
        }
      }
    }

    setState(() {
      _deferEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (checkChanges()) {
          bool shouldPop = false;
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Discard changes'),
              content: const Text('Are you sure you want to discard changes?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    shouldPop = false;
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    shouldPop = true;
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );

          return shouldPop;
        }

        return true;
      },
      child: _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
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
        future: _userInfoFuture,
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

          if (_userInfo == null) {
            _userInfo = snapshot.data;
            firstNameController.text = _userInfo!.firstName;
            lastNameController.text = _userInfo!.lastName;
            userNameController.text = _userInfo!.userName;
            studentNumController.text = _userInfo!.studentNumber;
            courseController.text = _userInfo!.course;
            college = _userInfo!.college;
            photoUrl = _userInfo!.photoUrl;
            userId = _userInfo!.id;

            _allergiesList = _userInfo!.allergies;
            _conditionsList = _userInfo!.condition;
            checkChanges();
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
                        padding: const EdgeInsets.all(4.0),
                        icon: _newPhoto != null
                            ? CircleAvatar(
                                radius: 68,
                                foregroundImage: FileImage(_newPhoto!),
                              )
                            : (userPhoto != null
                                ? CircleAvatar(
                                    radius: 68,
                                    foregroundImage:
                                        CachedNetworkImageProvider(userPhoto),
                                  )
                                : CircleAvatar(
                                    radius: 68,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    child: Text(
                                      user.displayName!.substring(0, 1),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                    ),
                                  )),
                        onPressed: _deferEditing ? null : _updateProfilePhoto,
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
        future: _userInfoFuture,
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
