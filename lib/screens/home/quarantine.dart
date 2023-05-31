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
  final List<IskolarInfo> _iskolarInfo = DummyInfo.fakeInfoList;
  bool noQuarantine = true;
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> students = context.watch<AccountsProvider>().students;
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
                  } else if (!snapshot.hasData) {
                    return const Center(
                        child: Text("No Students in Quarantine yet"));
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
                        noQuarantine = false;
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
                                          .startQuarantine,
                                      uID: user.id!),
                              child: const Icon(Symbols.close),
                            ),
                          ),
                          onTap: () =>
                              UserDetails.showSheet(context, user, user.id!),
                        );
                      }
                      if (noQuarantine == true &&
                          index == snapshot.data?.docs.length) {
                        return Center(
                            child: Text("No Student in Under Monitoring yet!",
                                style:
                                    Theme.of(context).textTheme.titleMedium!));
                      }
                      return SizedBox.shrink();
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
