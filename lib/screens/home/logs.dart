// Name
// Action (diff color) Monitor Name
// Date

import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/request.dart';
import 'package:iskolarsafe/components/user_details.dart';
import 'package:material_symbols_icons/symbols.dart';

class Logs extends StatefulWidget {
  static const String routeName = "/logs";

  const Logs({super.key});

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  TextEditingController _search = new TextEditingController();

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
        leading: const Request(),
        centerTitle: true,
        title: const AppBarHeader(
          icon: Symbols.quick_reference_all_rounded,
          title: "Logs",
          hasAction: false,
        ),
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
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => DraggableScrollableSheet(
                    snap: true,
                    initialChildSize: 0.50,
                    maxChildSize: 0.95,
                    minChildSize: 0.4,
                    expand: false,
                    builder: (context, scrollController) {
                      return SingleChildScrollView(
                          controller: scrollController,
                          child: UserDetails(
                              userDetails: _listNames[index],
                              isQuarantined: _listNames[index]["isQuarantined"],
                              isUnderMonitoring: _listNames[index]
                                  ["isUnderMonitoring"]));
                    }),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text("Scan user's entry"),
        icon: const Icon(Symbols.qr_code_scanner_rounded),
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
