import 'dart:core';

import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/extensions.dart';
import 'package:iskolarsafe/theme.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:iskolarsafe/models/entry_model.dart';

import 'package:collection/collection.dart';
import 'package:iskolarsafe/models/entry_model.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
import 'package:iskolarsafe/providers/entries_provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:iskolarsafe/college_data.dart';

class EditDeleteRequests extends StatefulWidget {
  static const String routeName = "/edit-delete";

  const EditDeleteRequests({super.key});

  @override
  State<EditDeleteRequests> createState() => _EditDeleteRequestsState();
}

class _EditDeleteRequestsState extends State<EditDeleteRequests> {
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

Widget _buttons(context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary,
          minimumSize: const Size(225.0, 47.5),
        ),
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: Text("Are you sure you want approve their edit request?",
                  style: Theme.of(context).textTheme.bodyMedium),
              actions: <Widget>[
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Symbols.close_rounded),
                  label: const Text('Cancel'),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: const Size(225.0, 47.5),
                  ),
                  onPressed: () {},
                  icon: const Icon(Symbols.scan_delete_rounded),
                  label: const Text('Approve'),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Symbols.edit_document_rounded),
        label: const Text("Approve"),
      ),
      const SizedBox(height: 12.0),
      FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          minimumSize: const Size(225.0, 47.5),
        ),
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: Text(
                  "Are you sure you want to reject their edit request?",
                  style: Theme.of(context).textTheme.bodyMedium),
              actions: <Widget>[
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Symbols.close_rounded),
                  label: const Text('Cancel'),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: const Size(225.0, 47.5),
                  ),
                  onPressed: () {},
                  icon: const Icon(Symbols.scan_delete_rounded),
                  label: const Text('Reject'),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Symbols.scan_delete_rounded, size: 18.0),
        label: const Text("Reject"),
      ),
    ],
  );
}

class EditRequest extends StatelessWidget {
  final Map<dynamic, dynamic> info;
  EditRequest({super.key, required this.info});

  final _entryFormState = GlobalKey<FormState>();

  bool? isExposed;
  bool? isWaitingForRtPcr;
  bool? isWaitingForRapidAntigen;

  bool _deferEditing = false;
  IskolarInfo? userInfo;

  // IskolarHealthStatus getVerdict() {
  //   if (fluSymptoms.length > 1) return IskolarHealthStatus.notWell;
  //   if (respiratorySymptoms.length > 1) return IskolarHealthStatus.notWell;
  //   if (otherSymptoms.length > 1) return IskolarHealthStatus.notWell;

  //   if (!fluSymptoms.contains(FluSymptom.none)) {
  //     return IskolarHealthStatus.notWell;
  //   }

  //   if (!respiratorySymptoms.contains(RespiratorySymptom.none)) {
  //     return IskolarHealthStatus.notWell;
  //   }

  //   if (!otherSymptoms.contains(OtherSymptom.none)) {
  //     return IskolarHealthStatus.notWell;
  //   }

  //   return IskolarHealthStatus.healthy;
  // }

  // void saveEntry() async {
  //   if (_entryFormState.currentState!.validate()) {
  //     // Save the form
  //     _entryFormState.currentState?.save();

  //     HealthEntry newEntry = HealthEntry(
  //       userInfo: userInfo!,
  //       userId: userInfo!.id!,
  //       dateGenerated: DateTime.now(),
  //       fluSymptoms: fluSymptoms,
  //       respiratorySymptoms: respiratorySymptoms,
  //       otherSymptoms: otherSymptoms,
  //       exposed: isExposed!,
  //       waitingForRtPcr: isWaitingForRtPcr!,
  //       waitingForRapidAntigen: isWaitingForRapidAntigen!,
  //       verdict: getVerdict(),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    List<FluSymptom> fluSymptoms =
        info["fluSymptoms"] + info["updated"]["fluSymptoms"];
    List<RespiratorySymptom> respiratorySymptoms =
        info["respiratorySymptoms"] + info["updated"]["respiratorySymptoms"];
    List<OtherSymptom> otherSymptoms =
        info["otherSymptoms"] + info["updated"]["otherSymptoms"];
    return Form(
      key: _entryFormState,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 200.0, minWidth: 200.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18.0),
              Center(
                child: Text("Entry",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .apply(fontWeightDelta: 1)),
              ),
              // Flu-like symptoms
              const SizedBox(height: 24.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Symbols.sick_rounded),
                      const SizedBox(width: 12.0),
                      Text(
                        "Flu-like Symptoms",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .apply(fontWeightDelta: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "Feeling sick today? Tick all those that apply.",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Wrap(
                spacing: 5.0,
                children: FluSymptom.values.map((FluSymptom symptom) {
                  String name = FluSymptom.getName(symptom);
                  return FilterChip(
                      label: Text(name),
                      selectedColor: _changeChipColor(context, symptom),
                      selected: fluSymptoms.contains(symptom),
                      onSelected: (bool selected) {});
                }).toList(),
              ),
              const SizedBox(height: 20.0),

              // Respiratory symptoms
              const SizedBox(height: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Symbols.pulmonology_rounded),
                      const SizedBox(width: 12.0),
                      Text(
                        "Respiratory Symptoms",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .apply(fontWeightDelta: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "Hard to breathe? Coughing? Tick all those that apply.",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Wrap(
                spacing: 5.0,
                children:
                    RespiratorySymptom.values.map((RespiratorySymptom symptom) {
                  String name = RespiratorySymptom.getName(symptom);
                  return FilterChip(
                      label: Text(name),
                      selectedColor: _changeChipColor(context, symptom),
                      selected: respiratorySymptoms.contains(symptom),
                      onSelected: (bool selected) {});
                }).toList(),
              ),
              const SizedBox(height: 20.0),

              // Other symptoms
              const SizedBox(height: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Symbols.help_clinic_rounded),
                      const SizedBox(width: 12.0),
                      Text(
                        "Other Symptoms",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .apply(fontWeightDelta: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "Are you currently experiencing any of the following? Tick all those that apply.",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Wrap(
                spacing: 5.0,
                children: OtherSymptom.values.map((OtherSymptom symptom) {
                  String name = OtherSymptom.getName(symptom);
                  return FilterChip(
                      label: Text(name),
                      selectedColor: _changeChipColor(context, symptom),
                      selected: otherSymptoms.contains(symptom),
                      onSelected: (bool selected) {});
                }).toList(),
              ),
              const SizedBox(height: 20.0),

              // Exposure Report
              const Divider(),
              const SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Symbols.coronavirus_rounded),
                      const SizedBox(width: 12.0),
                      Text(
                        "Exposure Report",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .apply(fontWeightDelta: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "Did you have a face-to-face encounter or contact with a confirmed COVID-19 case within 1 meter and for more than 15 minutes; or direct care for a patient with a probable or confirmed COVID-19 case?",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('No'),
                      textColor: _changeRadioColor(context, false, false,
                          info["exposed"], info["updated"]["exposed"]),
                      leading: Radio<bool>(
                        activeColor: _changeRadioColor(context, true, false,
                            info["exposed"], info["updated"]["exposed"]),
                        value: false,
                        groupValue: (!info["exposed"])
                            ? info["exposed"]
                            : info["updated"]["exposed"],
                        onChanged: (bool? value) {
                          // setState(() {
                          //   isExposed = value!;
                          // });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Yes'),
                      textColor: _changeRadioColor(context, false, true,
                          info["exposed"], info["updated"]["exposed"]),
                      leading: Radio<bool>(
                        activeColor: _changeRadioColor(context, true, true,
                            info["exposed"], info["updated"]["exposed"]),
                        value: true,
                        groupValue: (info["exposed"])
                            ? info["exposed"]
                            : info["updated"]["exposed"],
                        onChanged: (bool? value) {
                          // setState(() {
                          //   isExposed = value!;
                          // });
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // RT-PCR test
              const SizedBox(height: 12.0),
              const Divider(),
              const SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Symbols.ent_rounded),
                      const SizedBox(width: 12.0),
                      Text(
                        "RT-PCR Test",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .apply(fontWeightDelta: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "Are you waiting for an RT-PCR result?",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('No'),
                      textColor: _changeRadioColor(
                          context,
                          false,
                          false,
                          info["waitingForRtPcr"],
                          info["updated"]["waitingForRtPcr"]),
                      leading: Radio<bool>(
                        activeColor: _changeRadioColor(
                            context,
                            true,
                            false,
                            info["waitingForRtPcr"],
                            info["updated"]["waitingForRtPcr"]),
                        value: false,
                        groupValue: (!info["waitingForRtPcr"])
                            ? info["waitingForRtPcr"]
                            : info["updated"]["waitingForRtPcr"],
                        onChanged: (bool? value) {
                          // setState(() {
                          //   isWaitingForRtPcr = value!;
                          // });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Yes'),
                      textColor: _changeRadioColor(
                          context,
                          false,
                          true,
                          info["waitingForRtPcr"],
                          info["updated"]["waitingForRtPcr"]),
                      leading: Radio<bool>(
                        activeColor: _changeRadioColor(
                            context,
                            true,
                            true,
                            info["waitingForRtPcr"],
                            info["updated"]["waitingForRtPcr"]),
                        value: true,
                        groupValue: (info["waitingForRtPcr"])
                            ? info["waitingForRtPcr"]
                            : info["updated"]["waitingForRtPcr"],
                        onChanged: (bool? value) {
                          // setState(() {
                          //   isWaitingForRtPcr = value!;
                          // });
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // Rapid Antigen Test
              const SizedBox(height: 12.0),
              const Divider(),
              const SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Symbols.labs_rounded),
                      const SizedBox(width: 12.0),
                      Expanded(
                          child: Text(
                        "Rapid Antigen Test",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .apply(fontWeightDelta: 1),
                      )),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "Did you undergo a Rapid Antigen Test for COVID-19?",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('No'),
                      textColor: _changeRadioColor(
                          context,
                          false,
                          false,
                          info["waitingForRapidAntigen"],
                          info["updated"]["waitingForRapidAntigen"]),
                      leading: Radio<bool>(
                        activeColor: _changeRadioColor(
                            context,
                            true,
                            false,
                            info["waitingForRapidAntigen"],
                            info["updated"]["waitingForRapidAntigen"]),
                        value: false,
                        groupValue: (!info["waitingForRapidAntigen"])
                            ? info["waitingForRapidAntigen"]
                            : info["updated"]["waitingForRapidAntigen"],
                        onChanged: (bool? value) {
                          // setState(() {
                          //   isWaitingForRapidAntigen = value!;
                          // });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Yes'),
                      textColor: _changeRadioColor(
                          context,
                          false,
                          true,
                          info["waitingForRapidAntigen"],
                          info["updated"]["waitingForRapidAntigen"]),
                      leading: Radio<bool>(
                        activeColor: _changeRadioColor(
                            context,
                            true,
                            true,
                            info["waitingForRapidAntigen"],
                            info["updated"]["waitingForRapidAntigen"]),
                        value: true,
                        groupValue: (info["waitingForRapidAntigen"])
                            ? info["waitingForRapidAntigen"]
                            : info["updated"]["waitingForRapidAntigen"],
                        onChanged: (bool? value) {},
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 72.0),
              _buttons(context),
              const SizedBox(height: 72.0),
            ],
          ),
        ),
      ),
    );
  }

  Color _changeChipColor(BuildContext context, dynamic symptom) {
    Color original = Theme.of(context).colorScheme.tertiaryContainer;
    Color changed = Theme.of(context).colorScheme.inversePrimary;

    for (dynamic updated in info["updated"]
        ["${symptom.runtimeType.toString().lowercaseFirstLetter()}s"]) {
      if (symptom == updated) {
        return changed;
      }
    }

    for (dynamic orig
        in info["${symptom.runtimeType.toString().lowercaseFirstLetter()}s"]) {
      if (symptom == orig) {
        return original;
      }
    }

    return original;
  }

  Color _changeRadioColor(
      BuildContext context, bool radio, bool value, bool orig, bool updated) {
    Color original = Theme.of(context).colorScheme.tertiary;
    Color changed = Theme.of(context).colorScheme.primary;

    if (orig != updated) {
      if (orig == value) {
        return changed;
      } else if (updated == value) {
        return original;
      }
    } else {
      if (orig == value) {
        return changed;
      }
    }
    return (radio) ? changed : Theme.of(context).colorScheme.onBackground;
  }
}
