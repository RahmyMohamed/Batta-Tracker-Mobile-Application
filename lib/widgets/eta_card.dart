import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/eta_model.dart';

class EtaCard extends StatelessWidget {
  final EtaModel eta;
  final String locale;
  final bool isSelected;

  const EtaCard({
    super.key,
    required this.eta,
    required this.locale,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('hh:mm a');

    return Card(
      color: isSelected
          ? theme.colorScheme.primaryContainer
          : eta.isNearArrival
              ? Colors.orange.shade50
              : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: eta.isNearArrival
              ? Colors.orange
              : theme.colorScheme.primary,
          child: Text(
            '${eta.stop.order + 1}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          eta.stop.localizedName(locale),
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${eta.distanceKm.toStringAsFixed(1)} km • ${timeFormat.format(eta.estimatedArrival)}',
        ),
        trailing: Chip(
          label: Text('${eta.minutesAway} min'),
          backgroundColor: eta.isNearArrival
              ? Colors.orange
              : theme.colorScheme.secondary,
          labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
