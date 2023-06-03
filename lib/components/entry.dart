import 'package:flutter/material.dart';
import 'package:iskolarsafe/components/entry_details.dart';
import 'package:iskolarsafe/extensions.dart';
import 'package:iskolarsafe/models/entry_model.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:relative_time/relative_time.dart';

class Entry extends StatelessWidget {
  final HealthEntry entry;
  final bool card;
  const Entry({Key? key, required this.entry, required this.card})
      : super(key: key);

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

  Widget? _getTrailingIcon(BuildContext context, HealthEntry entry) {
    if (entry.updated == null) return null;

    Color iconColor =
        Theme.of(context).colorScheme.secondary.withAlpha((255 * 0.5).toInt());
    if (entry.forDeletion) {
      return Icon(
        Symbols.scan_delete_rounded,
        color: iconColor,
      );
    } else {
      return Icon(
        Symbols.edit_document_rounded,
        color: iconColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          EdgeInsets.symmetric(horizontal: 24.0, vertical: card ? 8.0 : 0.0),
      leading: _getIcon(entry.verdict),
      trailing: _getTrailingIcon(context, entry),
      title: Text(
          entry.dateGenerated.relativeTime(context).capitalizeFirstLetter()),
      subtitle: Text(
        _getStatusString(entry.verdict),
        style: Theme.of(context)
            .textTheme
            .labelMedium!
            .apply(color: _getColor(entry.verdict)),
      ),
      shape: card
          ? const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            )
          : null,
      onTap: () => _showEntryModal(context, entry),
    );
  }
}
