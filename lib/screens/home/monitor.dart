// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/monitoring_alertdialog.dart';
import 'package:iskolarsafe/components/quarantine_alertdialog.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../components/user_details.dart';

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
      "hasSymptoms": true,
      "isQuarantined": false,
      "isUnderMonitoring": true
    },
    {
      "name": "Mang Juan",
      "studentNo": "20205678",
      "course": "BS Stat",
      "college": "CAS",
      "hasSymptoms": false,
      "isQuarantined": false,
      "isUnderMonitoring": true
    },
    {
      "name": "Maria Clara",
      "studentNo": "20202468",
      "course": "BSCE",
      "college": "CEAT",
      "hasSymptoms": true,
      "isQuarantined": false,
      "isUnderMonitoring": true
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                        builder: (context) => UserDetails(
                            userDetails: _listNames[index],
                            isQuarantined: _listNames[index]["isQuarantined"],
                            isUnderMonitoring: _listNames[index]
                                ["isUnderMonitoring"])));
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
                                MonitoringAlertDialog(
                                  name: _listNames[index]["name"]!,
                                  // isQuarantined: _listNames[index]
                                  //     ["isQuarantined"],
                                  // isUnderMonitoring: _listNames[index]
                                  //     ["isUnderMonitoring"]
                                ));
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
                                QuarantineAlertDialog(
                                  name: _listNames[index]["name"]!,
                                  isQuarantined: _listNames[index]
                                      ["isQuarantined"],
                                ));
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
