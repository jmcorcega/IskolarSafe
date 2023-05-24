// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:material_symbols_icons/symbols.dart';

class Settings extends StatefulWidget {
  static const String routeName = "/settings";

  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const IconButton(
              icon: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.transparent,
              ),
              onPressed: null,
            ),
            Icon(
              Symbols.settings_rounded,
              size: 30.0,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            const SizedBox(width: 14.0),
            Text(
              "Settings",
            ),
          ],
        ),
        actions: const [],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16.0),
          ListTile(
              leading: Icon(Symbols.dark_mode_rounded),
              title: Text("Dark mode"),
              trailing: Switch(
                value: _switchValue,
                onChanged: (value) => {
                  setState(() {
                    _switchValue = value;
                  })
                },
              ),
              onTap: () {}),
          const Divider(),
          ListTile(
              leading: Icon(Symbols.info_rounded),
              title: Text("About App"),
              onTap: () {}),
          const Divider(),
        ],
      ),
    );
  }
}
