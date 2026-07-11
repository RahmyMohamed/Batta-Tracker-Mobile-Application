import 'package:flutter/material.dart';

import '../models/vehicle_model.dart';

class VehicleStatusChip extends StatelessWidget {
  final VehicleStatus status;
  final VoidCallback? onTap;

  const VehicleStatusChip({
    super.key,
    required this.status,
    this.onTap,
  });

  Color get _color {
    switch (status) {
      case VehicleStatus.available:
        return Colors.green;
      case VehicleStatus.full:
        return Colors.red;
      case VehicleStatus.delayed:
        return Colors.orange;
      case VehicleStatus.outOfService:
        return Colors.grey;
    }
  }

  String get _label {
    switch (status) {
      case VehicleStatus.available:
        return 'Available';
      case VehicleStatus.full:
        return 'Full';
      case VehicleStatus.delayed:
        return 'Delayed';
      case VehicleStatus.outOfService:
        return 'Out of Service';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(Icons.circle, size: 12, color: _color),
      label: Text(_label),
      onPressed: onTap,
      backgroundColor: _color.withValues(alpha: 0.15),
    );
  }
}
