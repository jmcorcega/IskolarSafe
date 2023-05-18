// Name
// Action (diff color) Monitor Name
// Date


import 'package:flutter/material.dart';
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
        // centerTitle: true,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [ // add textfield here ok and then icon for search and then icon again for log out
           SizedBox(
            width: MediaQuery.of(context).size.width * 3/4,
            height: 40,
            child: TextField(
            controller: _search,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            border: InputBorder.none,
            hintText: 'Search logs...',
                   ),),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          _listNames[index]["name"]!,
                          style: TextStyle(fontSize: 17.0)),
                      ),            
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Text("Created pass on " + "18/05/2023 11:53am", style: TextStyle(fontStyle: FontStyle.italic)),
                      ),  
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Text(_listNames[index]["college"], style: TextStyle(fontStyle: FontStyle.italic)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Text(_listNames[index]["studentNo"], style: TextStyle(fontStyle: FontStyle.italic)),
                      ),
                      
                    ],
                  ),
                ),
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