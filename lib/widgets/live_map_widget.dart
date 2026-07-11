import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/live_location_model.dart';
import '../models/stop_model.dart';

class LiveMapWidget extends StatefulWidget {
  final List<StopModel> stops;
  final Map<String, LiveLocationModel> liveLocations;
  final String locale;
  final LatLng? userLocation;

  const LiveMapWidget({
    super.key,
    required this.stops,
    required this.liveLocations,
    required this.locale,
    this.userLocation,
  });

  @override
  State<LiveMapWidget> createState() => _LiveMapWidgetState();
}

class _LiveMapWidgetState extends State<LiveMapWidget> {
  @override
  Widget build(BuildContext context) {
    final markers = <Marker>{};
    final polylines = <Polyline>{};

    // 1. முதலாவது For Loop (உங்க கோடில் க்ளோசிங் பிராக்கெட் தப்பாக இருந்த இடம் பிக்ஸ் செய்யப்பட்டுள்ளது)
    for (final stop in widget.stops) {
      markers.add(
        Marker(
          markerId: MarkerId(stop.id),
          position: LatLng(stop.latitude, stop.longitude),
          infoWindow: InfoWindow(title: stop.localizedName(widget.locale)),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }

    // 2. இரண்டாவது For Loop
    for (final entry in widget.liveLocations.entries) {
      final loc = entry.value;
      markers.add(
        Marker(
          markerId: MarkerId('vehicle_${entry.key}'),
          position: LatLng(loc.latitude, loc.longitude),
          infoWindow: const InfoWindow(title: 'Batta Lorry'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ),
      );
    }

    // 3. Polyline கண்டிஷன்
    if (widget.stops.length >= 2) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: widget.stops
              .map((s) => LatLng(s.latitude, s.longitude))
              .toList(),
          color: Theme.of(context).colorScheme.primary,
          width: 4,
        ),
      );
    }

    // 4. ரிட்டன் செய்யும் UI
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          const Text(
            "Live Tracking Map",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Map view is temporarily disabled in development mode.",
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}