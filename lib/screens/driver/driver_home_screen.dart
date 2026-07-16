import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/vehicle_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tracking_provider.dart';
import '../../theme/app_theme.dart'; // Import AppTheme framework colors
import '../auth/login_screen.dart';
import 'driver_dashboard_tab.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    final auth = context.read<AuthProvider>();
    await context.read<TrackingProvider>().initializeDriver(auth.user!.id);
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic lists to handle bottom navigation views dynamically
    final List<Widget> _pages = [
      const DriverDashboardTab(), // Position 0: Modern UI with Add Vehicle feature
      const DriverTrackingViewContent(), // Position 1: Clean operational management overview panel
    ];

    return Scaffold(
      backgroundColor: AppTheme.darkBackgroundColor,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      // Custom Premium Animated Cyberpunk Navigation Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.darkBackgroundColor,
          border: Border(
            top: BorderSide(color: AppTheme.glassBorderColor.withOpacity(0.4), width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Iconsax.category5, Iconsax.category), // Dashboard Overview icon
            _buildNavItem(1, Iconsax.routing5, Iconsax.routing), // Trip Tracking controller icon
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData selectedIcon, IconData unselectedIcon) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryAccentColor.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryAccentColor.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: Icon(
          isSelected ? selectedIcon : unselectedIcon,
          color: isSelected ? AppTheme.primaryAccentColor : Colors.grey,
          size: 26,
        ),
      ).animate(target: isSelected ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 200.ms),
    );
  }
}

// Separate component block separating the original operational tracking views
class DriverTrackingViewContent extends StatefulWidget {
  const DriverTrackingViewContent({Key? key}) : super(key: key);

  @override
  State<DriverTrackingViewContent> createState() => _DriverTrackingViewContentState();
}

class _DriverTrackingViewContentState extends State<DriverTrackingViewContent> {
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

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final tracking = context.watch<TrackingProvider>();
    final vehicle = tracking.driverVehicle;

    return Scaffold(
      backgroundColor: AppTheme.darkBackgroundColor,
      appBar: AppBar(
        title: const Text('Driver Operational Panel', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.darkBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              if (tracking.isTripActive) await tracking.endTrip(); // Safety check before logout execution
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
        physics: const BouncingScrollPhysics(),
        children: [
          const Text(
            'Vehicle Status',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
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
                selectedColor: AppTheme.primaryAccentColor.withOpacity(0.3),
                checkmarkColor: AppTheme.primaryAccentColor,
                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Card(
            color: const Color(0xFF1E1E24).withOpacity(0.4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Passengers',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filled(
                        onPressed: tracking.passengerCount > 0
                            ? () => tracking.updatePassengerCount(tracking.passengerCount - 1)
                            : null,
                        icon: const Icon(Icons.remove),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.primaryAccentColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          '${tracking.passengerCount}',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      IconButton.filled(
                        onPressed: () => tracking.updatePassengerCount(tracking.passengerCount + 1),
                        icon: const Icon(Icons.add),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.primaryAccentColor,
                        ),
                      ),
                    ],
                  ),
                  if (vehicle != null)
                    Center(
                      child: Text(
                        'Capacity: ${vehicle.capacity}',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF1E1E24).withOpacity(0.4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.route, color: AppTheme.primaryAccentColor),
              title: const Text('Assigned Route', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Kalpitiya – Kurinjanpitiya – Kandakuliya', style: TextStyle(color: Colors.grey)),
              trailing: Text('${tracking.stops.length} stops', style: const TextStyle(color: Colors.white)),
            ),
          ),
          if (vehicle != null) ...[
            const SizedBox(height: 16),
            Card(
              color: const Color(0xFF1E1E24).withOpacity(0.4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: const Icon(Icons.directions_bus, color: AppTheme.primaryAccentColor),
                title: Text(vehicle.plateNumber, style: const TextStyle(color: Colors.white)),
                subtitle: Text(vehicle.model ?? 'Batta Lorry', style: const TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}