import 'package:flutter_test/flutter_test.dart';
import 'package:batta_tracker/core/utils/distance_utils.dart';
import 'package:batta_tracker/core/utils/eta_calculator.dart';
import 'package:batta_tracker/models/live_location_model.dart';
import 'package:batta_tracker/models/stop_model.dart';

void main() {
  group('DistanceUtils', () {
    test('haversineKm returns reasonable distance', () {
      // Kalpitiya to Norochcholai (~25 km)
      final distance = DistanceUtils.haversineKm(
        8.2311, 79.7614,
        8.0167, 79.7167,
      );
      expect(distance, greaterThan(20));
      expect(distance, lessThan(35));
    });
  });

  group('EtaCalculator', () {
    final stops = [
      const StopModel(
        id: 's1',
        name: 'Kalpitiya',
        nameSi: 'කල්පිටිය',
        nameTa: 'கல்பிட்டி',
        latitude: 8.2311,
        longitude: 79.7614,
        order: 0,
      ),
      const StopModel(
        id: 's2',
        name: 'Kandalkuliya',
        nameSi: 'කන්දකුලිය',
        nameTa: 'கண்டக்குளிய',
        latitude: 8.2450,
        longitude: 79.7850,
        order: 1,
      ),
    ];

    test('calculateEtas returns ETA for each stop', () {
      final location = LiveLocationModel(
        vehicleId: 'v1',
        tripId: 't1',
        driverId: 'd1',
        latitude: 8.2311,
        longitude: 79.7614,
        timestamp: DateTime.now(),
      );

      final etas = EtaCalculator.calculateEtas(
        location: location,
        stops: stops,
      );

      expect(etas.length, 2);
      expect(etas.first.minutesAway, greaterThan(0));
    });
  });
}
