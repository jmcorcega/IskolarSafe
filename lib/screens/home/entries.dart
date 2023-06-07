import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/entry.dart';
import 'package:iskolarsafe/components/screen_placeholder.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
import 'package:iskolarsafe/components/profile_modal.dart';
import 'package:iskolarsafe/components/requests_button.dart';
import 'package:iskolarsafe/extensions.dart';
import 'package:iskolarsafe/models/entry_model.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/entries_provider.dart';
import 'package:iskolarsafe/screens/entry_editor.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class Entries extends StatefulWidget {
  static const String routeName = "/";

  const Entries({super.key});

  @override
  State<Entries> createState() => _EntriesState();
}

class _EntriesState extends State<Entries> with AutomaticKeepAliveClientMixin {
  @override
  bool wantKeepAlive = true;

  bool _canShowMyProfile = false;
  bool hasInternet = true;

  Widget _buildNoEntryCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Card(
        child: ListTile(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 8.0,
          ),
          leading: Icon(
            Symbols.circle_rounded,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
          ),
          title: const Text("No Entry Today"),
          subtitle: Text(
            "Add entry today to generate QR code",
            style: Theme.of(context).textTheme.labelMedium!.apply(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
                ),
          ),
          onTap: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Stream<QuerySnapshot> entryStream =
        context.watch<HealthEntryProvider>().entries;
    IskolarInfo? userInfo = context.read<AccountsProvider>().userInfo;

    return Scaffold(
      appBar: AppBar(
        leading:
            userInfo!.type != IskolarType.admin ? null : EditRequestButton(),
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
                    onPressed: () => ProfileModal.showModal(
                        context: context,
                        entry: snapshot.data?.docs.first.data()
                            as Map<String, dynamic>),
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
                          child: Entry(entry: entry, card: true),
                        ),
                      );
                    } else {
                      return Column(
                        children: [
                          _buildNoEntryCard(context),
                          Entry(entry: entry, card: false),
                        ],
                      );
                    }
                  }

                  return Entry(entry: entry, card: false);
                }),
          );
        },
      ),
    );
  }
}
