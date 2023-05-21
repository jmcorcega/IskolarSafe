import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:material_symbols_icons/symbols.dart';

class NewEntry extends StatefulWidget {
  static const String routeName = "/entry/new";
  const NewEntry({Key? key}) : super(key: key);

  @override
  _NewEntryState createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {
  final _entryFormState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarHeader(
          icon: Symbols.add_circle_rounded,
          title: "New Entry",
          hasAction: false,
        ),
        centerTitle: true,
      ),
      body: Form(
          key: _entryFormState,
          child: ListView(
            children: [],
          )),
    );
  }
}
