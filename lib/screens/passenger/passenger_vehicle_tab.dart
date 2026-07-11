import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/vehicle_model.dart';
import '../../providers/tracking_provider.dart';
import '../../widgets/vehicle_status_chip.dart';
import 'rate_driver_screen.dart';

class PassengerVehicleTab extends StatelessWidget {
  const PassengerVehicleTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tracking = context.watch<TrackingProvider>();
    final location = tracking.nearestVehicle;

    if (location == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_bus_outlined,
                size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No active vehicles on route',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.directions_bus, size: 64, color: Colors.green),
                const SizedBox(height: 16),
                Text(
                  'Batta Lorry',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text('Vehicle ID: ${location.vehicleId}'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _InfoChip(
                      icon: Icons.speed,
                      label: location.speed != null
                          ? '${(location.speed! * 3.6).toStringAsFixed(0)} km/h'
                          : 'N/A',
                    ),
                    const SizedBox(width: 12),
                    _InfoChip(
                      icon: Icons.access_time,
                      label: _formatTime(location.timestamp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.star, color: Colors.amber),
            title: const Text('Rate Driver'),
            subtitle: const Text('Share your experience'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RateDriverScreen(
                    driverId: location.driverId,
                    tripId: location.tripId,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        const VehicleStatusChip(status: VehicleStatus.available),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
