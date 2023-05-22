import 'package:flutter/material.dart';

class MonitoringAlertDialog extends StatelessWidget {
  final String name;
  final bool isQuarantined;
  final bool isUnderMonitoring;

  const MonitoringAlertDialog({
    super.key,
    required this.name,
    required this.isQuarantined,
    required this.isUnderMonitoring,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text("Are you sure you want to end $name's monitoring?"),
      actions: [
        ElevatedButton(
          onPressed: () {},
          child: const Text("End Monitoring"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        )
      ],
    );
  }
}
