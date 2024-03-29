import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/models/entry_model.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
import 'package:iskolarsafe/providers/entries_provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class EntryEditor extends StatefulWidget {
  static const String routeName = "/entry/edit";
  final HealthEntry? entry;
  const EntryEditor({Key? key, required this.entry}) : super(key: key);

  @override
  _EntryEditorState createState() => _EntryEditorState();
}

class _EntryEditorState extends State<EntryEditor> {
  late final IskolarInfo? userInfo = context.read<AccountsProvider>().userInfo;
  final _entryFormState = GlobalKey<FormState>();

  List<FluSymptom> fluSymptoms = [];
  List<RespiratorySymptom> respiratorySymptoms = [];
  List<OtherSymptom> otherSymptoms = [];

  bool isExposed = false;
  bool isWaitingForRtPcr = false;
  bool isWaitingForRapidAntigen = false;

  bool _deferEditing = false;

  bool checkChanges() {
    HealthEntry? entry = widget.entry;
    if (entry == null) return true;

    if (isExposed != entry.exposed) return true;
    if (isWaitingForRtPcr != entry.waitingForRtPcr) return true;
    if (isWaitingForRapidAntigen != entry.waitingForRapidAntigen) return true;

    return false;
  }

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
    setState(() {
      _deferEditing = true;
    });
    if (_entryFormState.currentState!.validate()) {
      // Save the form
      _entryFormState.currentState?.save();

      var oldEntry = widget.entry;
      HealthEntry newEntry = HealthEntry(
        userInfo: userInfo!,
        userId: userInfo!.id!,
        dateGenerated: DateTime.now(),
        fluSymptoms: fluSymptoms,
        respiratorySymptoms: respiratorySymptoms,
        otherSymptoms: otherSymptoms,
        exposed: isExposed,
        waitingForRtPcr: isWaitingForRtPcr,
        waitingForRapidAntigen: isWaitingForRapidAntigen,
        verdict: getVerdict(),
      );

      if (oldEntry != null) {
        newEntry.id = oldEntry.id;
      }

      if (oldEntry == null && newEntry.verdict == IskolarHealthStatus.notWell) {
        await context
            .read<AccountsProvider>()
            .updateStatus(IskolarHealthStatus.monitored, userInfo!);
      }

      if (context.mounted) {
        if (oldEntry == null) {
          await context.read<HealthEntryProvider>().addEntry(newEntry);
        } else {
          await context.read<HealthEntryProvider>().editEntry(newEntry);
        }

        if (context.mounted) {
          var status = context.read<HealthEntryProvider>().status;

          if (status) {
            var snackBar = SnackBar(
              behavior: SnackBarBehavior.floating,
              content: oldEntry == null
                  ? const Text('New entry added successfully.')
                  : const Text(
                      'Entry edited successfully. Please wait for an officer to approve your request.'),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pop(context);
            if (oldEntry != null) {
              Navigator.pop(context);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('An error has occured. Try again later.'),
            ));
          }
        }
      }
    }

    setState(() {
      _deferEditing = false;
    });
  }

  bool chipEnabled(dynamic symptom) {
    bool fluNone = fluSymptoms.contains(FluSymptom.none);
    bool respiratoryNone =
        respiratorySymptoms.contains(RespiratorySymptom.none);
    bool otherNone = otherSymptoms.contains(OtherSymptom.none);

    if (_deferEditing) return false;

    if (symptom == FluSymptom.none ||
        symptom == RespiratorySymptom.none ||
        symptom == OtherSymptom.none) {
      return true;
    }

    if (fluNone && symptom is FluSymptom) return false;
    if (respiratoryNone && symptom is RespiratorySymptom) return false;
    if (otherNone && symptom is OtherSymptom) return false;

    return true;
  }

  Widget _buildHeader() {
    if (widget.entry != null) {
      return const AppBarHeader(
        icon: Symbols.edit_rounded,
        title: "Edit Entry",
        hasAction: false,
      );
    }

    return const AppBarHeader(
      icon: Symbols.add_circle_rounded,
      title: "New Entry",
      hasAction: false,
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    if (widget.entry != null) {
      return FloatingActionButton.extended(
        backgroundColor:
            _deferEditing ? Theme.of(context).colorScheme.background : null,
        foregroundColor: _deferEditing
            ? Theme.of(context).colorScheme.onBackground.withOpacity(0.75)
            : null,
        onPressed: _deferEditing ? null : saveEntry,
        label: const Text("Save entry"),
        icon: const Icon(Symbols.save_rounded),
      );
    }

    return FloatingActionButton.extended(
      backgroundColor:
          _deferEditing ? Theme.of(context).colorScheme.background : null,
      foregroundColor: _deferEditing
          ? Theme.of(context).colorScheme.onBackground.withOpacity(0.75)
          : null,
      onPressed: _deferEditing ? null : saveEntry,
      label: const Text("Submit entry"),
      icon: const Icon(Symbols.send_rounded),
    );
  }

  @override
  initState() {
    super.initState();
    var entry = widget.entry;
    if (entry != null) {
      fluSymptoms = entry.fluSymptoms!;
      respiratorySymptoms = entry.respiratorySymptoms!;
      otherSymptoms = entry.otherSymptoms!;
      isExposed = isExposed || entry.exposed;
      isWaitingForRtPcr = isWaitingForRtPcr || entry.waitingForRtPcr;
      isWaitingForRapidAntigen =
          isWaitingForRapidAntigen || entry.waitingForRapidAntigen;
    }
    checkChanges();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (checkChanges()) {
          bool shouldPop = false;
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Discard changes'),
              content: const Text('Are you sure you want to discard changes?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    shouldPop = false;
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    shouldPop = true;
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );

          return shouldPop;
        }

        return true;
      },
      child: _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _buildHeader(),
      ),
      body: Form(
        key: _entryFormState,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    onSelected: chipEnabled(symptom)
                        ? (bool selected) {
                            setState(() {
                              if (selected) {
                                if (symptom == FluSymptom.none) {
                                  fluSymptoms.clear();
                                }

                                fluSymptoms.add(symptom);
                              } else {
                                fluSymptoms.remove(symptom);
                              }
                            });
                          }
                        : null,
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
                    onSelected: chipEnabled(symptom)
                        ? (bool selected) {
                            setState(() {
                              if (selected) {
                                if (symptom == RespiratorySymptom.none) {
                                  respiratorySymptoms.clear();
                                }
                                respiratorySymptoms.add(symptom);
                              } else {
                                respiratorySymptoms.remove(symptom);
                              }
                            });
                          }
                        : null,
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
                    onSelected: chipEnabled(symptom)
                        ? (bool selected) {
                            setState(() {
                              if (symptom == OtherSymptom.none) {
                                otherSymptoms.clear();
                              }
                              if (selected) {
                                otherSymptoms.add(symptom);
                              } else {
                                otherSymptoms.remove(symptom);
                              }
                            });
                          }
                        : null,
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
                        onChanged: _deferEditing
                            ? null
                            : (bool? value) {
                                setState(() {
                                  isExposed = value!;
                                });
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
                        onChanged: _deferEditing
                            ? null
                            : (bool? value) {
                                setState(() {
                                  isExposed = value!;
                                });
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
                        onChanged: _deferEditing
                            ? null
                            : (bool? value) {
                                setState(() {
                                  isWaitingForRtPcr = value!;
                                });
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
                        onChanged: _deferEditing
                            ? null
                            : (bool? value) {
                                setState(() {
                                  isWaitingForRtPcr = value!;
                                });
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
                        onChanged: _deferEditing
                            ? null
                            : (bool? value) {
                                setState(() {
                                  isWaitingForRapidAntigen = value!;
                                });
                              },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Yes'),
                      leading: Radio<bool>(
                        value: true,
                        groupValue: isWaitingForRapidAntigen,
                        onChanged: _deferEditing
                            ? null
                            : (bool? value) {
                                setState(() {
                                  isWaitingForRapidAntigen = value!;
                                });
                              },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 72.0),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }
}
