import 'package:flutter/material.dart';

class Logs extends StatefulWidget {
  static const String routeName = "/";

  const Logs({super.key});

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
      'Learn 📗',
    ));
  }
}
