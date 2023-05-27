import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/edit_delete_request.dart';
import 'package:material_symbols_icons/symbols.dart';

class EditRequestButton extends StatelessWidget {
  const EditRequestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(right: 5.0),
      child: SizedBox(
        width: 34.0,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(0),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EditRequests()));
          },
          child: const Icon(Symbols.notifications),
        ),
      ),
    );
  }
}
