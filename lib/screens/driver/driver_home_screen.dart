import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/vehicle_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tracking_provider.dart';
import '../../widgets/vehicle_status_chip.dart';
import '../auth/login_screen.dart';
import '../shared/settings_screen.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    final auth = context.read<AuthProvider>();
    await context.read<TrackingProvider>().initializeDriver(auth.user!.id);
  }

  Future<void> _toggleTrip(TrackingProvider tracking, String driverId) async {
    if (tracking.isTripActive) {
      await tracking.endTrip();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip ended successfully')),
      );
    } else {
      final vehicle = tracking.driverVehicle;
      if (vehicle == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No vehicle assigned. Contact admin.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      await tracking.startTrip(
        driverId: driverId,
        vehicleId: vehicle.id,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip started - sharing location')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final tracking = context.watch<TrackingProvider>();
    final vehicle = tracking.driverVehicle;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              if (tracking.isTripActive) await tracking.endTrip();
              await auth.logout();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: tracking.isTripActive ? Colors.green.shade50 : null,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    tracking.isTripActive ? Icons.gps_fixed : Icons.gps_off,
                    size: 48,
                    color: tracking.isTripActive ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tracking.isTripActive ? 'Trip Active' : 'No Active Trip',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (tracking.isTripActive)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Sharing location every 5 seconds',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => _toggleTrip(tracking, auth.user!.id),
              icon: Icon(tracking.isTripActive ? Icons.stop : Icons.play_arrow),
              label: Text(tracking.isTripActive ? 'End Trip' : 'Start Trip'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    tracking.isTripActive ? Colors.red : Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Vehicle Status',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: VehicleStatus.values.map((status) {
              final isSelected = vehicle?.status == status;
              return FilterChip(
                label: Text(_statusLabel(status)),
                selected: isSelected,
                onSelected: (_) => tracking.updateVehicleStatus(status),
                selectedColor:
                    Theme.of(context).colorScheme.primaryContainer,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Passengers',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filled(
                        onPressed: tracking.passengerCount > 0
                            ? () => tracking
                                .updatePassengerCount(tracking.passengerCount - 1)
                            : null,
                        icon: const Icon(Icons.remove),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          '${tracking.passengerCount}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton.filled(
                        onPressed: () => tracking
                            .updatePassengerCount(tracking.passengerCount + 1),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  if (vehicle != null)
                    Center(
                      child: Text(
                        'Capacity: ${vehicle.capacity}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.route),
              title: const Text('Assigned Route'),
              subtitle: const Text('Kalpitiya – Kandalkuliya'),
              trailing: Text('${tracking.stops.length} stops'),
            ),
          ),
          if (vehicle != null) ...[
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.directions_bus),
                title: Text(vehicle.plateNumber),
                subtitle: Text(vehicle.model ?? 'Batta Lorry'),
                trailing: VehicleStatusChip(status: vehicle.status),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _statusLabel(VehicleStatus status) {
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
}
