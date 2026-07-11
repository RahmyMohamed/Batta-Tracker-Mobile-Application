import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/app_constants.dart';
import '../models/vehicle_model.dart';

class VehicleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<VehicleModel?> getVehicleByDriver(String driverId) async {
    final snapshot = await _firestore
        .collection(AppConstants.vehiclesCollection)
        .where('driverId', isEqualTo: driverId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return VehicleModel.fromMap(doc.data(), doc.id);
  }

  Future<VehicleModel?> getVehicle(String vehicleId) async {
    final doc = await _firestore
        .collection(AppConstants.vehiclesCollection)
        .doc(vehicleId)
        .get();

    if (!doc.exists) return null;
    return VehicleModel.fromMap(doc.data()!, doc.id);
  }

  Stream<List<VehicleModel>> watchActiveVehicles(String routeId) {
    return _firestore
        .collection(AppConstants.vehiclesCollection)
        .where('routeId', isEqualTo: routeId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VehicleModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> updateStatus(String vehicleId, VehicleStatus status) async {
    await _firestore
        .collection(AppConstants.vehiclesCollection)
        .doc(vehicleId)
        .update({'status': status.name});
  }

  Future<void> updatePassengerCount(String vehicleId, int count) async {
    await _firestore
        .collection(AppConstants.vehiclesCollection)
        .doc(vehicleId)
        .update({'currentPassengers': count});
  }

  Future<void> updateRating(String vehicleId, double newRating) async {
    await _firestore
        .collection(AppConstants.vehiclesCollection)
        .doc(vehicleId)
        .update({'rating': newRating});
  }
}
