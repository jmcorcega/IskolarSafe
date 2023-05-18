import 'package:flutter/material.dart';
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
      "hasSymptoms": false
    },
    {
      "name": "Maam Juana",
      "studentNo": "20205678",
      "course": "BS Chemistry",
      "college": "CAS",
      "hasSymptoms": false
    },
    {
      "name": "Mami Juan",
      "studentNo": "20205678",
      "course": "BS Stat",
      "college": "CAS",
      "hasSymptoms": true
    },
    {
      "name": "Maria Clara",
      "studentNo": "20202468",
      "course": "BSCE",
      "college": "CEAT",
      "hasSymptoms": true
    },
    {
      "name": "Maria Clara",
      "studentNo": "20202468",
      "course": "BSCE",
      "college": "CEAT",
      "hasSymptoms": true
    },
    {
      "name": "Mario Clara",
      "studentNo": "20202468",
      "course": "BSCS",
      "college": "CAS",
      "hasSymptoms": false
    },
    {
      "name": "Mara Clara",
      "studentNo": "20202468",
      "course": "BSCS",
      "college": "CAS",
      "hasSymptoms": true
    },
    {
      "name": "Juan Tamad",
      "studentNo": "20202468",
      "course": "BSCS",
      "college": "CAS",
      "hasSymptoms": false
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
    },
    {
      "name": "Mara Clara",
      "studentNo": "20202468",
      "course": "BSCS",
      "college": "CAS",
      "hasSymptoms": true
    },
    {
      "name": "Juan Tamad",
      "studentNo": "20202468",
      "course": "BSCS",
      "college": "CAS",
      "hasSymptoms": false
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Icon(Symbols.face, color: Color(0xFFFB6962), size: 40),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0),
              child: Text("Students",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFFFB6962))),
            ),
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
      body: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20, top: 20),
            child: TextField(
              onChanged: (value) {
                // Handle text change
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _listNames.length,
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MonitoringDetails(
                                  mapDetails: _listNames[index])));
                    },
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _getHealthStatus(_listNames[index]["hasSymptoms"]!),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(_listNames[index]["name"]!,
                                style: TextStyle(fontSize: 17.0)),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text(
                                "Quarantined on: " + "18/05/2023 11:53am",
                                style: TextStyle(fontStyle: FontStyle.italic)),
                          ),
                        ],
                      ),
                    ),
                  );
                })),
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
