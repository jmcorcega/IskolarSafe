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
                  child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Symbols.edit_document_rounded),
                  SizedBox(width: 12.0),
                  Text("Edit Requests"),
                ],
              )),
              Tab(
                  child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Symbols.scan_delete_rounded),
                  SizedBox(width: 12.0),
                  Text("Delete Requests"),
                ],
              ))
            ]),
          ),
          body: TabBarView(
            children: [
              _editDeleteListView("edit"),
              _editDeleteListView("delete")
            ],
          )),
    );
  }

  Widget _editDeleteListView(String type) {
    return ListView.builder(
        itemCount: _listNames.length,
        itemBuilder: ((context, index) {
          return _editDeleteListTile(type, _listNames[index]["hasEditRequest"],
              _listNames[index]["hasDeleteRequest"], _listNames[index]["name"]);
        }));
  }

  Widget _editDeleteListTile(
      String type, bool hasEditRequest, bool hasDeleteRequest, String name) {
    if (type == "edit") {
      if (hasEditRequest) {
        return ListTile(
          onTap: () {},
          contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
          leading: SizedBox(
            height: double.infinity,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(name.toString().substring(0, 1),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary)),
            ),
          ),
          minLeadingWidth: 44.0,
          title: _editDeleteRequest(name, type),
          subtitle: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 110.0,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                      padding: EdgeInsets.all(0),
                      backgroundColor: Theme.of(context).colorScheme.primary),
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
                      foregroundColor: Theme.of(context).colorScheme.tertiary),
                  onPressed: () {},
                  icon: const Icon(Symbols.close_rounded),
                  label: const Text("Reject"),
                ),
              ),
            ],
          ),
        );
      }
    } else {
      if (hasDeleteRequest) {
        return ListTile(
          onTap: () {},
          contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
          leading: SizedBox(
            height: double.infinity,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(name.toString().substring(0, 1),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary)),
            ),
          ),
          minLeadingWidth: 44.0,
          title: _editDeleteRequest(name, type),
          subtitle: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 110.0,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                      padding: EdgeInsets.all(0),
                      backgroundColor: Theme.of(context).colorScheme.primary),
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
                      foregroundColor: Theme.of(context).colorScheme.tertiary),
                  onPressed: () {},
                  icon: const Icon(Symbols.close_rounded),
                  label: const Text("Reject"),
                ),
              ),
            ],
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }

  Widget _editDeleteRequest(String name, String type) {
    if (type == "edit") {
      return Text(name);
    } else {
      return Text(name);
    }
  }
}
