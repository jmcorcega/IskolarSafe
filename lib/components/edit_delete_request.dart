import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:iskolarsafe/models/entry_model.dart';

import 'package:collection/collection.dart';
import 'package:iskolarsafe/models/entry_model.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
import 'package:iskolarsafe/providers/entries_provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class EditDeleteRequests extends StatefulWidget {
  static const String routeName = "/edit-delete";

  const EditDeleteRequests({super.key});

  @override
  State<EditDeleteRequests> createState() => _EditDeleteRequestsState();
}

class _EditDeleteRequestsState extends State<EditDeleteRequests> {
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
      "editRequest": {
        'fluSymptoms': {
          "orig": FluSymptom.none,
          "changed": FluSymptom.feverish
        },
        'respiratorySymptoms': {
          "orig": RespiratorySymptom.cough,
          "changed": RespiratorySymptom.cough
        },
        'otherSymptoms': {
          "orig": OtherSymptom.none,
          "changed": OtherSymptom.none
        },
        'exposed': {"orig": false, "changed": true},
        'waitingForRtPcr': {"orig": false, "changed": false},
        'waitingForRapidAntigen': {"orig": false, "changed": false}
      },
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
      'editRequest': null,
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
      "editRequest": {
        'fluSymptom': FluSymptom.none,
        'respiratorySymptoms': RespiratorySymptom.cough,
        'otherSymptoms': OtherSymptom.lossOfTaste,
        'exposed': true,
        'waitingForRtPcr': false,
        'waitingForRapidAntigen': false
      },
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
      "hasDeleteRequest": true,
      "deleteRequest": {
        'fluSymptom': FluSymptom.none,
        'respiratorySymptoms': RespiratorySymptom.cough,
        'otherSymptoms': OtherSymptom.lossOfTaste,
        'exposed': true,
        'waitingForRtPcr': false,
        'waitingForRapidAntigen': false
      },
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
                      child: EditRequest(),
                    );
                  }),
            );
          },
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
          onTap: () {
            // showDialog<String>(
            //     context: context,
            //     builder: (BuildContext context) =>
            //         Container(height: 150, width: 300, child: EditRequest()));

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
                      child: EditRequest(),
                    );
                  }),
            );
          },
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
  EditRequest({super.key});

  final _entryFormState = GlobalKey<FormState>();

  List<FluSymptom> fluSymptoms = [];
  List<RespiratorySymptom> respiratorySymptoms = [];
  List<OtherSymptom> otherSymptoms = [];

  bool? isExposed;
  bool? isWaitingForRtPcr;
  bool? isWaitingForRapidAntigen;

  bool _deferEditing = false;
  IskolarInfo? userInfo;

  IskolarHealthStatus getVerdict() {
    if (fluSymptoms.length > 1) return IskolarHealthStatus.notWell;
    if (respiratorySymptoms.length > 1) return IskolarHealthStatus.notWell;
    if (otherSymptoms.length > 1) return IskolarHealthStatus.notWell;

    if (!fluSymptoms.contains(FluSymptom.none)) {
      return IskolarHealthStatus.notWell;
    }

    if (!respiratorySymptoms.contains(RespiratorySymptom.none)) {
      return IskolarHealthStatus.notWell;
    }

    if (!otherSymptoms.contains(OtherSymptom.none)) {
      return IskolarHealthStatus.notWell;
    }

    return IskolarHealthStatus.healthy;
  }

  void saveEntry() async {
    if (_entryFormState.currentState!.validate()) {
      // Save the form
      _entryFormState.currentState?.save();

      HealthEntry newEntry = HealthEntry(
        userInfo: userInfo!,
        userId: userInfo!.id!,
        dateGenerated: DateTime.now(),
        fluSymptoms: fluSymptoms,
        respiratorySymptoms: respiratorySymptoms,
        otherSymptoms: otherSymptoms,
        exposed: isExposed!,
        waitingForRtPcr: isWaitingForRtPcr!,
        waitingForRapidAntigen: isWaitingForRapidAntigen!,
        verdict: getVerdict(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    late final Future<IskolarInfo?> _userInfoFuture =
        context.read<AccountsProvider>().userInfo;
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
              const SizedBox(height: 12.0),
              Center(
                child: Text("Entry",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .apply(fontWeightDelta: 2)),
              ),
              // Flu-like symptoms
              const SizedBox(height: 12.0),
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
                    selected: fluSymptoms.contains(symptom),
                    onSelected:
                        // chipEnabled(symptom)
                        //     ? (bool selected) {
                        //         setState(() {
                        //           if (selected) {
                        //             if (symptom == FluSymptom.none) {
                        //               fluSymptoms.clear();
                        //             }

                        //             fluSymptoms.add(symptom);
                        //           } else {
                        //             fluSymptoms.remove(symptom);
                        //           }
                        //         });
                        // }
                        // :
                        null,
                  );
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
                    selected: respiratorySymptoms.contains(symptom),
                    onSelected:
                        // chipEnabled(symptom)
                        //     ? (bool selected) {
                        //         setState(() {
                        //           if (selected) {
                        //             if (symptom == RespiratorySymptom.none) {
                        //               respiratorySymptoms.clear();
                        //             }
                        //             respiratorySymptoms.add(symptom);
                        //           } else {
                        //             respiratorySymptoms.remove(symptom);
                        //           }
                        //         });
                        //       }
                        //     :
                        null,
                  );
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
                    selected: otherSymptoms.contains(symptom),
                    onSelected:
                        // chipEnabled(symptom)
                        //     ? (bool selected) {
                        //         setState(() {
                        //           if (symptom == OtherSymptom.none) {
                        //             otherSymptoms.clear();
                        //           }
                        //           if (selected) {
                        //             otherSymptoms.add(symptom);
                        //           } else {
                        //             otherSymptoms.remove(symptom);
                        //           }
                        //         });
                        //       }
                        //     :
                        null,
                  );
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
                      leading: Radio<bool>(
                        value: false,
                        groupValue: isExposed,
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
                      leading: Radio<bool>(
                        value: true,
                        groupValue: isExposed,
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
                      leading: Radio<bool>(
                        value: false,
                        groupValue: isWaitingForRtPcr,
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
                      leading: Radio<bool>(
                        value: true,
                        groupValue: isWaitingForRtPcr,
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
                      leading: Radio<bool>(
                        value: false,
                        groupValue: isWaitingForRapidAntigen,
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
                      leading: Radio<bool>(
                        value: true,
                        groupValue: isWaitingForRtPcr,
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
}
