import 'package:firebase_database/firebase_database.dart';

import '../core/constants/app_constants.dart';
import '../models/live_location_model.dart';

class LiveLocationService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  DatabaseReference get _liveLocationsRef =>
      _database.ref(AppConstants.liveLocationsPath);

  /// Push driver's live GPS location to Realtime Database.
  Future<void> updateLocation({
    required String vehicleId,
    required String tripId,
    required String driverId,
    required double latitude,
    required double longitude,
    double? speed,
    double? heading,
  }) async {
    final location = LiveLocationModel(
      vehicleId: vehicleId,
      tripId: tripId,
      driverId: driverId,
      latitude: latitude,
      longitude: longitude,
      speed: speed,
      heading: heading,
      timestamp: DateTime.now(),
    );

    await _liveLocationsRef.child(vehicleId).set(location.toMap());
  }

  /// Remove location when trip ends.
  Future<void> removeLocation(String vehicleId) async {
    await _liveLocationsRef.child(vehicleId).remove();
  }

  /// Stream all active vehicle locations.
  Stream<Map<String, LiveLocationModel>> watchAllLocations() {
    return _liveLocationsRef.onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null || data is! Map) return {};

      return Map<String, LiveLocationModel>.fromEntries(
        data.entries.map((e) {
          final map = Map<String, dynamic>.from(e.value as Map);
          return MapEntry(
            e.key.toString(),
            LiveLocationModel.fromMap(map, e.key.toString()),
          );
        }),
      );
    }).handleError((error) {
      return <String, LiveLocationModel>{};
    });
  }

  /// Stream a single vehicle's location.
  Stream<LiveLocationModel?> watchVehicleLocation(String vehicleId) {
    return _liveLocationsRef.child(vehicleId).onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null || data is! Map) return null;
      return LiveLocationModel.fromMap(
        Map<String, dynamic>.from(data),
        vehicleId,
      );
    }).handleError((error) {
      return null;
    });
  }
}
