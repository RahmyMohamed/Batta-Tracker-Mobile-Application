import 'stop_model.dart';

class EtaModel {
  final StopModel stop;
  final int minutesAway;
  final DateTime estimatedArrival;
  final double distanceKm;

  const EtaModel({
    required this.stop,
    required this.minutesAway,
    required this.estimatedArrival,
    required this.distanceKm,
  });

  bool get isNearArrival => minutesAway <= 5;
}
