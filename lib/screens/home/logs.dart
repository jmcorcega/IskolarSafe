// Name
// Action (diff color) Monitor Name
// Date

import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:material_symbols_icons/symbols.dart';

class Logs extends StatefulWidget {
  static const String routeName = "/logs";

  const Logs({super.key});

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  TextEditingController _search = new TextEditingController();

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
        centerTitle: true,
        title: const AppBarHeader(
            icon: Symbols.quick_reference_all_rounded, title: "Logs"),
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
                    hintText: "Search for logs",
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
      body: ListView.builder(
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
                Text(
                  "18/05/2023 11:53am",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            isThreeLine: true,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MonitoringDetails(mapDetails: _listNames[index])));
            },
          );
        }),
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
