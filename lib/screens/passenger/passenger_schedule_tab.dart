import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/route_data.dart';
import '../../providers/locale_provider.dart';
import '../../providers/tracking_provider.dart';

class PassengerScheduleTab extends StatelessWidget {
  const PassengerScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tracking = context.watch<TrackingProvider>();
    final locale = context.watch<LocaleProvider>().locale.languageCode;
    final schedule =
        tracking.schedule.isNotEmpty ? tracking.schedule : RouteData.dailyDepartures;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Schedule',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Departures from ${_originName(locale)}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...schedule.asMap().entries.map((entry) {
          final index = entry.key;
          final time = entry.value;
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(time, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              subtitle: Text('Kalpitiya → Kandalkuliya'),
              trailing: const Icon(Icons.arrow_forward),
            ),
          );
        }),
      ],
    );
  }

  String _originName(String locale) {
    switch (locale) {
      case 'si':
        return 'කල්පිටිය';
      case 'ta':
        return 'கல்பிட்டி';
      default:
        return 'Kalpitiya';
    }
  }
}
