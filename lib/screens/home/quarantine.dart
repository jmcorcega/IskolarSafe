// NAME -> If clicked, show profile
// DATE QUARANTINED
// Remove Quarantine -> When clicked, show pop up

import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/user_details.dart';
import 'package:material_symbols_icons/symbols.dart';

class Quarantine extends StatefulWidget {
  static const String routeName = "/quarantine";

  const Quarantine({super.key});

  @override
  State<Quarantine> createState() => _QuarantineState();
}

class _QuarantineState extends State<Quarantine> {
  List<Map<dynamic, dynamic>> _listNames = [
    {
      "name": "Mang Juan",
      "studentNo": "20205678",
      "course": "BS Stat",
      "college": "CAS",
      "hasSymptoms": false,
      "isQuarantined": true
    },
    {
      "name": "Maria Clara",
      "studentNo": "20202468",
      "course": "BSCE",
      "college": "CEAT",
      "hasSymptoms": true,
      "isQuarantined": true
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarHeader(
            icon: Symbols.medical_mask_rounded, title: "Under Quarantine"),
        actions: const [
          AppOptions(),
        ],
      ),
      body: ListView.builder(
        itemCount: _listNames.length,
        itemBuilder: ((context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            leading: _getHealthStatus(_listNames[index]["hasSymptoms"]!),
            title: Text(_listNames[index]["name"]!),
            subtitle: Text(
              "Quarantined on: 18/05/2023 11:53am",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            trailing: SizedBox(
              width: 34.0,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(0),
                ),
                onPressed: () {
                  showDialog(
                      useSafeArea: false,
                      context: context,
                      builder: (BuildContext context) =>
                          _quarantineAlertDialog(_listNames[index]["name"]!));
                },
                child: const Icon(Symbols.close),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UserDetails(userDetails: _listNames[index])));
            },
          );
        }),
      ),
    );
  }

  Widget _getHealthStatus(bool status) {
    if (status) {
      return const Icon(Symbols.sick, color: Colors.red);
    } else {
      return const Icon(Symbols.health_and_safety_rounded, color: Colors.green);
    }
  }

  Widget _quarantineAlertDialog(String name) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text("Are you sure you want to remove $name from quarantine?"),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // or spaceBetween?
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
                // Color is hard coded. Needs a way to match this color from
                onPressed: () {},
                child: const Text("Remove",
                    style: TextStyle(color: Color(0xFFFFFFFF))),
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Color(0xFFFB6962)))),
          ],
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
