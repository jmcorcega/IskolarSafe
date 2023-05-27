import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/profile_modal.dart';
import 'package:iskolarsafe/components/requests_button.dart';
import 'package:iskolarsafe/extensions.dart';
import 'package:iskolarsafe/models/entry_model.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/entries_provider.dart';
import 'package:iskolarsafe/screens/new_entry.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';

class Entries extends StatefulWidget {
  static const String routeName = "/";

  const Entries({super.key});

  @override
  State<Entries> createState() => _EntriesState();
}

class _EntriesState extends State<Entries> {
  bool _canShowMyProfile = false;
  bool hasInternet = true;

  Widget _getIcon(IskolarHealthStatus status) {
    var color = _getColor(status);
    switch (status) {
      case IskolarHealthStatus.quarantined:
        return Icon(Symbols.medical_mask_rounded, color: color);
      case IskolarHealthStatus.monitored:
        return Icon(Symbols.coronavirus_rounded, color: color);
      case IskolarHealthStatus.notWell:
        return Icon(Symbols.sick_rounded, color: color);
      default:
        return Icon(Symbols.check_circle_filled, color: color);
    }
  }

  Color? _getColor(IskolarHealthStatus status) {
    switch (status) {
      case IskolarHealthStatus.quarantined:
        return Colors.red[400];
      case IskolarHealthStatus.monitored:
        return Colors.yellow[800];
      case IskolarHealthStatus.notWell:
        return Colors.orange[800];
      default:
        return Colors.green;
    }
  }

  String _getStatusString(IskolarHealthStatus status) {
    switch (status) {
      case IskolarHealthStatus.quarantined:
        return "Quarantined";
      case IskolarHealthStatus.monitored:
        return "Under Monitoring";
      case IskolarHealthStatus.notWell:
        return "Reported Sick";
      default:
        return "Safe for Entry";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: EditRequestButton(),
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
      body: FutureBuilder(
        future: context.read<HealthEntryProvider>().refetchEntries(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildNoInternetScreen();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          Stream<QuerySnapshot> entryStream =
              context.watch<HealthEntryProvider>().entries;
          return StreamBuilder(
            stream: entryStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return _buildNoInternetScreen();
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return _buildEmptyScreen();
              }

              _canShowMyProfile = HealthEntry.fromJson(
                      snapshot.data?.docs.first.data() as Map<String, dynamic>)
                  .dateGenerated
                  .isToday();

              return Scaffold(
                floatingActionButton: _canShowMyProfile
                    ? FloatingActionButton.extended(
                        onPressed: () {
                          _showProfileModal(
                              context,
                              snapshot.data?.docs.first.data()
                                  as Map<String, dynamic>);
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
                body: ListView.builder(
                    // Build the list using ListView.builder
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      HealthEntry entry = HealthEntry.fromJson(
                          snapshot.data?.docs[index].data()
                              as Map<String, dynamic>);
                      entry.id = snapshot.data?.docs[index].id;

                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Card(
                            child: ListTile(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 8.0,
                              ),
                              leading: _getIcon(entry.verdict),
                              title: Text(
                                  entry.dateGenerated.relativeTime(context)),
                              subtitle: Text(
                                _getStatusString(entry.verdict),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .apply(color: _getColor(entry.verdict)),
                              ),
                              onTap: () {},
                            ),
                          ),
                        );
                      }

                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 24.0),
                        leading: _getIcon(entry.verdict),
                        title: Text(entry.dateGenerated.relativeTime(context)),
                        subtitle: Text(
                          _getStatusString(entry.verdict),
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .apply(color: _getColor(entry.verdict)),
                        ),
                        onTap: () {},
                      );
                    }),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyScreen() {
    return Center(
      // Show a message where the user can add an entry if list is empty
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_add_outlined,
              size: 64.0,
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.75)),
          const SizedBox(height: 16.0),
          Text("Create your first entry!",
              style: Theme.of(context).textTheme.titleLarge!.apply(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.75))),
          const SizedBox(height: 20.0),
          TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, NewEntry.routeName);
            },
            icon: const Icon(Icons.add_outlined),
            label: const Text("New Entry"),
          )
        ],
      ),
    );
  }

  void _showProfileModal(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
          snap: true,
          initialChildSize: 0.65,
          minChildSize: 0.65,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: ProfileModal(data),
            );
          }),
    );
  }

  Widget _buildNoInternetScreen() {
    return Center(
        // Show a message where the user can add an entry if list is empty
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.wifi_off_outlined,
            size: 64.0,
            color:
                Theme.of(context).colorScheme.onBackground.withOpacity(0.75)),
        const SizedBox(height: 16.0),
        Text("Connect to the internet to get entries",
            style: Theme.of(context).textTheme.titleLarge!.apply(
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.75))),
      ],
    ));
  }
}
