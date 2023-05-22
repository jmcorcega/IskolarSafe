import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/monitoring_alertdialog.dart';
import 'package:material_symbols_icons/symbols.dart';

class UserDetails extends StatelessWidget {
  final Map<dynamic, dynamic> userDetails;
  const UserDetails({super.key, required this.userDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userDetails["name"]),
      ),
      body: Container(
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
                    child:
                        Icon(Symbols.person_rounded, color: Color(0xFF8A1538)),
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
                    child:
                        Icon(Symbols.badge_rounded, color: Color(0xFF8A1538)),
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
                    child:
                        Icon(Symbols.school_rounded, color: Color(0xFF8A1538)),
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
            SizedBox(
              width: 34.0,
              child: FilledButton(
                style: FilledButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.all(0),
                    backgroundColor: Theme.of(context).colorScheme.primary),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          // _monitoringAlertDialog(context, userDetails["name"]!));
                          MonitoringAlertDialog(
                            name: userDetails["name"],
                            isQuarantined: userDetails["isQuarantined"],
                            isUnderMonitoring: userDetails["isUnderMonitoring"],
                          ));
                },
                child: const Icon(Symbols.close_rounded, size: 18.0),
              ),
            ),
            SizedBox(width: 12.0),
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
      ),
    );
  }
}
