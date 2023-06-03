import 'dart:core';

import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/edit_request.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:iskolarsafe/models/entry_model.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/college_data.dart';

class Requests extends StatefulWidget {
  static const String routeName = "/edit-delete";

  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  static final IskolarInfo fakeInfo2 = IskolarInfo(
    status: IskolarHealthStatus.notWell,
    firstName: "Juan",
    lastName: "Tamad",
    userName: "jtamad",
    studentNumber: "0000-00000",
    course: "BS Computer Science",
    college: CollegeData.colleges[1],
    condition: ["Hypertension", "Diabetes"],
    allergies: ["Allergy 1", "Allergy 2"],
  );
  static final IskolarInfo fakeInfo3 = IskolarInfo(
    status: IskolarHealthStatus.notWell,
    firstName: "Jane",
    lastName: "Doe",
    userName: "jdoe",
    studentNumber: "0000-00000",
    course: "BS Computer Science",
    college: CollegeData.colleges[1],
    condition: [],
    allergies: [],
  );

  static final IskolarInfo fakeInfo4 = IskolarInfo(
    status: IskolarHealthStatus.notWell,
    firstName: "Mark",
    lastName: "Mark",
    userName: "mmark",
    studentNumber: "0000-00000",
    course: "BS Computer Science",
    college: CollegeData.colleges[1],
    condition: [],
    allergies: [],
  );
  final List<Map<dynamic, dynamic>> _listNames = [
    {
      "userInfo": fakeInfo2,
      "fluSymptoms": [FluSymptom.none],
      "respiratorySymptoms": [RespiratorySymptom.none],
      "otherSymptoms": [OtherSymptom.none],
      "exposed": true,
      "waitingForRtPcr": false,
      "waitingForRapidAntigen": false,
      "forDeletion": false,
      "verdict": IskolarHealthStatus.notWell,
      "updated": {
        "userInfo": fakeInfo2,
        "fluSymptoms": [FluSymptom.feverish],
        "respiratorySymptoms": [RespiratorySymptom.none],
        "otherSymptoms": [OtherSymptom.none],
        "exposed": true,
        "waitingForRtPcr": true,
        "waitingForRapidAntigen": false,
        "verdict": IskolarHealthStatus.notWell,
      }
    },
    {
      "userInfo": fakeInfo3,
      "fluSymptoms": [FluSymptom.feverish],
      "respiratorySymptoms": [RespiratorySymptom.none],
      "otherSymptoms": [OtherSymptom.none],
      "exposed": false,
      "waitingForRtPcr": false,
      "waitingForRapidAntigen": false,
      "forDeletion": true,
      "verdict": IskolarHealthStatus.notWell,
    },
    {
      "userInfo": fakeInfo4,
      "fluSymptoms": [FluSymptom.none],
      "respiratorySymptoms": [RespiratorySymptom.colds],
      "otherSymptoms": [OtherSymptom.none],
      "exposed": false,
      "waitingForRtPcr": true,
      "waitingForRapidAntigen": false,
      "forDeletion": false,
      "verdict": IskolarHealthStatus.notWell,
      "updated": {
        "userInfo": fakeInfo4,
        "fluSymptoms": [FluSymptom.musclePains],
        "respiratorySymptoms": [
          RespiratorySymptom.cough,
          RespiratorySymptom.colds
        ],
        "otherSymptoms": [OtherSymptom.none],
        "exposed": false,
        "waitingForRtPcr": false,
        "waitingForRapidAntigen": false,
        "verdict": IskolarHealthStatus.monitored,
      }
    }
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
          return _editDeleteListTile(
              _listNames[index],
              type,
              _listNames[index]["forDeletion"],
              "${_listNames[index]["userInfo"].firstName} ${_listNames[index]["userInfo"].lastName}");
        }));
  }

  Widget _approveRejectButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 110.0,
          height: 27.0,
          margin: const EdgeInsets.only(top: 10.0),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(0),
                backgroundColor: Theme.of(context).colorScheme.primary),
            onPressed: () {},
            icon: const Icon(Symbols.done, size: 18.0),
            label: const Text("Approve"),
          ),
        ),
        const SizedBox(width: 12.0),
        Container(
          width: 110.0,
          height: 27.0,
          margin: const EdgeInsets.only(top: 10.0),
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(0),
                foregroundColor: Theme.of(context).colorScheme.tertiary),
            onPressed: () {},
            icon: const Icon(Symbols.close_rounded),
            label: const Text("Reject"),
          ),
        ),
      ],
    );
  }

  Widget _editDeleteListTile(
      Map<dynamic, dynamic> info, String type, bool forDeletion, String name) {
    if (type == "edit") {
      if (!forDeletion) {
        return ListTile(
          onTap: () {
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
                      child: EditRequest(info: info),
                    );
                  }),
            );
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
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
          subtitle: _approveRejectButtons(),
        );
      }
    } else {
      if (forDeletion) {
        return ListTile(
          onTap: () {},
          contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
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
          subtitle: _approveRejectButtons(),
        );
      }
    }
    return const SizedBox.shrink();
  }

  Widget _editDeleteRequest(String name, String type) {
    if (type == "edit") {
      return Text(name, style: Theme.of(context).textTheme.titleMedium);
    } else {
      return Text(name, style: Theme.of(context).textTheme.titleMedium);
    }
  }
}
