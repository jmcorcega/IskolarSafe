import 'package:flutter/material.dart';
import 'package:iskolarsafe/screens/requests.dart';
import 'package:material_symbols_icons/symbols.dart';

class EditRequestButton extends StatelessWidget {
  int numRequests = 0;
  EditRequestButton({super.key, this.numRequests = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      margin: const EdgeInsets.only(right: 5.0),
      child: TextButton(
        style: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(0),
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Requests()));
        },
        child: (numRequests > 0)
            ? Badge(
                label: Text(numRequests.toString()),
                child: const Icon(Symbols.notifications_rounded),
              )
            : const Icon(Symbols.notifications_rounded),
      ),
    );
  }
}
