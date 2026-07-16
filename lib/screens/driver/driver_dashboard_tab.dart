import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../providers/auth_provider.dart';       
import '../../providers/tracking_provider.dart';   
import '../../models/vehicle_model.dart';

class DriverDashboardTab extends StatefulWidget {
  const DriverDashboardTab({Key? key}) : super(key: key);

  @override
  State<DriverDashboardTab> createState() => _DriverDashboardTabState();
}

class _DriverDashboardTabState extends State<DriverDashboardTab> {
  final _formKey = GlobalKey<FormState>();
  String _vehicleNumber = '';
  bool _isAssigned = false;
  
  // Local active flag override to solve provider synchronization display lag issues
  bool? _localTripActiveOverride;

  @override
  void initState() {
    super.initState();
    _loadVehicleAssignment();
  }

  Future<void> _loadVehicleAssignment() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAssigned = prefs.getBool('is_assigned') ?? false;
      _vehicleNumber = prefs.getString('vehicle_number') ?? '';
    });
  }

  Future<void> _saveVehicleAssignment(bool assigned, String vehicleNum) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_assigned', assigned);
    await prefs.setString('vehicle_number', vehicleNum);
  }

  // Active Core Driver Live Trip Engine Toggle Operational Logic Function
  Future<void> _handleDashboardTripToggle(TrackingProvider tracking, String driverId) async {
    // Determine status using local override state layer first
    final bool currentTripStatus = _localTripActiveOverride ?? tracking.isTripActive;

    if (currentTripStatus) {
      await tracking.endTrip();
      
      if (mounted) {
        setState(() {
          _localTripActiveOverride = false; // Force clear UI active flag immediately
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trip ended successfully framework status clean.')),
        );
      }
    } else {
      // Verify that a vehicle has been added locally first
      if (!_isAssigned || _vehicleNumber.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No vehicle registered. Please add a vehicle first.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Safe identification fallback resolution routing 
      final effectiveVehicleId = tracking.driverVehicle?.id ?? 'mock_${_vehicleNumber.replaceAll(' ', '_')}';
      
      await tracking.startTrip(
        driverId: driverId,
        vehicleId: effectiveVehicleId,
      );
      
      if (mounted) {
        setState(() {
          _localTripActiveOverride = true; // Force trigger active UI presentation status layout instantly
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trip started - sharing tracking maps location coordinates every 5s.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _showAddVehicleBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.6),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: GlassCard(
            borderRadius: 24,
            height: 320,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 15),
                  const Text(
                    '🚚 Add & Assign Vehicle',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  GlassCard(
                    borderRadius: 12,
                    height: 55,
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter Vehicle Number (e.g., BAT-003)',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                        prefixIcon: const Icon(Iconsax.truck, color: AppTheme.primaryAccentColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a vehicle number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _vehicleNumber = value!.trim();
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryAccentColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        await _saveVehicleAssignment(true, _vehicleNumber);
                        setState(() {
                          _isAssigned = true;
                        });
                        if (context.mounted) Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Vehicle $_vehicleNumber assigned successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    child: const Text('Confirm Assignment', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final tracking = context.watch<TrackingProvider>();

    // Dynamic boolean status tracker evaluates priority based on direct user context button clicks
    final bool isUiTripActive = _localTripActiveOverride ?? tracking.isTripActive;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Driver Control Panel',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 20),
          
          if (!_isAssigned)
            GestureDetector(
              onTap: _showAddVehicleBottomSheet,
              child: GlassCard(
                height: 140,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.add_circle5, color: AppTheme.primaryAccentColor.withOpacity(0.8), size: 40),
                    const SizedBox(height: 10),
                    const Text('No Vehicle Assigned', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Tap here to register your truck profile', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                  ],
                ),
              ),
            ).animate().fadeIn().scale()
          else
            Column(
              children: [
                // Vehicle Profile Card
                GlassCard(
                  height: 110,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Iconsax.truck_fast, color: Colors.green, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_vehicleNumber, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              const Text('Active Vehicle Allocation Profile', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Iconsax.trash, color: Colors.redAccent, size: 20),
                        onPressed: () async {
                          if (isUiTripActive) await tracking.endTrip(); 
                          await _saveVehicleAssignment(false, '');
                          setState(() {
                            _isAssigned = false;
                            _vehicleNumber = '';
                            _localTripActiveOverride = false;
                          });
                        },
                      )
                    ],
                  ),
                ).animate().fadeIn().slideX(),

                const SizedBox(height: 25),

                // 2. REAL-TIME OPERATIONAL CONTROL INTERFACE 
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Trip Execution Matrix',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),

                GlassCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Animate(
                                target: isUiTripActive ? 1 : 0,
                                effects: const [FadeEffect(), ScaleEffect()],
                                onPlay: (controller) => controller.repeat(reverse: true),
                                child: Icon(
                                  isUiTripActive ? Iconsax.radar5 : Iconsax.radar, 
                                  color: isUiTripActive ? Colors.green : Colors.grey, 
                                  size: 26
                                ),
                              ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isUiTripActive ? 'Live Location Broadcaster Active' : 'Broadcast Status Standby',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    isUiTripActive ? 'Sync Interval: 5 Seconds' : 'GPS Core Off-Duty',
                                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Direct Action Button with instantly synchronized layouts
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () => _handleDashboardTripToggle(tracking, auth.user!.id),
                          icon: Icon(isUiTripActive ? Iconsax.close_circle5 : Iconsax.play_add5),
                          label: Text(
                            isUiTripActive ? 'End Live Broadcast' : 'Launch Route Trip',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isUiTripActive ? Colors.red : AppTheme.primaryAccentColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms).scaleY(begin: 0.9, end: 1),
              ],
            ),
        ],
      ),
    );
  }
}