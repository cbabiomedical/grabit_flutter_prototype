import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final machineLocation = const LatLng(6.9271, 79.8612); // Colombo dummy

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: machineLocation,
        zoom: 15,
      ),
      markers: {
        Marker(
          markerId: const MarkerId("machine_1"),
          position: machineLocation,
          infoWindow: const InfoWindow(title: "GrabIt Machine"),
        ),
      },
    );
  }
}
