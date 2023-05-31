// NAME -> If clicked, show profile
// DATE QUARANTINED
// Remove Quarantine -> When clicked, show pop up

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/health_confirm_dialog.dart';
import 'package:iskolarsafe/components/requests_button.dart';
import 'package:iskolarsafe/components/user_details.dart';
import 'package:iskolarsafe/dummy_info.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class Quarantine extends StatefulWidget {
  static const String routeName = "/quarantine";

  const Quarantine({super.key});

  @override
  State<Quarantine> createState() => _QuarantineState();
}

class _QuarantineState extends State<Quarantine> {
  Widget _buildEmptyScreen() {
    return Center(
      // Show a message where the user can add an entry if list is empty
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Symbols.masks_rounded,
              size: 72.0,
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.75)),
          const SizedBox(height: 8.0),
          Text("No users under quarantine",
              style: Theme.of(context).textTheme.titleMedium!.apply(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.75))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> students =
        context.watch<AccountsProvider>().quarantined;
    return Scaffold(
        appBar: AppBar(
          leading: EditRequestButton(),
          centerTitle: true,
          title: const AppBarHeader(
            icon: Symbols.medical_mask_rounded,
            title: "Under Quarantine",
            hasAction: false,
          ),
          actions: const [
            AppOptions(),
          ],
        ),
        body: Column(
          children: [
            StreamBuilder(
                stream: students,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text("Error encountered ${snapshot.error}"));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Expanded(child: _buildEmptyScreen());
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: ((context, index) {
                      IskolarInfo user = IskolarInfo.fromJson(
                          snapshot.data?.docs[index].data()
                              as Map<String, dynamic>);
                      user.id = snapshot.data?.docs[index].id;
                      if (user.status == IskolarHealthStatus.quarantined) {
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 24.0),
                          leading: _getHealthStatus(
                              user.status != IskolarHealthStatus.healthy),
                          title: Text("${user.firstName} ${user.lastName}"),
                          subtitle: Text(
                            "Quarantined on: 18/05/2023 11:53am",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          trailing: SizedBox(
                            width: 34.0,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(0),
                              ),
                              onPressed: () =>
                                  HealthConfirmDialog.confirmDialog(
                                      context: context,
                                      user: user,
                                      type: HealthConfirmDialogType
                                          .endQuarantine),
                              child: const Icon(Symbols.close),
                            ),
                          ),
                          onTap: () => UserDetails.showSheet(context, user),
                        );
                      }
                    }),
                  );
                })
          ],
        ));
  }

  Widget _getHealthStatus(bool status) {
    if (status) {
      return const Icon(Symbols.sick, color: Colors.red);
    } else {
      return const Icon(Symbols.health_and_safety_rounded, color: Colors.green);
    }
  }
}

class ProfileModal extends StatelessWidget {
  const ProfileModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 64.0),
        FlutterLogo(size: 150.0),
        SizedBox(height: 18.0),
        Text("User's Name", style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}
