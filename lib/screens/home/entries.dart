import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/profile_modal.dart';
import 'package:iskolarsafe/components/request.dart';
import 'package:iskolarsafe/screens/new_entry.dart';
import 'package:material_symbols_icons/symbols.dart';

class Entries extends StatefulWidget {
  static const String routeName = "/";

  const Entries({super.key});

  @override
  State<Entries> createState() => _EntriesState();
}

class _EntriesState extends State<Entries> {
  bool _canShowMyProfile = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Request(),
        centerTitle: true,
        title: const AppBarHeader(
          icon: Symbols.home_rounded,
          title: "My Entries",
          hasAction: false,
        ),
        actions: const [
          AppOptions(),
        ],
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8.0,
                  ),
                  leading: Icon(Symbols.health_and_safety_rounded,
                      color: Colors.green),
                  title: Text("Date goes here"),
                  subtitle: Text(
                    "Safe for entry",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .apply(color: Colors.green),
                  ),
                  onTap: () {},
                ),
              ),
            );
          }
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            leading:
                Icon(Symbols.health_and_safety_rounded, color: Colors.green),
            title: Text("Date goes here"),
            subtitle: Text(
              "Safe for entry",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .apply(color: Colors.green),
            ),
            onTap: () {},
          );
        },
      ),
      floatingActionButton: _canShowMyProfile
          ? FloatingActionButton.extended(
              onPressed: () {
                _showProfileModal(context);
              },
              label: const Text("My profile"),
              icon: const Icon(Symbols.person_filled_rounded),
            )
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, NewEntry.routeName);
              },
              label: const Text("New entry"),
              icon: const Icon(Symbols.add_rounded),
            ),
    );
  }

  void _showProfileModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
          snap: true,
          initialChildSize: 0.4,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: const ProfileModal(),
            );
          }),
    );
  }
}
