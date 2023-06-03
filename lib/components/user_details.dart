// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iskolarsafe/components/health_badge.dart';
import 'package:iskolarsafe/components/health_confirm_dialog.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import '../providers/accounts_provider.dart';

class _UserDetails extends StatelessWidget {
  final IskolarInfo userInfo;
  const _UserDetails({required this.userInfo});

  static const Size _buttonSize = Size(225.0, 47.5);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (userInfo.photoUrl != null)
                  ? CircleAvatar(
                      radius: 48,
                      foregroundImage:
                          CachedNetworkImageProvider(userInfo.photoUrl!),
                    )
                  : CircleAvatar(
                      radius: 48,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        userInfo.firstName.substring(0, 1),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 38.0),
                      ),
                    ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      userInfo.firstName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      userInfo.lastName,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(fontWeightDelta: 1),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        HealthBadge(userInfo.status),
        const SizedBox(height: 4.0),
        (userInfo.status != IskolarHealthStatus.healthy)
            ? Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 56.0,
                ),
                child: _getBottomButtons(context, userInfo.status),
              )
            : Container(),
        (userInfo.status != IskolarHealthStatus.healthy)
            ? const SizedBox(height: 20.0)
            : Container(),
        Divider(height: 1.0),
        ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 4.0,
          ),
          leading: Icon(Symbols.account_circle_rounded),
          title: Text(userInfo.userName),
          subtitle: Text(
            "Username",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          onLongPress: () async {
            await Clipboard.setData(ClipboardData(text: userInfo.userName));
            if (context.mounted) {
              Fluttertoast.showToast(
                msg: "Copied to your clipboard.",
              );
            }
          },
        ),
        Divider(height: 1.0),
        ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 4.0,
          ),
          leading: Icon(Symbols.badge_rounded),
          title: Text(userInfo.studentNumber),
          subtitle: Text(
            "Student number",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          onLongPress: () async {
            await Clipboard.setData(
                ClipboardData(text: userInfo.studentNumber));
            if (context.mounted) {
              Fluttertoast.showToast(
                msg: "Copied to your clipboard.",
              );
            }
          },
        ),
        FutureBuilder(
          future: _setUserType(context, userInfo),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            }
            return Container();
          }),
        ),
        Divider(height: 1.0),
        ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 4.0,
          ),
          leading: Icon(Symbols.school_rounded),
          title: Text(userInfo.course),
          subtitle: Text(
            "Course",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          onLongPress: () async {
            await Clipboard.setData(ClipboardData(text: userInfo.course));
            if (context.mounted) {
              Fluttertoast.showToast(
                msg: "Copied to your clipboard.",
              );
            }
          },
        ),
        Divider(height: 1.0),
        ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 4.0,
          ),
          leading: Icon(Symbols.domain_rounded),
          title: Text(userInfo.college),
          subtitle: Text(
            "College",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          onLongPress: () async {
            await Clipboard.setData(ClipboardData(text: userInfo.college));
            if (context.mounted) {
              Fluttertoast.showToast(
                msg: "Copied to your clipboard.",
              );
            }
          },
        ),
        userInfo.condition.isNotEmpty ? Divider(height: 1.0) : Container(),
        userInfo.condition.isNotEmpty
            ? ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 4.0,
                ),
                leading: Icon(Symbols.monitor_heart_rounded),
                title: Wrap(
                  spacing: 5.0,
                  children: userInfo.condition.map((String condition) {
                    return Chip(
                      label: Text(condition),
                    );
                  }).toList(),
                ),
                subtitle: Text(
                  "Conditions",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              )
            : Container(),
        Divider(height: 1.0),
        userInfo.allergies.isNotEmpty
            ? ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 4.0,
                ),
                leading: Icon(Symbols.masks_rounded),
                title: Wrap(
                  spacing: 5.0,
                  children: userInfo.allergies.map((String allergy) {
                    return Chip(
                      label: Text(allergy),
                    );
                  }).toList(),
                ),
                subtitle: Text(
                  "Allergies",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              )
            : Container(),
        userInfo.allergies.isNotEmpty ? Divider(height: 1.0) : Container(),
      ],
    );
  }

  Future<Widget> _setUserType(BuildContext context, IskolarInfo info) async {
    // This widget should not appear when the current authorized user is not an administrator.
    IskolarInfo? cond = context.read<AccountsProvider>().userInfo;
    if (context.mounted) {
      User? currentUser = context.read<AccountsProvider>().user;
      if (cond!.type == IskolarType.admin && currentUser!.uid != info.id) {
        return Column(
          children: [
            Divider(height: 1.0),
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 4.0,
              ),
              leading: Icon(Symbols.key_rounded),
              title: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: DropdownButtonFormField<IskolarType>(
                  value: info.type,
                  onChanged: (value) async {
                    await context
                        .read<AccountsProvider>()
                        .updateType(info, value!);
                    value = value;
                  },
                  decoration: InputDecoration.collapsed(hintText: ''),
                  items: IskolarType.values
                      .map<DropdownMenuItem<IskolarType>>((IskolarType type) {
                    return DropdownMenuItem<IskolarType>(
                      value: type,
                      child: Text(IskolarType.toStr(type)),
                    );
                  }).toList(),
                ),
              ),
              subtitle: Text(
                "User type",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        );
      }
    }

    return Container();
  }

  Widget _getBottomButtons(BuildContext context, IskolarHealthStatus status) {
    switch (status) {
      case IskolarHealthStatus.quarantined:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: _buttonSize,
              ),
              onPressed: () => HealthConfirmDialog.confirmDialog(
                  context: context,
                  user: userInfo,
                  type: HealthConfirmDialogType.endQuarantine),
              icon: const Icon(Symbols.cancel_rounded),
              label: const Text("Remove from Quarantine"),
            )
          ],
        );
      case IskolarHealthStatus.monitored:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: _buttonSize,
              ),
              onPressed: () => HealthConfirmDialog.confirmDialog(
                  context: context,
                  user: userInfo,
                  type: HealthConfirmDialogType.endMonitoring),
              icon: const Icon(Symbols.close_rounded, size: 18.0),
              label: const Text("End Monitoring"),
            ),
            const SizedBox(height: 12.0),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.tertiary,
                minimumSize: _buttonSize,
              ),
              onPressed: () => HealthConfirmDialog.confirmDialog(
                  context: context,
                  user: userInfo,
                  type: HealthConfirmDialogType.startQuarantine),
              icon: const Icon(Symbols.medical_mask_rounded),
              label: const Text("Move to Quarantine"),
            ),
          ],
        );
      case IskolarHealthStatus.notWell:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: _buttonSize,
              ),
              onPressed: () => HealthConfirmDialog.confirmDialog(
                  context: context,
                  user: userInfo,
                  type: HealthConfirmDialogType.startMonitoring),
              icon: const Icon(Symbols.add_rounded, size: 18.0),
              label: const Text("Add to Monitoring"),
            ),
            const SizedBox(height: 12.0),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.tertiary,
                minimumSize: _buttonSize,
              ),
              onPressed: () => HealthConfirmDialog.confirmDialog(
                  context: context,
                  user: userInfo,
                  type: HealthConfirmDialogType.startQuarantine),
              icon: const Icon(Symbols.medical_mask_rounded),
              label: const Text("Move to Quarantine"),
            ),
          ],
        );
      default:
        return Container();
    }
  }
}

class UserDetails {
  static void showSheet(BuildContext context, IskolarInfo userInfo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
          snap: true,
          initialChildSize: 0.50,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
                controller: scrollController,
                child: _UserDetails(userInfo: userInfo));
          }),
    );
  }
}
