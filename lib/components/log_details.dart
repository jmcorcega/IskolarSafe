import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/health_badge.dart';
import 'package:iskolarsafe/components/screen_placeholder.dart';
import 'package:iskolarsafe/extensions.dart';
import 'package:iskolarsafe/models/building_log_model.dart';
import 'package:iskolarsafe/models/entry_model.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/entries_provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

class _LogDetails extends StatelessWidget {
  final IskolarInfo userInfo;
  final BuildingLog log;
  const _LogDetails({required this.userInfo, required this.log});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: AppBar(
            backgroundColor: Colors.transparent,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (userInfo.photoUrl != null)
                  ? CircleAvatar(
                      radius: 48,
                      foregroundImage:
                          CachedNetworkImageProvider(userInfo.photoUrl!),
                    )
                  : CircleAvatar(
                      radius: 48,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        userInfo.firstName.substring(0, 1),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 38.0),
                      ),
                    ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      userInfo.firstName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      userInfo.lastName,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(fontWeightDelta: 1),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        HealthBadge(userInfo.status),
        Text(
          "Scanned ${log.entryDate.relativeTime(context).capitalizeFirstLetter()}",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .color!
                    .withAlpha((255 * 0.5).toInt()),
              ),
        ),
        const SizedBox(height: 32.0),
        FutureBuilder(
          future: context.read<HealthEntryProvider>().getEntry(log.entryId),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData ||
                snapshot.hasError ||
                snapshot.data == null) {
              return const Center(
                child: ScreenPlaceholder(
                  asset: "assets/images/illust_no_connection.svg",
                  text:
                      "An error has occured. The entry may have been deleted.",
                ),
              );
            }

            HealthEntry entry = snapshot.data!;
            List<FluSymptom> fluSymptoms = entry.fluSymptoms!;
            List<RespiratorySymptom> respiratorySymptoms =
                entry.respiratorySymptoms!;
            List<OtherSymptom> otherSymptoms = entry.otherSymptoms!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          leading: Radio<bool>(
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
                          leading: Radio<bool>(
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
                          leading: Radio<bool>(
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
                          leading: Radio<bool>(
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
                          leading: Radio<bool>(
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
                          leading: Radio<bool>(
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
                  const SizedBox(height: 72.0),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class LogDetails {
  static void showSheet(
      BuildContext context, BuildingLog log, IskolarInfo userInfo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
          snap: true,
          initialChildSize: 0.50,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
                controller: scrollController,
                child: _LogDetails(
                  userInfo: userInfo,
                  log: log,
                ));
          }),
    );
  }
}
