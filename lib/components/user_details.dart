import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/monitoring_alertdialog.dart';
import 'package:iskolarsafe/components/quarantine_alertdialog.dart';
import 'package:material_symbols_icons/symbols.dart';

class UserDetails extends StatelessWidget {
  final Map<dynamic, dynamic> userDetails;
  final bool isQuarantined;
  final bool isUnderMonitoring;
  const UserDetails({
    super.key,
    required this.userDetails,
    required this.isQuarantined,
    required this.isUnderMonitoring,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Icon(Icons.person, size: 100, color: Color(0xFF8A1538)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Icon(Symbols.person_rounded, color: Color(0xFF8A1538)),
                ),
                Text(userDetails["name"],
                    style: Theme.of(context).textTheme.bodyLarge)
              ],
            ),
          ),
          Divider(color: Color(0xFF8A1538), thickness: 1.0),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Icon(Symbols.badge_rounded, color: Color(0xFF8A1538)),
                ),
                Text(userDetails["studentNo"],
                    style: Theme.of(context).textTheme.bodyLarge)
              ],
            ),
          ),
          Divider(color: Color(0xFF8A1538), thickness: 1.0),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Icon(Symbols.school_rounded, color: Color(0xFF8A1538)),
                ),
                Text(userDetails["course"],
                    style: Theme.of(context).textTheme.bodyLarge)
              ],
            ),
          ),
          Divider(color: Color(0xFF8A1538), thickness: 1.0),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Icon(Symbols.home, color: Color(0xFF8A1538)),
                ),
                Text(userDetails["college"],
                    style: Theme.of(context).textTheme.bodyLarge)
              ],
            ),
          ),
          Divider(color: Color(0xFF8A1538), thickness: 1.0),
          SizedBox(width: 12.0),
          if (isUnderMonitoring || isQuarantined)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: (isQuarantined)
                  ? [
                      SizedBox(
                        width: 220.0,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                          ),
                          onPressed: () {
                            showDialog(
                                useSafeArea: false,
                                context: context,
                                builder: (BuildContext context) =>
                                    QuarantineAlertDialog(
                                      name: userDetails["name"],
                                      isQuarantined:
                                          userDetails["isQuarantined"],
                                    ));
                          },
                          icon: const Icon(Symbols.close),
                          label: const Text("Remove from Quarantine"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Center(
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Back",
                                  style:
                                      Theme.of(context).textTheme.titleMedium)),
                        ),
                      )
                    ]
                  : [
                      SizedBox(
                        width: 160.0,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    // _monitoringAlertDialog(context, userDetails["name"]!));
                                    MonitoringAlertDialog(
                                      name: userDetails["name"],
                                      // isQuarantined: userDetails["isQuarantined"],
                                      // isUnderMonitoring: userDetails["isUnderMonitoring"],
                                    ));
                          },
                          icon: const Icon(Symbols.close_rounded, size: 18.0),
                          label: const Text("End Monitoring"),
                        ),
                      ),
                      SizedBox(
                        width: 180.0,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              foregroundColor:
                                  Theme.of(context).colorScheme.tertiary),
                          onPressed: () {
                            showDialog(
                                useSafeArea: false,
                                context: context,
                                builder: (BuildContext context) =>
                                    QuarantineAlertDialog(
                                        name: userDetails["name"],
                                        isQuarantined:
                                            userDetails["isQuarantined"]));
                          },
                          icon: const Icon(Symbols.medical_mask_rounded),
                          label: const Text("Move to Quarantine"),
                        ),
                      ),
                    ],
            ),
          SizedBox(width: 12.0),
          if (!isQuarantined)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Back",
                        style: Theme.of(context).textTheme.titleMedium)),
              ),
            )
        ],
      ),
    );
  }
}
