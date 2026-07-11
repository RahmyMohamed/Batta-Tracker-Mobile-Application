import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/route_data.dart';
import '../../models/stop_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/tracking_provider.dart';
import '../../widgets/eta_card.dart';
import '../../widgets/offline_banner.dart';

class PassengerDashboardTab extends StatelessWidget {
  const PassengerDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tracking = context.watch<TrackingProvider>();
    final auth = context.watch<AuthProvider>();
    final locale = context.watch<LocaleProvider>().locale.languageCode;

    return RefreshIndicator(
      onRefresh: () async {
        await tracking.initializePassenger(
          selectedStopId: auth.user?.selectedStopId,
        );
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!tracking.isOnline) const OfflineBanner(),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Route',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _routeName(locale),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${tracking.stops.length} stops',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _StopSelector(
            stops: tracking.stops,
            selectedStopId: tracking.selectedStopId,
            locale: locale,
            onSelected: (stopId) async {
              tracking.setSelectedStop(stopId);
              await auth.updateSelectedStop(stopId);
            },
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    tracking.nearestVehicle != null
                        ? Icons.directions_bus
                        : Icons.directions_bus_outlined,
                    size: 40,
                    color: tracking.nearestVehicle != null
                        ? Colors.green
                        : Colors.grey,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nearby Vehicle',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          tracking.nearestVehicle != null
                              ? '${tracking.liveLocations.length} active vehicle(s)'
                              : 'No vehicles nearby',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  if (tracking.nearestVehicle != null)
                    const Icon(Icons.gps_fixed, color: Colors.green),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Estimated Arrival Times',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          if (tracking.etas.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'Waiting for active vehicles...',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ),
            )
          else
            ...tracking.etas.map(
              (eta) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: EtaCard(
                  eta: eta,
                  locale: locale,
                  isSelected: eta.stop.id == tracking.selectedStopId,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _routeName(String locale) {
    switch (locale) {
      case 'si':
        return RouteData.routeNameSi;
      case 'ta':
        return RouteData.routeNameTa;
      default:
        return RouteData.routeName;
    }
  }
}

class _StopSelector extends StatelessWidget {
  final List<StopModel> stops;
  final String? selectedStopId;
  final String locale;
  final ValueChanged<String> onSelected;

  const _StopSelector({
    required this.stops,
    required this.selectedStopId,
    required this.locale,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Your Stop',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedStopId,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_on),
                hintText: 'Choose stop for notifications',
              ),
              items: stops
                  .map<DropdownMenuItem<String>>(
                    (stop) => DropdownMenuItem(
                      value: stop.id,
                      child: Text(stop.localizedName(locale)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) onSelected(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
