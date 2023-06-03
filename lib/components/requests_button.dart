import 'package:flutter/material.dart';
import 'package:iskolarsafe/providers/entries_provider.dart';
import 'package:iskolarsafe/screens/requests.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class EditRequestButton extends StatelessWidget {
  EditRequestButton({super.key});

  Widget _buildButton(BuildContext context, {required int numRequests}) {
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.watch<HealthEntryProvider>().requests,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildButton(context, numRequests: 0);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildButton(context, numRequests: 0);
        }

        return _buildButton(context, numRequests: snapshot.data!.docs.length);
      },
    );
  }
}
