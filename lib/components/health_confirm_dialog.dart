import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

enum HealthConfirmDialogType {
  endMonitoring,
  endQuarantine,
  startMonitoring,
  startQuarantine,
}

class _HealthConfirmDialog extends StatelessWidget {
  final IskolarInfo userInfo;
  final HealthConfirmDialogType type;
  final bool isModal;
  const _HealthConfirmDialog(this.userInfo, this.type, this.isModal);

  String getTitle() {
    switch (type) {
      case HealthConfirmDialogType.endMonitoring:
        return "End monitoring";
      case HealthConfirmDialogType.endQuarantine:
        return "End quarantine";
      case HealthConfirmDialogType.startMonitoring:
        return "Add to monitoring";
      case HealthConfirmDialogType.startQuarantine:
        return "Add to quarantine";
    }
  }

  IconData? getIcon() {
    switch (type) {
      case HealthConfirmDialogType.startMonitoring:
      case HealthConfirmDialogType.endMonitoring:
        return Symbols.coronavirus_rounded;
      case HealthConfirmDialogType.endQuarantine:
      case HealthConfirmDialogType.startQuarantine:
        return Symbols.masks_rounded;
    }
  }

  String getMessage() {
    switch (type) {
      case HealthConfirmDialogType.endMonitoring:
        return "Are you sure you want to end monitoring for ${userInfo.firstName} ${userInfo.lastName}?";
      case HealthConfirmDialogType.endQuarantine:
        return "Are you sure you want to end quarantine for ${userInfo.firstName} ${userInfo.lastName}?";
      case HealthConfirmDialogType.startMonitoring:
        return "Are you sure you want to add ${userInfo.firstName} ${userInfo.lastName} to the monitoring list?";
      case HealthConfirmDialogType.startQuarantine:
        return "Are you sure you want to add ${userInfo.firstName} ${userInfo.lastName} to the quarantine?";
    }
  }

  String getPositiveButtonText() {
    switch (type) {
      case HealthConfirmDialogType.endMonitoring:
        return "End monitoring";
      case HealthConfirmDialogType.endQuarantine:
        return "End quarantine";
      case HealthConfirmDialogType.startMonitoring:
        return "Start monitoring";
      case HealthConfirmDialogType.startQuarantine:
        return "Add to quarantine";
    }
  }

  IconData? getPositiveButtonIcon() {
    switch (type) {
      case HealthConfirmDialogType.endMonitoring:
      case HealthConfirmDialogType.endQuarantine:
        return Symbols.health_and_safety_rounded;
      case HealthConfirmDialogType.startMonitoring:
      case HealthConfirmDialogType.startQuarantine:
        return Symbols.add_circle_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 28.0,
      ),
      icon: Icon(getIcon(), size: 48.0),
      title: Text(getTitle()),
      content: Text(
        getMessage(),
        textAlign: TextAlign.center,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: <Widget>[
        TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Symbols.close_rounded),
          label: const Text('Cancel'),
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
            switch (type) {
              case HealthConfirmDialogType.endMonitoring:
              case HealthConfirmDialogType.endQuarantine:
                context
                    .read<AccountsProvider>()
                    .updateStatus(IskolarHealthStatus.healthy, userInfo);
                Fluttertoast.showToast(
                  msg: "New status set successfully.",
                );
                if (isModal) Navigator.pop(context);
                break;
              case HealthConfirmDialogType.startMonitoring:
                context
                    .read<AccountsProvider>()
                    .updateStatus(IskolarHealthStatus.monitored, userInfo);
                Fluttertoast.showToast(
                  msg: "Started monitoring for ${userInfo.firstName}.",
                );
                if (isModal) Navigator.pop(context);
                break;
              case HealthConfirmDialogType.startQuarantine:
                context
                    .read<AccountsProvider>()
                    .updateStatus(IskolarHealthStatus.quarantined, userInfo);
                Fluttertoast.showToast(
                  msg: "${userInfo.firstName} moved to quarantined.",
                );
                if (isModal) Navigator.pop(context);
                break;
            }
          },
          icon: Icon(getPositiveButtonIcon()),
          label: Text(getPositiveButtonText()),
        ),
      ],
    );
  }
}

class HealthConfirmDialog {
  static void confirmDialog(
      {required BuildContext context,
      required IskolarInfo user,
      required HealthConfirmDialogType type,
      bool modal = false}) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          _HealthConfirmDialog(user, type, modal),
    );
  }
}
