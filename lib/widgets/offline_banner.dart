import 'package:flutter/material.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      content: const Text('Offline Mode - Showing cached data'),
      leading: const Icon(Icons.cloud_off, color: Colors.orange),
      backgroundColor: Colors.orange.shade50,
      actions: [
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: const Text('DISMISS'),
        ),
      ],
    );
  }
}
