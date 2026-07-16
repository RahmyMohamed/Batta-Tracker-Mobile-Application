import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <-- Firebase Auth import
import '../../theme/app_theme.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/glass_card.dart';
import '../auth/login_screen.dart';

class PassengerDashboardTab extends StatefulWidget {
  const PassengerDashboardTab({Key? key}) : super(key: key);

  @override
  State<PassengerDashboardTab> createState() => _PassengerDashboardTabState();
}

class _PassengerDashboardTabState extends State<PassengerDashboardTab> {
  String? _selectedStop;
  String _passengerName = "Passenger"; // Default fallback name
  String _passengerEmail = "No Email Provided"; // Dynamic Email Fallback

  // Mock data for dropdown
  final List<String> _stops = ['Kalpitiya Town', 'Kurinjanpitiya Junction', 'Kandakuliya'];

  @override
  void initState() {
    super.initState();
    _fetchLoggedInUserName(); // Fetch user name when the screen loads
  }

  // Function to fetch current user details from Firebase Auth
  void _fetchLoggedInUserName() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _passengerName = user.displayName ?? user.email?.split('@')[0] ?? "Passenger";
        _passengerEmail = user.email ?? "No Email Provided";
      });
    }
  }

  // Modern Glassmorphic User Details Bottom Sheet UI Panel
  void _showUserProfileBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Transparent background handles the glass effect cleanly
      barrierColor: Colors.black.withOpacity(0.6),
      isScrollControlled: true,
      builder: (context) {
        return GlassCard(
          borderRadius: 24,
          height: 260,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Swipe/Drag Bar Indicator
              Center(
                child: Container(
                  width: 45,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              const Text(
                '👤 User Profile Account Details',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 22),
              
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.primaryAccentColor.withOpacity(0.15),
                    child: const Icon(Iconsax.user, color: AppTheme.primaryAccentColor, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _passengerName,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _passengerEmail,
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Logout Action Trigger Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  foregroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  side: const BorderSide(color: Colors.red, width: 0.5),
                ),
                icon: const Icon(Iconsax.logout, size: 18),
                label: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (mounted) Navigator.pop(context);

                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                   MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false, // This line drops all dashboard history states
                  );
                  // Auth state wrapper listens dynamically and routes back to login screen layout automatically
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. HEADER SECTION (Dynamic Name + Top Sheet Trigger Action)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '👋 Welcome Back',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  ),
                  Text(
                    _passengerName, 
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Iconsax.notification, color: Colors.white),
                    onPressed: () {},
                  ),
                  GestureDetector(
                    onTap: _showUserProfileBottomSheet, // <-- Click top image avatar to pop profile details info sheet
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppTheme.primaryAccentColor,
                      child: Icon(Iconsax.user, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0),

          const SizedBox(height: 20),

          // 2. LIVE ROUTE STATUS CARD
          const Text(
            'Route Status',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ).animate().fadeIn(delay: 100.ms),
          
          const SizedBox(height: 10),
          
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Route', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                const Text(
                  'Kalpitiya – Kurinjanpitiya – Kandakuliya',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('0 stops configured', style: TextStyle(color: AppTheme.primaryAccentColor.withOpacity(0.8), fontSize: 12)),
              ],
            ),
          ).animate().fadeIn(delay: 150.ms).scaleY(begin: 0.95, end: 1),

          const SizedBox(height: 20),

          // 3. SELECT YOUR STOP DROPDOWN
          const Text(
            'Select Your Stop',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ).animate().fadeIn(delay: 200.ms),
          
          const SizedBox(height: 10),
          
          GlassCard(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedStop,
                hint: Row(
                  children: [
                    const Icon(Iconsax.location5, color: AppTheme.primaryAccentColor, size: 20),
                    const SizedBox(width: 10),
                    Text('Choose stop for notifications', style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                  ],
                ),
                isExpanded: true,
                dropdownColor: AppTheme.darkBackgroundColor,
                items: _stops.map((String stop) {
                  return DropdownMenuItem<String>(
                    value: stop,
                    child: Text(stop, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedStop = newValue;
                  });
                },
              ),
            ),
          ).animate().fadeIn(delay: 250.ms),

          const SizedBox(height: 20),

          // 4. NEARBY VEHICLE TRACKING PANEL
          GlassCard(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Iconsax.bus5, color: Colors.red),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nearby Vehicle', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                    Text('No vehicles nearby active zone', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                  ],
                )
              ],
            ),
          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.05, end: 0),

          const SizedBox(height: 25),

          // 5. ESTIMATED ARRIVAL TIMES LIST
          const Text(
            'Micro Track Summary',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ).animate().fadeIn(delay: 350.ms),

          const SizedBox(height: 10),

          GlassCard(
            height: 100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Animate(
                    effects: const [FadeEffect(), ScaleEffect()],
                    onPlay: (controller) => controller.repeat(reverse: true),
                    child: Icon(Iconsax.radar5, color: AppTheme.secondaryGlowColor.withOpacity(0.7), size: 30),
                  ),
                  const SizedBox(height: 8),
                  Text('Waiting for active vehicles...', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }
}