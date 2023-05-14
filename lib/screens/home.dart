// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:iskolarsafe/screens/home/entries.dart';
import 'package:iskolarsafe/screens/home/isolate.dart';
import 'package:iskolarsafe/screens/home/logs.dart';
import 'package:iskolarsafe/screens/home/quarantine.dart';
import 'package:iskolarsafe/screens/home/search.dart';
import 'package:material_symbols_icons/symbols.dart';

class Home extends StatefulWidget {
  static const String routeName = "/";

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: [
          Entries(),
          Logs(),
          Search(),
          Quarantine(),
          Isolate()
        ][_selectedTabIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedTabIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedTabIndex = index;
            });
          },
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Symbols.home_rounded),
              label: 'My Entries',
            ),
            NavigationDestination(
              icon: Icon(Symbols.quick_reference_all_rounded),
              label: 'Logs',
            ),
            NavigationDestination(
              icon: Icon(Symbols.face_rounded),
              label: 'Students',
            ),
            NavigationDestination(
              icon: Icon(Symbols.ent_rounded),
              label: 'Quarantine',
            ),
            NavigationDestination(
              icon: Icon(Symbols.recent_patient_rounded),
              label: 'Isolate',
            ),
          ],
        ));
  }
}