// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:iskolarsafe/screens/settings/about.dart';

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
        title: const AppBarHeader(
          icon: Symbols.settings_rounded,
          title: "Settings",
          isCenter: true,
          hasAction: false,
        ),
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
                  if (_switchValue == true) {
                    //
                  }
                })
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Symbols.info_rounded),
            title: Text("About App"),
            onTap: () {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => AlertDialog(
                      alignment: Alignment.topCenter,
                      insetPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: MediaQuery.of(context).size.height * 0.085,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24.0)),
                      ),
                      contentPadding: const EdgeInsets.all(0.0),
                      content: Builder(builder: (context) {
                        return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [Text("lalala")],
                            ));
                      })));
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
