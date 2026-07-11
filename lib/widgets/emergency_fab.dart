import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/constants/app_constants.dart';

class EmergencyFab extends StatelessWidget {
  const EmergencyFab({super.key});

  Future<void> _showEmergencyDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.emergency, color: Colors.red),
            SizedBox(width: 8),
            Text('Emergency Contact'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.local_police, color: Colors.blue),
              title: const Text('Police'),
              subtitle: Text(AppConstants.emergencyPolice),
              onTap: () => _call(AppConstants.emergencyPolice),
            ),
            ListTile(
              leading: const Icon(Icons.local_hospital, color: Colors.red),
              title: const Text('Ambulance'),
              subtitle: Text(AppConstants.emergencyAmbulance),
              onTap: () => _call(AppConstants.emergencyAmbulance),
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text('Transport Hotline'),
              subtitle: Text(AppConstants.emergencyPhone),
              onTap: () => _call(AppConstants.emergencyPhone),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _call(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showEmergencyDialog(context),
      backgroundColor: Colors.red,
      icon: const Icon(Icons.emergency),
      label: const Text('SOS'),
    );
  }
}
