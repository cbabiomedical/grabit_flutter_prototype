import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController _mapController;

  // --------------------------------------------------
  // TEMP STATIC MACHINE DATA (replace with backend)
  // --------------------------------------------------
  final List<Map<String, dynamic>> _machines = [
    {
      "id": 35,
      "serialNo": "1029413CHY01",
      "name": "CCSF Office",
      "latitude": 6.925123500000001,
      "longitude": 79.8484904,
      "color": "#4287f5",
    },
    {
      "id": 45,
      "serialNo": "20250508031",
      "name": "Medocs Health Services (Pvt) Ltd",
      "latitude": 6.912775222930772,
      "longitude": 79.84968970214848,
      "color": "#4287f5",
    },
    {
      "id": 49,
      "serialNo": "1111111111",
      "name": "Ceylon Business Appliances (Pvt) Ltd",
      "latitude": 6.850406520906241,
      "longitude": 79.87374869607665,
      "color": "#4287f5",
    },
  ];

  // --------------------------------------------------
  // MARKERS
  // --------------------------------------------------
  Set<Marker> get _markers {
    return _machines.map((m) {
      final position = LatLng(m["latitude"], m["longitude"]);
      final color = _hexToColor(m["color"]);

      return Marker(
        markerId: MarkerId(m["id"].toString()),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
        infoWindow: InfoWindow(
          title: m["name"],
          // snippet: "Serial: ${m["serialNo"]}",
        ),
      );
    }).toSet();
  }

  // --------------------------------------------------
  // INITIAL CAMERA POSITION (centered)
  // --------------------------------------------------
  LatLng get _initialCenter {
    final lat =
        _machines.map((m) => m["latitude"] as double).reduce((a, b) => a + b) /
            _machines.length;
    final lng =
        _machines.map((m) => m["longitude"] as double).reduce((a, b) => a + b) /
            _machines.length;

    return LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // --------------------------
            // GOOGLE MAP
            // --------------------------
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialCenter,
                zoom: 12,
              ),
              markers: _markers,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),

            // --------------------------
            // TOP LABEL
            // --------------------------
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
                    Icon(Icons.location_on,
                        color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text(
                      "Nearby Machines",
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

  // // --------------------------------------------------
  // // COLOR HELPERS
  // // --------------------------------------------------
  Color _hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    return Color(int.parse("FF$hex", radix: 16));
  }
  //
  // double _colorToHue(Color color) {
  //   return HSVColor.fromColor(color).hue;
  // }
}


// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class MapWidget extends StatelessWidget {
//   const MapWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final machineLocation = const LatLng(6.9271, 79.8612); // Colombo (dummy)
//
//     return Padding(
//       padding: const EdgeInsets.all(8),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Stack(
//           children: [
//             // MAP
//             GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: machineLocation,
//                 zoom: 15,
//               ),
//               markers: {
//                 Marker(
//                   markerId: const MarkerId("machine_1"),
//                   position: machineLocation,
//                   infoWindow: const InfoWindow(
//                     title: "GrabIt Machine",
//                   ),
//                 ),
//               },
//               zoomControlsEnabled: false,
//               myLocationButtonEnabled: false,
//               compassEnabled: false,
//               mapToolbarEnabled: false,
//             ),
//
//             // TOP LABEL OVERLAY
//             Positioned(
//               top: 12,
//               left: 12,
//               child: Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.teal.shade700.withOpacity(0.9),
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 6,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: const Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.location_on,
//                       color: Colors.white,
//                       size: 16,
//                     ),
//                     SizedBox(width: 6),
//                     Text(
//                       "Nearby Machine",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
