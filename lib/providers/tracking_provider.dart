import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../core/constants/app_constants.dart';
import '../core/constants/route_data.dart';
import '../core/utils/eta_calculator.dart';
import '../models/eta_model.dart';
import '../models/live_location_model.dart';
import '../models/stop_model.dart';
import '../models/trip_model.dart';
import '../models/vehicle_model.dart';
import '../services/connectivity_service.dart';
import '../services/live_location_service.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../services/route_service.dart';
import '../services/trip_service.dart';
import '../services/vehicle_service.dart';

class TrackingProvider extends ChangeNotifier {
  final LiveLocationService _liveLocationService;
  final LocationService _locationService;
  final RouteService _routeService;
  final TripService _tripService;
  final VehicleService _vehicleService;
  final NotificationService _notificationService;
  final ConnectivityService _connectivityService;

  TrackingProvider({
    required LiveLocationService liveLocationService,
    required LocationService locationService,
    required RouteService routeService,
    required TripService tripService,
    required VehicleService vehicleService,
    required NotificationService notificationService,
    required ConnectivityService connectivityService,
  })  : _liveLocationService = liveLocationService,
        _locationService = locationService,
        _routeService = routeService,
        _tripService = tripService,
        _vehicleService = vehicleService,
        _notificationService = notificationService,
        _connectivityService = connectivityService;

  List<StopModel> _stops = [];
  Map<String, LiveLocationModel> _liveLocations = {};
  List<EtaModel> _etas = [];
  TripModel? _activeTrip;
  VehicleModel? _driverVehicle;
  List<String> _schedule = [];
  bool _isOnline = true;
  bool _isTripActive = false;
  int _passengerCount = 0;
  String? _selectedStopId;

  StreamSubscription? _locationSub;
  StreamSubscription? _liveLocationsSub;
  StreamSubscription? _connectivitySub;
  Timer? _driverLocationTimer;

  List<StopModel> get stops => _stops;
  Map<String, LiveLocationModel> get liveLocations => _liveLocations;
  List<EtaModel> get etas => _etas;
  TripModel? get activeTrip => _activeTrip;
  VehicleModel? get driverVehicle => _driverVehicle;
  List<String> get schedule => _schedule;
  bool get isOnline => _isOnline;
  bool get isTripActive => _isTripActive;
  int get passengerCount => _passengerCount;
  String? get selectedStopId => _selectedStopId;

  LiveLocationModel? get nearestVehicle {
    if (_liveLocations.isEmpty) return null;
    return _liveLocations.values.first;
  }

  Future<void> initializePassenger({String? selectedStopId}) async {
    _selectedStopId = selectedStopId;
    _stops = await _routeService.getStopsForRoute(RouteData.routeId);
    _schedule = await _routeService.getSchedule(RouteData.routeId);

    _connectivitySub = _connectivityService.onConnectivityChanged.listen((online) {
      _isOnline = online;
      notifyListeners();
    });

    _liveLocationsSub =
        _liveLocationService.watchAllLocations().listen((locations) {
      _liveLocations = locations;
      _recalculateEtas();
      notifyListeners();
    }, onError: (_) {
      _liveLocations = {};
      _etas = [];
      notifyListeners();
    });

    await _notificationService.subscribeToRoute(RouteData.routeId);
  }

  Future<void> initializeDriver(String driverId) async {
    _stops = await _routeService.getStopsForRoute(RouteData.routeId);
    _driverVehicle = await _vehicleService.getVehicleByDriver(driverId);
    _activeTrip = await _tripService.getActiveTripForDriver(driverId);
    _isTripActive = _activeTrip != null;
    if (_activeTrip != null) {
      _passengerCount = _activeTrip!.passengerCount;
    }
    notifyListeners();
  }

  void setSelectedStop(String stopId) {
    _selectedStopId = stopId;
    _notificationService.resetNotifications();
    notifyListeners();
  }

  void _recalculateEtas() {
    if (_liveLocations.isEmpty || _stops.isEmpty) {
      _etas = [];
      return;
    }

    final location = _liveLocations.values.first;
    _etas = EtaCalculator.calculateEtas(
      location: location,
      stops: _stops,
    );

    _notificationService.checkAndNotifyArrival(
      etas: _etas,
      selectedStopId: _selectedStopId,
    );
  }

  Future<bool> startTrip({
    required String driverId,
    required String vehicleId,
  }) async {
    final trip = await _tripService.startTrip(
      driverId: driverId,
      vehicleId: vehicleId,
      routeId: RouteData.routeId,
      stopIds: _stops.map((s) => s.id).toList(),
    );

    _activeTrip = trip;
    _isTripActive = true;
    _startDriverLocationSharing(vehicleId, trip.id, driverId);
    notifyListeners();
    return true;
  }

  Future<void> endTrip() async {
    if (_activeTrip == null || _driverVehicle == null) return;

    _stopDriverLocationSharing();
    await _liveLocationService.removeLocation(_driverVehicle!.id);
    await _tripService.endTrip(_activeTrip!.id);

    _activeTrip = null;
    _isTripActive = false;
    notifyListeners();
  }

  void _startDriverLocationSharing(
    String vehicleId,
    String tripId,
    String driverId,
  ) {
    _driverLocationTimer?.cancel();
    _driverLocationTimer = Timer.periodic(
      const Duration(seconds: AppConstants.locationRefreshSeconds),
      (_) async {
        final position = await _locationService.getCurrentPosition();
        if (position == null) return;

        await _liveLocationService.updateLocation(
          vehicleId: vehicleId,
          tripId: tripId,
          driverId: driverId,
          latitude: position.latitude,
          longitude: position.longitude,
          speed: position.speed,
          heading: position.heading,
        );
      },
    );

    _locationService.startTracking((Position position) async {
      await _liveLocationService.updateLocation(
        vehicleId: vehicleId,
        tripId: tripId,
        driverId: driverId,
        latitude: position.latitude,
        longitude: position.longitude,
        speed: position.speed,
        heading: position.heading,
      );
    });
  }

  void _stopDriverLocationSharing() {
    _driverLocationTimer?.cancel();
    _driverLocationTimer = null;
    _locationService.stopTracking();
  }

  Future<void> updateVehicleStatus(VehicleStatus status) async {
    if (_driverVehicle == null) return;
    await _vehicleService.updateStatus(_driverVehicle!.id, status);
    _driverVehicle = _driverVehicle!.copyWith(status: status);
    notifyListeners();
  }

  Future<void> updatePassengerCount(int count) async {
    _passengerCount = count;
    if (_activeTrip != null) {
      await _tripService.updatePassengerCount(_activeTrip!.id, count);
    }
    if (_driverVehicle != null) {
      await _vehicleService.updatePassengerCount(_driverVehicle!.id, count);
      _driverVehicle = _driverVehicle!.copyWith(currentPassengers: count);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _locationSub?.cancel();
    _liveLocationsSub?.cancel();
    _connectivitySub?.cancel();
    _driverLocationTimer?.cancel();
    _locationService.dispose();
    super.dispose();
  }
}
