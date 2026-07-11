import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/tracking_provider.dart';
import '../../widgets/emergency_fab.dart';
import '../auth/login_screen.dart';
import '../shared/settings_screen.dart';
import 'passenger_dashboard_tab.dart';
import 'passenger_map_tab.dart';
import 'passenger_schedule_tab.dart';
import 'passenger_vehicle_tab.dart';

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({super.key});

  @override
  State<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initTracking());
  }

  Future<void> _initTracking() async {
    final auth = context.read<AuthProvider>();
    final tracking = context.read<TrackingProvider>();
    await tracking.initializePassenger(
      selectedStopId: auth.user?.selectedStopId,
    );
    if (auth.user?.selectedStopId != null) {
      tracking.setSelectedStop(auth.user!.selectedStopId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const PassengerDashboardTab(),
      const PassengerMapTab(),
      const PassengerScheduleTab(),
      const PassengerVehicleTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Batta Tracker'),
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
              await context.read<AuthProvider>().logout();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: tabs[_currentIndex],
      floatingActionButton: const EmergencyFab(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Live Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.schedule_outlined),
            selectedIcon: Icon(Icons.schedule),
            label: 'Schedule',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_bus_outlined),
            selectedIcon: Icon(Icons.directions_bus),
            label: 'Vehicle',
          ),
        ],
      ),
    );
  }
}
