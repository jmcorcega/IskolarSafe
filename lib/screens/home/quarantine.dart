import 'package:flutter/material.dart';

class Quarantine extends StatefulWidget {
  static const String routeName = "/";

  const Quarantine({super.key});

  @override
  State<Quarantine> createState() => _QuarantineState();
}

class _QuarantineState extends State<Quarantine> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
      'Learn 📗',
    ));
  }
}
