import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final machineLocation = const LatLng(6.9271, 79.8612); // Colombo (dummy)

    return Padding(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // MAP
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: machineLocation,
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("machine_1"),
                  position: machineLocation,
                  infoWindow: const InfoWindow(
                    title: "GrabIt Machine",
                  ),
                ),
              },
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
            ),

            // TOP LABEL OVERLAY
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.teal.shade700.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Nearby Machine",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class MapWidget extends StatelessWidget {
//   const MapWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final machineLocation = const LatLng(6.9271, 79.8612); // Colombo dummy
//
//     return GoogleMap(
//       initialCameraPosition: CameraPosition(
//         target: machineLocation,
//         zoom: 15,
//       ),
//       markers: {
//         Marker(
//           markerId: const MarkerId("machine_1"),
//           position: machineLocation,
//           infoWindow: const InfoWindow(title: "GrabIt Machine"),
//         ),
//       },
//     );
//   }
// }
