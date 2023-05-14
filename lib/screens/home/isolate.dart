import 'package:flutter/material.dart';

class Isolate extends StatefulWidget {
  static const String routeName = "/";

  const Isolate({super.key});

  @override
  State<Isolate> createState() => _IsolateState();
}

class _IsolateState extends State<Isolate> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
      'Learn 📗',
    ));
  }
}
