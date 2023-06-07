// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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
        title: const AppBarHeader(
          icon: Symbols.settings_rounded,
          title: "Settings",
          isCenter: true,
          hasAction: false,
        ),
      ),
      body: ListView(
        children: [
          // const SizedBox(height: 16.0),
          // ListTile(
          //   leading: Icon(Symbols.dark_mode_rounded),
          //   title: Text("Dark mode"),
          //   trailing: Switch(
          //     value: _switchValue,
          //     onChanged: (value) => {
          //       setState(() {
          //         _switchValue = value;
          //         if (_switchValue == true) {
          //           //
          //         }
          //       })
          //     },
          //   ),
          // ),
          // const Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Text(
              "About IskolarSafe",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
            child: Text(
              "Developers",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .apply(fontSizeDelta: -2, fontWeightDelta: 1),
            ),
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            leading: Icon(Symbols.person_2_rounded),
            title: Text("Kimberly M. Bandillo"),
            subtitle: Text("Entry editing and scanning, UI scaffolding"),
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            leading: Icon(Symbols.person_rounded),
            title: Text("John Vincent M. Corcega"),
            subtitle: Text("Lead Developer, Firebase, Authentication"),
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            leading: Icon(Symbols.person_4_rounded),
            title: Text("Angelo Kenzo F. Fabregas"),
            subtitle: Text("Search, Application models, UI scaffolding"),
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            leading: Icon(Symbols.person_3_rounded),
            title: Text("May R. Laban"),
            subtitle: Text("Lead UI/UX, Entry requests, User profiles"),
          ),
          const Divider(),

          const SizedBox(height: 24.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
            child: Text(
              "Open-source Components",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .apply(fontSizeDelta: -2, fontWeightDelta: 1),
            ),
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            leading: Icon(Symbols.palette_rounded),
            title: Text("Material Design and Components"),
            subtitle: Text("Google"),
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            leading: Icon(Symbols.image_rounded),
            title: Text("cached_network_image"),
            subtitle: Text("baseflow.com"),
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            leading: Icon(Symbols.timer_rounded),
            title: Text("relative_time"),
            subtitle: Text("viter.nl"),
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            leading: Icon(Symbols.document_scanner_rounded),
            title: Text("flutter_svg"),
            subtitle: Text("dnfield.dev"),
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            leading: Icon(Symbols.data_alert_rounded),
            title: Text("fluttertoast"),
            subtitle: Text("karthikponnam.dev"),
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            leading: Icon(Symbols.image_aspect_ratio_rounded),
            title: Text("svg_provider_cache"),
            subtitle: Text("ho-doan"),
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            leading: Icon(Symbols.web_asset_rounded),
            title: Text("scroll_shadow_container"),
            subtitle: Text("nuc134r.io"),
          ),
          const Divider(),

          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
