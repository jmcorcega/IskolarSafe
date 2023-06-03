import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:iskolarsafe/providers/accounts_provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

enum RequestConfirmDialogType {
  approveEdit,
  approveDelete,
  rejectEdit,
  rejectDelete,
}

class _RequestConfirmDialog extends StatelessWidget {
  final IskolarInfo userInfo;
  final RequestConfirmDialogType type;
  final bool isModal;
  const _RequestConfirmDialog(this.userInfo, this.type, this.isModal);

  String getTitle() {
    switch (type) {
      case RequestConfirmDialogType.approveEdit:
        return "Approve edit request";
      case RequestConfirmDialogType.approveDelete:
        return "Approve delete request";
      case RequestConfirmDialogType.rejectEdit:
        return "Reject edit request";
      case RequestConfirmDialogType.rejectDelete:
        return "Reject delete request";
    }
  }

  IconData? getIcon() {
    switch (type) {
      case RequestConfirmDialogType.approveEdit:
      case RequestConfirmDialogType.rejectEdit:
        return Symbols.edit_document_rounded;
      case RequestConfirmDialogType.approveDelete:
      case RequestConfirmDialogType.rejectDelete:
        return Symbols.scan_delete_rounded;
    }
  }

  String getMessage() {
    switch (type) {
      case RequestConfirmDialogType.approveEdit:
        return "Are you sure you want to approve this edit request?";
      case RequestConfirmDialogType.approveDelete:
        return "Are you sure you want to approve this delete request?";
      case RequestConfirmDialogType.rejectEdit:
        return "Are you sure you want to reject this edit request?";
      case RequestConfirmDialogType.rejectDelete:
        return "Are you sure you want to reject this delete request?";
    }
  }

  String getPositiveButtonText() {
    switch (type) {
      case RequestConfirmDialogType.approveEdit:
      case RequestConfirmDialogType.approveDelete:
        return "Approve";
      case RequestConfirmDialogType.rejectEdit:
      case RequestConfirmDialogType.rejectDelete:
        return "Reject";
    }
  }

  IconData? getPositiveButtonIcon() {
    switch (type) {
      case RequestConfirmDialogType.approveEdit:
      case RequestConfirmDialogType.approveDelete:
        return Symbols.edit_document_rounded;
      case RequestConfirmDialogType.rejectEdit:
      case RequestConfirmDialogType.rejectDelete:
        return Symbols.scan_delete_rounded;
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
              case RequestConfirmDialogType.approveEdit:
                // TODO: Approve edit
                if (isModal) Navigator.pop(context);
                break;
              case RequestConfirmDialogType.approveDelete:
                // TODO: Approve delete
                if (isModal) Navigator.pop(context);
                break;
              case RequestConfirmDialogType.rejectEdit:
                // TODO: Reject edit
                if (isModal) Navigator.pop(context);
                break;
              case RequestConfirmDialogType.rejectDelete:
                // TODO: Reject delete
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

class RequestConfirmDialog {
  static void confirmDialog(
      {required BuildContext context,
      required IskolarInfo user,
      required RequestConfirmDialogType type,
      bool modal = false}) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          _RequestConfirmDialog(user, type, modal),
    );
  }
}
