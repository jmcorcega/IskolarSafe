import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iskolarsafe/components/health_badge.dart';
import 'package:iskolarsafe/components/request_confirm_dialog.dart';
import 'package:iskolarsafe/extensions.dart';
import 'package:iskolarsafe/models/entry_model.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
import 'package:iskolarsafe/providers/entries_provider.dart';
import 'package:iskolarsafe/screens/entry_editor.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

class HealthEntryDetails extends StatelessWidget {
  final HealthEntry entry;
  HealthEntryDetails({super.key, required this.entry});

  final _entryFormState = GlobalKey<FormState>();

  void _showDeleteRequestDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 28.0,
        ),
        icon: const Icon(Symbols.scan_delete_rounded, size: 48.0),
        title: const Text("Confirm delete request"),
        content: const Text(
          "Are you sure you want to request an officer to delete this entry?",
          textAlign: TextAlign.center,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
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
            onPressed: () async {
              await context.read<HealthEntryProvider>().requestDeletion(entry);
              if (context.mounted) {
                var status = context.read<HealthEntryProvider>().status;

                if (status) {
                  var snackBar = const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                        'Request was successful. Please wait for an officer to approve your request.'),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else {
                  Fluttertoast.showToast(
                    msg: "An error has occured. Try again later.",
                  );
                }
              }
            },
            icon: const Icon(Symbols.scan_delete_rounded),
            label: const Text('Request'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    IskolarInfo? user = context.read<AccountsProvider>().userInfo;
    bool isOfficer =
        user!.type != IskolarType.student && entry.userInfo.id != user.id;
    bool isUpdating = entry.updated != null;

    List<FluSymptom> fluSymptoms = entry.fluSymptoms!;
    List<RespiratorySymptom> respiratorySymptoms = entry.respiratorySymptoms!;
    List<OtherSymptom> otherSymptoms = entry.otherSymptoms!;

    if (entry.updated != null) {
      fluSymptoms.addAll(entry.updated!.fluSymptoms!);
      respiratorySymptoms.addAll(entry.updated!.respiratorySymptoms!);
      otherSymptoms.addAll(entry.updated!.otherSymptoms!);
    }

    return Form(
      key: _entryFormState,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 200.0, minWidth: 200.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8.0),
              AppBar(
                backgroundColor: Colors.transparent,
                actions: [
                  entry.updated != null || entry.forDeletion == true
                      ? Container()
                      : IconButton(
                          onPressed: () {
                            _showDeleteRequestDialog(context);
                          },
                          icon: const Icon(Symbols.delete_rounded),
                        ),
                  entry.updated != null || entry.forDeletion == true
                      ? Container()
                      : IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, EntryEditor.routeName,
                                arguments: entry);
                          },
                          icon: const Icon(Symbols.edit_rounded),
                        ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(children: [
                        _buildProfile(context, user),
                        const SizedBox(height: 12.0),
                        Text(
                          "Generated ${entry.dateGenerated.relativeTime(context).capitalizeFirstLetter()}",
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .color!
                                        .withAlpha((255 * 0.5).toInt()),
                                  ),
                        ),
                        HealthBadge(isOfficer && isUpdating
                            ? entry.updated!.verdict
                            : isUpdating
                                ? null
                                : entry.verdict),
                      ]),
                    ),
                    const SizedBox(height: 28.0),
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
                      children: RespiratorySymptom.values
                          .map((RespiratorySymptom symptom) {
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
                            textColor: _changeRadioColor(
                                context,
                                false,
                                false,
                                entry.exposed,
                                entry.updated?.exposed ?? entry.exposed),
                            leading: Radio<bool>(
                              activeColor: _changeRadioColor(
                                  context,
                                  true,
                                  false,
                                  entry.exposed,
                                  entry.updated?.exposed ?? entry.exposed),
                              value: false,
                              groupValue: (entry.exposed)
                                  ? entry.exposed
                                  : entry.updated?.exposed ?? entry.exposed,
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
                            textColor: _changeRadioColor(
                                context,
                                false,
                                true,
                                entry.exposed,
                                entry.updated?.exposed ?? entry.exposed),
                            leading: Radio<bool>(
                              activeColor: _changeRadioColor(
                                  context,
                                  true,
                                  true,
                                  entry.exposed,
                                  entry.updated?.exposed ?? entry.exposed),
                              value: true,
                              groupValue: (entry.exposed)
                                  ? entry.exposed
                                  : entry.updated?.exposed ?? entry.exposed,
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
                                entry.waitingForRtPcr,
                                entry.updated?.waitingForRtPcr ??
                                    entry.waitingForRtPcr),
                            leading: Radio<bool>(
                              activeColor: _changeRadioColor(
                                  context,
                                  true,
                                  false,
                                  entry.waitingForRtPcr,
                                  entry.updated?.waitingForRtPcr ??
                                      entry.waitingForRtPcr),
                              value: false,
                              groupValue: (!entry.waitingForRtPcr)
                                  ? entry.waitingForRtPcr
                                  : entry.updated?.waitingForRtPcr ??
                                      entry.waitingForRtPcr,
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
                                entry.waitingForRtPcr,
                                entry.updated?.waitingForRtPcr ??
                                    entry.waitingForRtPcr),
                            leading: Radio<bool>(
                              activeColor: _changeRadioColor(
                                  context,
                                  true,
                                  true,
                                  entry.waitingForRtPcr,
                                  entry.updated?.waitingForRtPcr ??
                                      entry.waitingForRtPcr),
                              value: true,
                              groupValue: (entry.waitingForRtPcr)
                                  ? entry.waitingForRtPcr
                                  : entry.updated?.waitingForRtPcr ??
                                      entry.waitingForRtPcr,
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
                                entry.waitingForRapidAntigen,
                                entry.updated?.waitingForRapidAntigen ??
                                    entry.waitingForRapidAntigen),
                            leading: Radio<bool>(
                              activeColor: _changeRadioColor(
                                  context,
                                  true,
                                  false,
                                  entry.waitingForRapidAntigen,
                                  entry.updated?.waitingForRapidAntigen ??
                                      entry.waitingForRapidAntigen),
                              value: false,
                              groupValue: (!entry.waitingForRapidAntigen)
                                  ? entry.waitingForRapidAntigen
                                  : entry.updated?.waitingForRapidAntigen ??
                                      entry.waitingForRapidAntigen,
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
                                entry.waitingForRapidAntigen,
                                entry.updated?.waitingForRapidAntigen ??
                                    entry.waitingForRapidAntigen),
                            leading: Radio<bool>(
                              activeColor: _changeRadioColor(
                                  context,
                                  true,
                                  true,
                                  entry.waitingForRapidAntigen,
                                  entry.updated?.waitingForRapidAntigen ??
                                      entry.waitingForRapidAntigen),
                              value: true,
                              groupValue: (entry.waitingForRapidAntigen)
                                  ? entry.waitingForRapidAntigen
                                  : entry.updated?.waitingForRapidAntigen ??
                                      entry.waitingForRapidAntigen,
                              onChanged: (bool? value) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                    _buildButtons(context, user),
                    const SizedBox(height: 72.0),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Color _changeChipColor(BuildContext context, dynamic symptom) {
    var updated = entry.updated;
    Color changed = Theme.of(context).colorScheme.inversePrimary;
    Color original = updated != null
        ? Theme.of(context).colorScheme.tertiaryContainer
        : changed;

    if (updated != null) {
      for (dynamic updated in updated.fluSymptoms!) {
        if (symptom == updated) {
          return changed;
        }
      }

      for (dynamic updated in updated.respiratorySymptoms!) {
        if (symptom == updated) {
          return changed;
        }
      }

      for (dynamic updated in updated.otherSymptoms!) {
        if (symptom == updated) {
          return changed;
        }
      }
    }

    for (dynamic orig in entry.fluSymptoms!) {
      if (symptom == orig) {
        return original;
      }
    }

    for (dynamic orig in entry.respiratorySymptoms!) {
      if (symptom == orig) {
        return original;
      }
    }

    for (dynamic orig in entry.otherSymptoms!) {
      if (symptom == orig) {
        return original;
      }
    }

    return changed;
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

  Widget _buildProfile(context, IskolarInfo user) {
    if (entry.updated == null) return Container();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        user.photoUrl != null
            ? CircleAvatar(
                foregroundImage: CachedNetworkImageProvider(user.photoUrl!),
              )
            : CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  user.firstName.substring(0, 1),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
        const SizedBox(width: 16.0),
        Wrap(
          direction: Axis.vertical,
          children: [
            Text(
              "${user.firstName} ${user.lastName}",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .apply(fontSizeDelta: 2),
            ),
            Text(user.studentNumber,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .apply(fontWeightDelta: -1)),
          ],
        ),
      ],
    );
  }

  Widget _buildButtons(context, IskolarInfo user) {
    if (entry.updated == null || user.type == IskolarType.student) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12.0),
        const Divider(),
        const SizedBox(height: 24.0),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            minimumSize: const Size(225.0, 47.5),
          ),
          onPressed: () => RequestConfirmDialog.confirmDialog(
            context: context,
            user: user,
            type: entry.forDeletion
                ? RequestConfirmDialogType.approveDelete
                : RequestConfirmDialogType.approveEdit,
            modal: true,
          ),
          icon: const Icon(Symbols.edit_document_rounded),
          label: const Text("Approve"),
        ),
        const SizedBox(height: 12.0),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            minimumSize: const Size(225.0, 47.5),
          ),
          onPressed: () => RequestConfirmDialog.confirmDialog(
            context: context,
            user: user,
            type: entry.forDeletion
                ? RequestConfirmDialogType.rejectDelete
                : RequestConfirmDialogType.rejectEdit,
            modal: true,
          ),
          icon: const Icon(Symbols.scan_delete_rounded, size: 18.0),
          label: const Text("Reject"),
        ),
      ],
    );
  }
}
