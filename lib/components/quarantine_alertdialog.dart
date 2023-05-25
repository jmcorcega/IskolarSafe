import 'package:flutter/material.dart';

class QuarantineAlertDialog extends StatelessWidget {
  final String name;
  final bool isQuarantined;

  const QuarantineAlertDialog({
    super.key,
    required this.name,
    required this.isQuarantined,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: (isQuarantined)
            ? Text("Are you sure you want to remove $name from quarantine?")
            : Text("Are you sure you want to move $name to quarantine?"),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // or spaceBetween?
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
                // Color is hard coded. Needs a way to match this color from
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Color(0xFFFB6962))),
                child: (isQuarantined)
                    ? const Text("Remove",
                        style: TextStyle(color: Color(0xFFFFFFFF)))
                    : const Text("Move",
                        style: TextStyle(color: Color(0xFFFFFFFF)))),
          ],
        )
      ],
    );
  }
}
