import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import 'passenger_dashboard_tab.dart'; // Unga old tabs imports
import '../map_screen.dart';          // Namba create panna map screen

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({Key? key}) : super(key: key);

  @override
  State<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen> {
  int _selectedIndex = 0;

  // Unga dynamic tabs setup mapping
  final List<Widget> _pages = [
    const PassengerDashboardTab(), // Position 0: Main Dashboard UI
    const MapScreen(),             // Position 1: Full tracking map
    const Center(child: Text('Vehicles Screen')), 
    const Center(child: Text('Notifications Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackgroundColor,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      // Unga original navigation bar-ku badhala intha premium layout
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.darkBackgroundColor,
          border: Border(
            top: BorderSide(color: AppTheme.glassBorderColor.withOpacity(0.4), width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(0, Iconsax.home_15, Iconsax.home),
            _buildNavItem(1, Iconsax.routing5, Iconsax.routing),
            _buildNavItem(2, Iconsax.truck_fast, Iconsax.truck_fast),
            _buildNavItem(3, Iconsax.notification5, Iconsax.notification),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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