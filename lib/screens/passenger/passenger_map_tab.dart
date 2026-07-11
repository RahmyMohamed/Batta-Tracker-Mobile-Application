import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/locale_provider.dart';
import '../../providers/tracking_provider.dart';
import '../../widgets/live_map_widget.dart';

class PassengerMapTab extends StatelessWidget {
  const PassengerMapTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tracking = context.watch<TrackingProvider>();
    final locale = context.watch<LocaleProvider>().locale.languageCode;

    return Column(
      children: [
        if (!tracking.isOnline)
          MaterialBanner(
            content: const Text('Offline - map may show cached route data'),
            leading: const Icon(Icons.cloud_off, color: Colors.orange),
            backgroundColor: Colors.orange.shade50,
            actions: [
              TextButton(
                onPressed: () =>
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                child: const Text('OK'),
              ),
            ],
          ),
        Expanded(
          child: LiveMapWidget(
            stops: tracking.stops,
            liveLocations: tracking.liveLocations,
            locale: locale,
          ),
        ),
        if (tracking.etas.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: tracking.etas.take(3).map((eta) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      eta.stop.localizedName(locale),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('${eta.minutesAway} min'),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
