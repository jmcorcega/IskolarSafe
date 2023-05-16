// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class Isolate extends StatefulWidget {
  static const String routeName = "/";

  const Isolate({super.key});

  @override
  State<Isolate> createState() => _IsolateState();
}

class _IsolateState extends State<Isolate> {
  List<IconData> _listIcons = [Symbols.login_rounded, Symbols.logout_rounded];
  List<String> _listStrings = ["My Account", "Logout"];
  List<Map<dynamic, dynamic>> _listNames = [
    {
      "name": "May Laban",
      "studentNo": "20201234",
      "course": "BSCS",
      "college": "CAS",
      "hasSymptoms": true
    },
    {
      "name": "Mang Juan",
      "studentNo": "20205678",
      "course": "BS Stat",
      "college": "CAS",
      "hasSymptoms": false
    },
    {
      "name": "Maria Clara",
      "studentNo": "20202468",
      "course": "BSCE",
      "college": "CEAT",
      "hasSymptoms": true
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Icon(
                Symbols.coronavirus,
                color: Color(0xFFFB6962),
                size: 40.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, top: 10.0),
              child: Text("Under Monitoring",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFFFB6962))),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(100, 20, 0, 100),
                  items: List.generate(_listIcons.length, (index) {
                    return PopupMenuItem(
                        value: index,
                        onTap: () {},
                        child: Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Icon(_listIcons[index]),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(_listStrings[index]))
                          ],
                        ));
                  }));
            },
            icon: const Icon(Symbols.more_vert_rounded),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: ListView.builder(
            itemCount: _listNames.length,
            itemBuilder: ((context, index) {
              return ListTile(
                title: Text(_listNames[index]["name"]!),
                subtitle: _getHealthStatus(_listNames[index]["hasSymptoms"]!),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _monitoringAlertDialog(
                                    _listNames[index]["name"]!));
                      },
                      tooltip: "End Monitoring",
                      icon: const Icon(
                        Icons.highlight_remove,
                        color: Color(0xFF58B4EE),
                      )),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            useSafeArea: false,
                            context: context,
                            builder: (BuildContext context) =>
                                _quarantineAlertDialog(
                                    _listNames[index]["name"]!));
                      },
                      tooltip: "Move to Quarantine",
                      icon: const Icon(
                        Symbols.medical_mask,
                        color: Color(0xFFFB6962),
                      ))
                ]),
              );
            })),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showProfileModal(context);
        },
        label: const Text("My Profile"),
        icon: const Icon(Symbols.person_filled_rounded),
      ),
    );
  }

  void _showProfileModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.45,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: const ProfileModal(),
            );
          }),
    );
  }

  Widget _getHealthStatus(bool status) {
    String safe = "Safe for Work";
    String symptoms = "Has Symptoms";
    if (status) {
      return Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 5.0),
            child: Icon(Symbols.sick, color: Color(0xFFFB6962)),
          ),
          Text(symptoms),
        ],
      );
    } else {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: const Icon(Symbols.health_and_safety_rounded,
                color: Color(0xFF0CC078)),
          ),
          Text(safe),
        ],
      );
    }
  }

  Widget _monitoringAlertDialog(String name) {
    return AlertDialog(
      content: Text("Are you sure you want to end $name's monitoring?"),
      actions: [
        ElevatedButton(
          onPressed: () {},
          child: const Text("End Monitoring"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        )
      ],
    );
  }

  Widget _quarantineAlertDialog(String name) {
    return AlertDialog(
      content: Text("Are you sure you want to move $name to quarantine?"),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: ElevatedButton(
            onPressed: () {},
            child: const Text("Move to Quarantine"),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        )
      ],
    );
  }
}

class ProfileModal extends StatelessWidget {
  const ProfileModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 64.0),
        FlutterLogo(size: 150.0),
        SizedBox(height: 18.0),
        Text("User's Name", style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}
