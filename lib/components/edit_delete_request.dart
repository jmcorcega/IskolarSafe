import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:material_symbols_icons/symbols.dart';

class EditDeleteRequest extends StatefulWidget {
  static const String routeName = "/edit-delete";

  const EditDeleteRequest({super.key});

  @override
  State<EditDeleteRequest> createState() => _EditDeleteRequestState();
}

class _EditDeleteRequestState extends State<EditDeleteRequest> {
  final List<Map<dynamic, dynamic>> _listNames = [
    {
      "name": "Mang Juan",
      "studentNo": "20205678",
      "course": "BS Stat",
      "college": "CAS",
      "hasSymptoms": false,
      "isQuarantined": true,
      "isUnderMonitoring": false,
      "hasEditRequest": true,
      "hasDeleteRequest": true
    },
    {
      "name": "Maam Juana",
      "studentNo": "20219658",
      "course": "BS Chemistry",
      "college": "CAS",
      "hasSymptoms": false,
      "isQuarantined": true,
      "isUnderMonitoring": false,
      "hasEditRequest": false,
      "hasDeleteRequest": false
    },
    {
      "name": "Mami Juan",
      "studentNo": "20205348",
      "course": "BS Stat",
      "college": "CAS",
      "hasSymptoms": true,
      "isQuarantined": false,
      "isUnderMonitoring": true,
      "hasEditRequest": true,
      "hasDeleteRequest": false
    },
    {
      "name": "Marie Claire",
      "studentNo": "20213241",
      "course": "BS Stat",
      "college": "CAS",
      "hasSymptoms": true,
      "isQuarantined": false,
      "isUnderMonitoring": true,
      "hasEditRequest": false,
      "hasDeleteRequest": true
    },
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Container(
                margin: const EdgeInsets.only(right: 100.0),
                child: const AppBarHeader(
                    icon: Symbols.article_rounded, title: "Requests")),
            bottom: const TabBar(tabs: [
              Tab(
                  icon: Icon(Symbols.edit_document_rounded),
                  child: Text("Edit Requests")),
              Tab(
                  icon: Icon(Symbols.scan_delete_rounded),
                  child: Text("Delete Requests"))
            ]),
          ),
          body: TabBarView(
            children: [
              _editDeleteListTile("edit"),
              _editDeleteListTile("delete")
            ],
          )),
    );
  }

  Widget _editDeleteListTile(String type) {
    return ListView.builder(
        itemCount: _listNames.length,
        itemBuilder: ((context, index) {
          return (_listNames[index][
                      "hasEditRequest"] || //check if has edit or delete request
                  _listNames[index]["hasDeleteRequest"])
              ? ListTile(
                  onTap: () {},
                  contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
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
                  title: _editDeleteRequest(_listNames[index]["name"], type),
                  subtitle: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 110.0,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary),
                          onPressed: () {},
                          icon: const Icon(Symbols.done, size: 18.0),
                          label: const Text("Approve"),
                        ),
                      ),
                      SizedBox(width: 12.0),
                      SizedBox(
                        width: 110.0,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              foregroundColor:
                                  Theme.of(context).colorScheme.tertiary),
                          onPressed: () {},
                          icon: const Icon(Symbols.close_rounded),
                          label: const Text("Reject"),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink();
        }));
  }

  Widget _editDeleteRequest(String name, String type) {
    if (type == "edit") {
      return Text(name);
    } else {
      return Text(name);
    }
  }
}
