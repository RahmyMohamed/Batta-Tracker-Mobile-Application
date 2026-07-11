import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../core/constants/route_data.dart';
import '../models/stop_model.dart';

class RouteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<StopModel>> getStopsForRoute(String routeId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.routesCollection)
          .doc(routeId)
          .collection(AppConstants.stopsCollection)
          .orderBy('order')
          .get();

      if (snapshot.docs.isNotEmpty) {
        final stops = snapshot.docs
            .map((doc) => StopModel.fromMap(doc.data(), doc.id))
            .toList();
        await _cacheStops(stops);
        return stops;
      }
    } catch (_) {
      // Fall through to cache or defaults
    }

    final cached = await _getCachedStops();
    if (cached.isNotEmpty) return cached;

    return RouteData.defaultStops;
  }

  Future<List<String>> getSchedule(String routeId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.schedulesCollection)
          .doc(routeId)
          .get();

      if (doc.exists && doc.data()?['departures'] != null) {
        final departures =
            List<String>.from(doc.data()!['departures'] as List);
        await _cacheSchedule(departures);
        return departures;
      }
    } catch (_) {
      // Fall through
    }

    final cached = await _getCachedSchedule();
    return cached.isNotEmpty ? cached : RouteData.dailyDepartures;
  }

  Future<void> addCustomStop(String routeId, StopModel stop) async {
    await _firestore
        .collection(AppConstants.routesCollection)
        .doc(routeId)
        .collection(AppConstants.stopsCollection)
        .doc(stop.id)
        .set(stop.toMap());
  }

  Future<void> _cacheStops(List<StopModel> stops) async {
    final prefs = await SharedPreferences.getInstance();
    final json = stops.map((s) => {'id': s.id, ...s.toMap()}).toList();
    await prefs.setString(
      AppConstants.prefCachedRoute,
      jsonEncode(json),
    );
  }

  Future<List<StopModel>> _getCachedStops() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConstants.prefCachedRoute);
    if (raw == null) return [];

    final list = jsonDecode(raw) as List;
    return list
        .map((item) => StopModel.fromMap(
              Map<String, dynamic>.from(item as Map),
              item['id'] as String,
            ))
        .toList();
  }

  Future<void> _cacheSchedule(List<String> departures) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.prefCachedSchedule,
      jsonEncode(departures),
    );
  }

  Future<List<String>> _getCachedSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConstants.prefCachedSchedule);
    if (raw == null) return [];
    return List<String>.from(jsonDecode(raw) as List);
  }
}
