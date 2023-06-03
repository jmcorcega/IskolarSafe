import 'package:flutter/material.dart';
import 'package:iskolarsafe/extensions.dart';
import 'package:iskolarsafe/models/entry_model.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:material_symbols_icons/symbols.dart';

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
              _buildButtons(context),
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

  Widget _buildButtons(context) {
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
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 28.0,
                ),
                icon: const Icon(Symbols.edit_rounded, size: 48.0),
                title: const Text("Confirm edit request"),
                content: const Text(
                  "Are you sure you want to approve their edit request?",
                  textAlign: TextAlign.center,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 48.0, vertical: 24.0),
                actionsAlignment: MainAxisAlignment.spaceEvenly,
                actions: <Widget>[
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Symbols.close_rounded),
                    label: const Text('Cancel'),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Symbols.edit_document_rounded),
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
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 28.0,
                ),
                icon: const Icon(Symbols.scan_delete_rounded, size: 48.0),
                title: const Text("Reject edit request"),
                content: const Text(
                  "Are you sure you want to reject their edit request?",
                  textAlign: TextAlign.center,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 48.0, vertical: 24.0),
                actionsAlignment: MainAxisAlignment.spaceEvenly,
                actions: <Widget>[
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Symbols.close_rounded),
                    label: const Text('Cancel'),
                  ),
                  TextButton.icon(
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
}
