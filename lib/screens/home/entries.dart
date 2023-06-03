import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/entry_details.dart';
import 'package:iskolarsafe/components/screen_placeholder.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
import 'package:iskolarsafe/screens/edit_delete_entry.dart';
import 'package:iskolarsafe/components/profile_modal.dart';
import 'package:iskolarsafe/components/requests_button.dart';
import 'package:iskolarsafe/extensions.dart';
import 'package:iskolarsafe/models/entry_model.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/entries_provider.dart';
import 'package:iskolarsafe/screens/entry_editor.dart';
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

  void _showEntryModal(BuildContext context, HealthEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.45,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: HealthEntryDetails(entry: entry),
            );
          }),
    );
  }

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
    Stream<QuerySnapshot> entryStream =
        context.watch<HealthEntryProvider>().entries;
    IskolarInfo? userInfo = context.read<AccountsProvider>().userInfo;

    return Scaffold(
      appBar: AppBar(
        leading:
            userInfo!.type == IskolarType.student ? null : EditRequestButton(),
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
      body: StreamBuilder(
        stream: entryStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ScreenPlaceholder(
              asset: "assets/images/illust_no_connection.svg",
              text: "An error has occured. Try again later.",
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return ScreenPlaceholder(
              asset: "assets/images/illust_no_entry.svg",
              text: "Add your very first entry today",
              button: TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, EntryEditor.routeName);
                },
                icon: const Icon(Symbols.add_rounded),
                label: const Text("New entry"),
              ),
            );
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
                      Navigator.pushNamed(context, EntryEditor.routeName);
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
                    if (_canShowMyProfile) {
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
                            title: Text(entry.dateGenerated
                                .relativeTime(context)
                                .capitalizeFirstLetter()),
                            subtitle: Text(
                              _getStatusString(entry.verdict),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .apply(color: _getColor(entry.verdict)),
                            ),
                            onTap: () => _showEntryModal(context, entry),
                          ),
                        ),
                      );
                    } else {
                      return Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
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
                                leading: Icon(
                                  Symbols.circle_rounded,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.75),
                                ),
                                title: Text("No Entry Today"),
                                subtitle: Text(
                                  "Add entry today to generate QR code",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .apply(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.75),
                                      ),
                                ),
                                onTap: () {},
                              ),
                            ),
                          ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            leading: _getIcon(entry.verdict),
                            title: Text(entry.dateGenerated
                                .relativeTime(context)
                                .capitalizeFirstLetter()),
                            subtitle: Text(
                              _getStatusString(entry.verdict),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .apply(color: _getColor(entry.verdict)),
                            ),
                            onTap: () => _showEntryModal(context, entry),
                          )
                        ],
                      );
                    }
                  }

                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 24.0),
                    leading: _getIcon(entry.verdict),
                    title: Text(entry.dateGenerated
                        .relativeTime(context)
                        .capitalizeFirstLetter()),
                    subtitle: Text(
                      _getStatusString(entry.verdict),
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .apply(color: _getColor(entry.verdict)),
                    ),
                    onTap: () => _showEntryModal(context, entry),
                  );
                }),
          );
        },
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
}
