import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class map_screen extends StatefulWidget {
  @override
  _map_screenState createState() => _map_screenState();
}

class _map_screenState extends State<map_screen> {
  GoogleMapController? _controller;
  LatLng? _currentPosition = LatLng(20.296135, 85.827828);
  String _placeName = 'Tap on the map to get place name';
  Marker? _selectedMarker;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    if (await Permission.location.request().isGranted) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _getPlaceName(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      setState(() {
        _placeName = placemarks.first.name ?? '';
        _selectedMarker = Marker(
          markerId: MarkerId('selected_place'),
          position: position,
          infoWindow: InfoWindow(title: _placeName),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Selects Address')),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(20.296135, 85.827828),
                      zoom: 15,
                    ),
                    onMapCreated: (controller) {
                      _controller = controller;
                    },
                    markers: _selectedMarker != null ? {_selectedMarker!} : {},
                    onTap: (position) {
                      _getPlaceName(position);
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 10,
                  right: 10,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          _placeName,
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 10),
                      _placeName != 'Tap on the map to get place name'
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, _placeName);
                              },
                              child: Text('Select this address'),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

// class map_screen extends StatefulWidget {
//   const map_screen({super.key});

//   @override
//   State<map_screen> createState() => _map_screenState();
// }

// class _map_screenState extends State<map_screen> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.hybrid,
//         initialCameraPosition:
//             CameraPosition(target: LatLng(20.296135, 85.827828), zoom: 15.0),
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//     );
//   }
// }
