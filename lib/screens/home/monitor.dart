// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:material_symbols_icons/symbols.dart';

class Monitor extends StatefulWidget {
  static const String routeName = "/";

  const Monitor({super.key});

  @override
  State<Monitor> createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> {
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
        title: AppBarHeader(
            icon: Symbols.coronavirus_rounded, title: "Under Monitoring"),
        actions: const [
          AppOptions(),
        ],
      ),
      body: ListView.builder(
          itemCount: _listNames.length,
          itemBuilder: ((context, index) {
            return ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MonitoringDetails(mapDetails: _listNames[index])));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
              title: Text(_listNames[index]["name"]!),
              subtitle: _getHealthStatus(_listNames[index]["hasSymptoms"]!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 34.0,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: EdgeInsets.all(0),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _monitoringAlertDialog(
                                    _listNames[index]["name"]!));
                      },
                      child: const Icon(Symbols.close_rounded, size: 18.0),
                    ),
                  ),
                  SizedBox(width: 12.0),
                  SizedBox(
                    width: 34.0,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: EdgeInsets.all(0),
                          foregroundColor:
                              Theme.of(context).colorScheme.tertiary),
                      onPressed: () {
                        showDialog(
                            useSafeArea: false,
                            context: context,
                            builder: (BuildContext context) =>
                                _quarantineAlertDialog(
                                    _listNames[index]["name"]!));
                      },
                      child: const Icon(Symbols.medical_mask_rounded),
                    ),
                  ),
                ],
              ),
            );
          })),
    );
  }

  Widget _getHealthStatus(bool status) {
    String safe = "Safe for Work";
    String symptoms = "Has Symptoms";
    if (status) {
      return Row(
        children: [
          Icon(Symbols.sick, color: Colors.red, size: 20.0),
          SizedBox(width: 6.0),
          Text(
            symptoms,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .apply(color: Colors.red),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(Symbols.health_and_safety_rounded,
              color: Colors.green, size: 20.0),
          SizedBox(width: 6.0),
          Text(
            safe,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .apply(color: Colors.green),
          ),
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

class MonitoringDetails extends StatelessWidget {
  final Map<dynamic, dynamic> mapDetails;
  const MonitoringDetails({super.key, required this.mapDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mapDetails["name"]),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Icon(Icons.person, size: 100, color: Color(0xFF8A1538)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child:
                        Icon(Symbols.person_rounded, color: Color(0xFF8A1538)),
                  ),
                  Text(mapDetails["name"],
                      style: Theme.of(context).textTheme.bodyLarge)
                ],
              ),
            ),
            Divider(color: Color(0xFF8A1538), thickness: 1.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child:
                        Icon(Symbols.badge_rounded, color: Color(0xFF8A1538)),
                  ),
                  Text(mapDetails["studentNo"],
                      style: Theme.of(context).textTheme.bodyLarge)
                ],
              ),
            ),
            Divider(color: Color(0xFF8A1538), thickness: 1.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child:
                        Icon(Symbols.school_rounded, color: Color(0xFF8A1538)),
                  ),
                  Text(mapDetails["course"],
                      style: Theme.of(context).textTheme.bodyLarge)
                ],
              ),
            ),
            Divider(color: Color(0xFF8A1538), thickness: 1.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Icon(Symbols.home, color: Color(0xFF8A1538)),
                  ),
                  Text(mapDetails["college"],
                      style: Theme.of(context).textTheme.bodyLarge)
                ],
              ),
            ),
            Divider(color: Color(0xFF8A1538), thickness: 1.0),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Back",
                        style: Theme.of(context).textTheme.titleMedium)),
              ),
            )
          ],
        ),
      ),
    );
  }
}