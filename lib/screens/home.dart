// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iskolarsafe/api/accounts_api.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
import 'package:iskolarsafe/providers/entries_provider.dart';
import 'package:iskolarsafe/providers/preferences_provider.dart';
import 'package:iskolarsafe/screens/home/entries.dart';
import 'package:iskolarsafe/screens/home/monitor.dart';
import 'package:iskolarsafe/screens/home/logs.dart';
import 'package:iskolarsafe/screens/home/quarantine.dart';
import 'package:iskolarsafe/screens/home/search.dart';
import 'package:iskolarsafe/screens/login.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static const String routeName = "/home";

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    AccountsStatus? status = context.watch<AccountsProvider>().status;
    context.read<PreferencesProvider>().setBool("is_shown_intro", true);

    if (status == AccountsStatus.userNotLoggedIn) {
      _selectedTabIndex = 0;
      return const Login();
    }

    if (status != AccountsStatus.success) {
      _selectedTabIndex = 0;
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // if user is logged in
    return _buildHomeScreen(context);
  }

  Scaffold _buildHomeScreen(BuildContext context) {
    IskolarType userType = context.read<AccountsProvider>().userInfo!.type;
    List<Widget> screens = [Entries()];
    List<NavigationDestination> destinations = [
      NavigationDestination(
        icon: Icon(Symbols.home_rounded),
        label: 'My Entries',
      ),
    ];

    if (userType != IskolarType.student) {
      screens.add(Logs());
      destinations.add(
        NavigationDestination(
          icon: Icon(Symbols.quick_reference_all_rounded),
          label: 'Logs',
        ),
      );

      if (userType == IskolarType.admin) {
        screens.add(Search());
        screens.add(Quarantine());
        screens.add(Monitor());

        destinations.addAll(
          [
            NavigationDestination(
              icon: Icon(Symbols.face_rounded),
              label: 'Users',
            ),
            NavigationDestination(
              icon: Icon(Symbols.medical_mask_rounded),
              label: 'Quarantine',
            ),
            NavigationDestination(
              icon: Icon(Symbols.coronavirus_rounded),
              label: 'Monitor',
            ),
          ],
        );
      }
    }

    return Scaffold(
      body: screens[_selectedTabIndex],
      bottomNavigationBar: userType == IskolarType.student
          ? null
          : NavigationBar(
              selectedIndex: _selectedTabIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              destinations: destinations,
            ),
    );
  }
}
