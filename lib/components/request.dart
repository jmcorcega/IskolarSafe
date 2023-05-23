import 'package:flutter/material.dart';
import 'package:iskolarsafe/screens/login.dart';
import 'package:material_symbols_icons/symbols.dart';

class Request extends StatelessWidget {
  const Request({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(0),
        ),
        onPressed: () {},
        child: const Icon(Symbols.notifications),
      ),
    );
  }
}
