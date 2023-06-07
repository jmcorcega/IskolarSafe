import 'package:flutter/material.dart';
import 'package:iskolarsafe/api/accounts_api.dart';
import 'package:iskolarsafe/components/screen_placeholder.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
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

    if (status == AccountsStatus.noInternetConnection) {
      _selectedTabIndex = 0;
      return Scaffold(
        body: Center(
          child: ScreenPlaceholder(
            asset: "assets/images/illust_no_connection.svg",
            title: "No internet connection",
            text:
                "IskolarSafe requires an internet connection. Connect to the internet to continue.",
            button: TextButton.icon(
              onPressed: () {
                context.read<AccountsProvider>().fetchInfo();
              },
              icon: const Icon(Symbols.refresh_rounded),
              label: const Text("Try again"),
            ),
          ),
        ),
      );
    }

    if (status == AccountsStatus.loggingOut ||
        status == AccountsStatus.unknown) {
      _selectedTabIndex = 0;
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (status != AccountsStatus.success) {
      _selectedTabIndex = 0;
      return const Login();
    }

    // if user is logged in
    return _buildHomeScreen(context);
  }

  Scaffold _buildHomeScreen(BuildContext context) {
    IskolarType userType = context.read<AccountsProvider>().userInfo!.type;
    List<Widget> screens = [const Entries()];
    List<NavigationDestination> destinations = [
      const NavigationDestination(
        icon: Icon(Symbols.home_rounded),
        label: 'My Entries',
      ),
    ];

    if (userType != IskolarType.student) {
      screens.add(const Logs());
      destinations.add(
        const NavigationDestination(
          icon: Icon(Symbols.quick_reference_all_rounded),
          label: 'Logs',
        ),
      );

      if (userType == IskolarType.admin) {
        screens.add(const Search());
        screens.add(const Quarantine());
        screens.add(const Monitor());

        destinations.addAll(
          [
            const NavigationDestination(
              icon: Icon(Symbols.face_rounded),
              label: 'Users',
            ),
            const NavigationDestination(
              icon: Icon(Symbols.medical_mask_rounded),
              label: 'Quarantine',
            ),
            const NavigationDestination(
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
