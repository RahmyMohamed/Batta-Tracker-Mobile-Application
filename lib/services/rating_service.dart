import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/app_constants.dart';
import '../models/rating_model.dart';

class RatingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  Future<void> submitRating({
    required String passengerId,
    required String driverId,
    required String tripId,
    required double rating,
    String? comment,
  }) async {
    final ratingModel = RatingModel(
      id: _uuid.v4(),
      passengerId: passengerId,
      driverId: driverId,
      tripId: tripId,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection(AppConstants.ratingsCollection)
        .doc(ratingModel.id)
        .set(ratingModel.toMap());

    await _updateDriverAverageRating(driverId);
  }

  Future<void> _updateDriverAverageRating(String driverId) async {
    final snapshot = await _firestore
        .collection(AppConstants.ratingsCollection)
        .where('driverId', isEqualTo: driverId)
        .get();

    if (snapshot.docs.isEmpty) return;

    final total = snapshot.docs.fold<double>(
      0,
      (sum, doc) => sum + (doc.data()['rating'] as num).toDouble(),
    );
    final average = total / snapshot.docs.length;

    final vehicleSnapshot = await _firestore
        .collection(AppConstants.vehiclesCollection)
        .where('driverId', isEqualTo: driverId)
        .limit(1)
        .get();

    if (vehicleSnapshot.docs.isNotEmpty) {
      await vehicleSnapshot.docs.first.reference.update({'rating': average});
    }
  }
}
