// NAME -> If clicked, show profile
// DATE QUARANTINED
// Remove Quarantine -> When clicked, show pop up

import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/health_confirm_dialog.dart';
import 'package:iskolarsafe/components/requests_button.dart';
import 'package:iskolarsafe/components/user_details.dart';
import 'package:iskolarsafe/dummy_info.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:material_symbols_icons/symbols.dart';

class Quarantine extends StatefulWidget {
  static const String routeName = "/quarantine";

  const Quarantine({super.key});

  @override
  State<Quarantine> createState() => _QuarantineState();
}

class _QuarantineState extends State<Quarantine> {
  final List<IskolarInfo> _iskolarInfo = DummyInfo.fakeInfoList;

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        itemCount: _iskolarInfo.length,
        itemBuilder: ((context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            leading: _getHealthStatus(
                _iskolarInfo[index].status != IskolarHealthStatus.healthy),
            title: Text(
                "${_iskolarInfo[index].firstName} ${_iskolarInfo[index].lastName}"),
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
                onPressed: () => HealthConfirmDialog.confirmDialog(
                    context: context,
                    user: _iskolarInfo[index],
                    type: HealthConfirmDialogType.startQuarantine,
                    uID: ""),
                child: const Icon(Symbols.close),
              ),
            ),
            onTap: () => UserDetails.showSheet(context, _iskolarInfo[index]),
          );
        }),
      ),
    );
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
