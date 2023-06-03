import 'package:flutter/material.dart';
import 'package:iskolarsafe/models/user_model.dart';
import 'package:material_symbols_icons/symbols.dart';

class HealthBadge extends StatelessWidget {
  final IskolarHealthStatus? status;
  const HealthBadge(this.status, {Key? key}) : super(key: key);

  Widget _getIcon() {
    double iconSize = 20.0;
    switch (status) {
      case IskolarHealthStatus.quarantined:
        return Icon(Symbols.medical_mask_rounded, size: iconSize);
      case IskolarHealthStatus.monitored:
        return Icon(Symbols.coronavirus_rounded, size: iconSize);
      case IskolarHealthStatus.notWell:
        return Icon(Symbols.sick_rounded, size: iconSize);
      case IskolarHealthStatus.healthy:
        return Icon(Symbols.check_circle_filled, size: iconSize);
      default:
        return Icon(Symbols.edit_rounded, size: iconSize);
    }
  }

  Color? _getColor() {
    switch (status) {
      case IskolarHealthStatus.quarantined:
        return Colors.red[400];
      case IskolarHealthStatus.monitored:
        return Colors.yellow[800];
      case IskolarHealthStatus.notWell:
        return Colors.orange[800];
      case IskolarHealthStatus.healthy:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusString() {
    switch (status) {
      case IskolarHealthStatus.quarantined:
        return "Quarantined";
      case IskolarHealthStatus.monitored:
        return "Under Monitoring";
      case IskolarHealthStatus.notWell:
        return "Reported Sick";
      case IskolarHealthStatus.healthy:
        return "Safe for Entry";
      default:
        return "Under review";
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: null,
      icon: _getIcon(),
      label: Text(
        _getStatusString(),
        style: Theme.of(context).textTheme.labelLarge!.apply(
              fontSizeDelta: 1,
              color: _getColor(),
            ),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.all(0.0),
        ),
        foregroundColor: MaterialStateProperty.all(
          _getColor(),
        ),
      ),
    );
  }
}
