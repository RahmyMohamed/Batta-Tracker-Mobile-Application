import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  MapType _currentMapType = MapType.normal;

  // Default coordinate (Kalpitiya / Sri Lanka center grid)
  static const LatLng _center = LatLng(8.2285, 79.7648);

  // Mock markers for neon vehicle tracking
  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('BAT-001'),
      position: LatLng(8.2285, 79.7648),
      infoWindow: InfoWindow(title: 'BAT-001', snippet: 'Speed: 0 km/h (Online)'),
    ),
    const Marker(
      markerId: MarkerId('BAT-002'),
      position: LatLng(8.2350, 79.7700),
      infoWindow: InfoWindow(title: 'BAT-002', snippet: 'Speed: 80 km/h (Moving)'),
    ),
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // Map dark theme custom json styling can be applied here using mapController.setMapStyle()
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. FULL SCREEN GOOGLE MAP
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: _center,
              zoom: 14.0,
            ),
            mapType: _currentMapType,
            markers: _markers,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
          ),

          // 2. TOP GLASSMORPHIC SEARCH BAR
          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: GlassCard(
              borderRadius: 30,
              height: 55,
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search Vehicle...',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon: const Icon(Iconsax.search_normal, color: AppTheme.primaryAccentColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 2),
                ),
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.3, end: 0),
          ),

          // 3. FLOATING ACTION SIDE BUTTONS
          Positioned(
            right: 16,
            bottom: 220, // Placed above the bottom sheet height
            child: Column(
              children: [
                _buildFloatingButton(Iconsax.radar5, _toggleMapType, "Satellite"),
                const SizedBox(height: 12),
                _buildFloatingButton(Iconsax.gps5, () {
                  mapController.animateCamera(CameraUpdate.newLatLng(_center));
                }, "Focus"),
              ],
            ).animate().fadeIn(delay: 200.ms).scale(),
          ),

          // 4. BOTTOM SHEET VEHICLE DETAILS DETAIL PANEL
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildVehicleDetailBottomSheet(),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton(IconData icon, VoidCallback onTap, String heroTag) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppTheme.darkBackgroundColor.withOpacity(0.85),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppTheme.glassBorderColor),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryAccentColor.withOpacity(0.1),
              blurRadius: 8,
            )
          ],
        ),
        child: Icon(icon, color: AppTheme.primaryAccentColor, size: 22),
      ),
    );
  }

  Widget _buildVehicleDetailBottomSheet() {
    return GlassCard(
      borderRadius: 24,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Center Drag Indicator Line
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 15),
          
          // Vehicle Name & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Iconsax.truck_fast, color: AppTheme.primaryAccentColor, size: 26),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('BAT-002', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('Driver: M. Rahmi', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('🟢 Moving', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 20),

          // Telemetry Stats Row (Speed, Fuel, Battery)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTelemetryItem(Iconsax.speedometer, '80 km/h', 'Speed'),
              _buildTelemetryItem(Iconsax.gas_station, '65%', 'Fuel'),
              _buildTelemetryItem(Iconsax.battery_charging, '84%', 'Battery'),
              // Direct Call Action Button
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primaryAccentColor,
                child: IconButton(
                  icon: const Icon(Iconsax.call, color: Colors.white, size: 16),
                  onPressed: () {},
                ),
              )
            ],
          )
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.4, end: 0);
  }

  Widget _buildTelemetryItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade400, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
      ],
    );
  }
}