// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/app_options.dart';
import 'package:iskolarsafe/components/appbar_header.dart';
import 'package:iskolarsafe/components/requests_button.dart';
import 'package:iskolarsafe/components/health_confirm_dialog.dart';
import 'package:iskolarsafe/dummy_info.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../components/user_details.dart';

class Monitor extends StatefulWidget {
  static const String routeName = "/";

  const Monitor({super.key});

  @override
  State<Monitor> createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> {
  final List<IskolarInfo> _iskolarInfo = DummyInfo.fakeInfoList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: EditRequestButton(),
        centerTitle: true,
        title: AppBarHeader(
          icon: Symbols.coronavirus_rounded,
          title: "Under Monitoring",
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
              onTap: () => UserDetails.showSheet(context, _iskolarInfo[index]),
              contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
              title: Text(
                "${_iskolarInfo[index].firstName} ${_iskolarInfo[index].lastName}",
              ),
              subtitle: _getHealthStatus(true),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 34.0,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: EdgeInsets.all(0),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary),
                      onPressed: () => HealthConfirmDialog.confirmDialog(
                        context: context,
                        user: _iskolarInfo[index],
                        type: HealthConfirmDialogType.endMonitoring,
                      ),
                      child: const Icon(Symbols.close_rounded, size: 18.0),
                    ),
                  ),
                  SizedBox(width: 12.0),
                  SizedBox(
                    width: 34.0,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: EdgeInsets.all(0),
                          foregroundColor:
                              Theme.of(context).colorScheme.tertiary),
                      onPressed: () => HealthConfirmDialog.confirmDialog(
                        context: context,
                        user: _iskolarInfo[index],
                        type: HealthConfirmDialogType.startQuarantine,
                      ),
                      child: const Icon(Symbols.medical_mask_rounded),
                    ),
                  ),
                ],
              ),
            );
          })),
    );
  }

  Widget _getHealthStatus(bool status) {
    String safe = "Safe for Work";
    String symptoms = "Has Symptoms";
    if (status) {
      return Row(
        children: [
          Icon(Symbols.sick, color: Colors.red, size: 20.0),
          SizedBox(width: 6.0),
          Text(
            symptoms,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .apply(color: Colors.red),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(Symbols.health_and_safety_rounded,
              color: Colors.green, size: 20.0),
          SizedBox(width: 6.0),
          Text(
            safe,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .apply(color: Colors.green),
          ),
        ],
      );
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
