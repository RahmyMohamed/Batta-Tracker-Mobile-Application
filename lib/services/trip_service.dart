import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/app_constants.dart';
import '../models/trip_model.dart';

class TripService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  Future<TripModel> startTrip({
    required String driverId,
    required String vehicleId,
    required String routeId,
    required List<String> stopIds,
  }) async {
    final tripId = _uuid.v4();
    final trip = TripModel(
      id: tripId,
      driverId: driverId,
      vehicleId: vehicleId,
      routeId: routeId,
      status: TripStatus.active,
      startedAt: DateTime.now(),
      stopIds: stopIds,
    );

    await _firestore
        .collection(AppConstants.tripsCollection)
        .doc(tripId)
        .set(trip.toMap());

    return trip;
  }

  Future<void> endTrip(String tripId) async {
    await _firestore
        .collection(AppConstants.tripsCollection)
        .doc(tripId)
        .update({
      'status': TripStatus.completed.name,
      'endedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> updatePassengerCount(String tripId, int count) async {
    await _firestore
        .collection(AppConstants.tripsCollection)
        .doc(tripId)
        .update({'passengerCount': count});
  }

  Future<TripModel?> getActiveTripForDriver(String driverId) async {
    final snapshot = await _firestore
        .collection(AppConstants.tripsCollection)
        .where('driverId', isEqualTo: driverId)
        .where('status', isEqualTo: TripStatus.active.name)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return TripModel.fromMap(doc.data(), doc.id);
  }

  Stream<TripModel?> watchActiveTripForDriver(String driverId) {
    return _firestore
        .collection(AppConstants.tripsCollection)
        .where('driverId', isEqualTo: driverId)
        .where('status', isEqualTo: TripStatus.active.name)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      final doc = snapshot.docs.first;
      return TripModel.fromMap(doc.data(), doc.id);
    });
  }
}
