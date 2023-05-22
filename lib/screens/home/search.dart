import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/user_details.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'quarantine.dart';

class Search extends StatefulWidget {
  static const String routeName = "/";

  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<IconData> _listIcons = [Symbols.login_rounded, Symbols.logout_rounded];
  List<String> _listStrings = ["My Account", "Logout"];
  List<Map<dynamic, dynamic>> _listNames = [
    {
      "name": "Mang Juan",
      "studentNo": "20205678",
      "course": "BS Stat",
      "college": "CAS",
      "hasSymptoms": false,
      "isQuarantined": true,
      "isUnderMonitoring": false
    },
    {
      "name": "Maam Juana",
      "studentNo": "20205678",
      "course": "BS Chemistry",
      "college": "CAS",
      "hasSymptoms": false,
      "isQuarantined": true,
      "isUnderMonitoring": false
    },
    {
      "name": "Mami Juan",
      "studentNo": "20205678",
      "course": "BS Stat",
      "college": "CAS",
      "hasSymptoms": true,
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
      "isUnderMonitoring": false
    },
    {
      "name": "Maria Clara",
      "studentNo": "20202468",
      "course": "BSCE",
      "college": "CEAT",
      "hasSymptoms": true,
      "isQuarantined": true,
      "isUnderMonitoring": false
    },
    {
      "name": "Mario Clara",
      "studentNo": "20202468",
      "course": "BSCS",
      "college": "CAS",
      "hasSymptoms": false,
      "isQuarantined": false,
      "isUnderMonitoring": true
    },
    {
      "name": "Mara Clara",
      "studentNo": "20202468",
      "course": "BSCS",
      "college": "CAS",
      "hasSymptoms": true,
      "isQuarantined": false,
      "isUnderMonitoring": true
    },
    {
      "name": "Juan Tamad",
      "studentNo": "20202468",
      "course": "BSCS",
      "college": "CAS",
      "hasSymptoms": false,
      "isQuarantined": true,
      "isUnderMonitoring": false
    },
    {
      "name": "Mang Juan",
      "studentNo": "20205678",
      "course": "BS Stat",
      "college": "CAS",
      "hasSymptoms": false,
      "isQuarantined": false,
      "isUnderMonitoring": false
    },
    {
      "name": "Maria Clara",
      "studentNo": "20202468",
      "course": "BSCE",
      "college": "CEAT",
      "hasSymptoms": true,
      "isQuarantined": false,
      "isUnderMonitoring": true
    },
    {
      "name": "Mara Clara",
      "studentNo": "20202468",
      "course": "BSCS",
      "college": "CAS",
      "hasSymptoms": true,
      "isQuarantined": true,
      "isUnderMonitoring": false
    },
    {
      "name": "Juan Tamad",
      "studentNo": "20202468",
      "course": "BSCS",
      "college": "CAS",
      "hasSymptoms": false,
      "isQuarantined": true,
      "isUnderMonitoring": false
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarHeader(icon: Symbols.face, title: "Students"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            toolbarHeight: 80,
            title: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: TextField(
                  onSubmitted: (value) {
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Symbols.search_rounded),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                    hintText: "Search for students",
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: const [
          AppOptions(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _listNames.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                  leading: SizedBox(
                    height: double.infinity,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                          _listNames[index]["name"]!.toString().substring(0, 1),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary)),
                    ),
                  ),
                  minLeadingWidth: 44.0,
                  title: Text(_listNames[index]["name"]!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Student No",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserDetails(
                                userDetails: _listNames[index],
                                isQuarantined: _listNames[index]
                                    ["isQuarantined"],
                                isUnderMonitoring: _listNames[index]
                                    ["isUnderMonitoring"])));
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getHealthStatus(bool status) {
    String safe = "Safe for Work";
    String symptoms = "Has Symptoms";
    if (status) {
      return const Icon(Symbols.sick, color: Color(0xFFFB6962));
    } else {
      return const Icon(Symbols.health_and_safety_rounded,
          color: Color(0xFF0CC078));
    }
  }
}
