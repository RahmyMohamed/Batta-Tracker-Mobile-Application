import '../constants/app_constants.dart';
import '../../models/eta_model.dart';
import '../../models/live_location_model.dart';
import '../../models/stop_model.dart';
import 'distance_utils.dart';

class EtaCalculator {
  EtaCalculator._();

  /// Calculate ETA for each stop based on vehicle's current location.
  static List<EtaModel> calculateEtas({
    required LiveLocationModel location,
    required List<StopModel> stops,
    double speedKmh = AppConstants.averageSpeedKmh,
  }) {
    final effectiveSpeed = (location.speed != null && location.speed! > 5)
        ? location.speed! * 3.6 // m/s to km/h
        : speedKmh;

    final sortedStops = List<StopModel>.from(stops)
      ..sort((a, b) => a.order.compareTo(b.order));

    return sortedStops.map((stop) {
      final distanceKm = DistanceUtils.haversineKm(
        location.latitude,
        location.longitude,
        stop.latitude,
        stop.longitude,
      );

      final hours = distanceKm / effectiveSpeed;
      final minutesAway = (hours * 60).ceil().clamp(1, 999);
      final estimatedArrival =
          DateTime.now().add(Duration(minutes: minutesAway));

      return EtaModel(
        stop: stop,
        minutesAway: minutesAway,
        estimatedArrival: estimatedArrival,
        distanceKm: distanceKm,
      );
    }).toList();
  }

  /// Find the nearest stop to a given location.
  static StopModel? findNearestStop({
    required double latitude,
    required double longitude,
    required List<StopModel> stops,
  }) {
    if (stops.isEmpty) return null;

    StopModel? nearest;
    double minDistance = double.infinity;

    for (final stop in stops) {
      final dist = DistanceUtils.haversineKm(
        latitude,
        longitude,
        stop.latitude,
        stop.longitude,
      );
      if (dist < minDistance) {
        minDistance = dist;
        nearest = stop;
      }
    }
    return nearest;
  }
}
