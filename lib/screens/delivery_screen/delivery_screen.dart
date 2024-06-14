import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryScreen extends StatefulWidget {
  DeliveryScreen({super.key, required this.lat, required this.lng});
  final double lat;
  final double lng;
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  Location location = Location();
  PolylinePoints polylinePoints = PolylinePoints();
  Marker? soursePosition, destinatonPosition;
  loc.LocationData? _currentPosition;
  LatLng curLocation = LatLng(20.2948, 72.5667);
  StreamSubscription<loc.LocationData>? locationSubscription;
  @override
  void initState() {
    getNavigation();
    addMarker();
    super.initState();
  }

  @override
  void dispose() {
    locationSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: soursePosition == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                GoogleMap(
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: curLocation,
                    zoom: 18,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: {soursePosition!, destinatonPosition!},
                  polylines: Set<Polyline>.of(polylines.values),
                ),
                Positioned(
                    top: 30,
                    left: 15,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back),
                    )),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () async {
                          await launchUrl(Uri.parse(
                              'google.navigation:q=${widget.lat},${widget.lng}'));
                        },
                        icon: Icon(
                          Icons.navigation_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }

  addMarker() {
    soursePosition = Marker(
      markerId: MarkerId('source'),
      position: curLocation,
      infoWindow: InfoWindow(title: 'Source'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );
    destinatonPosition = Marker(
      markerId: MarkerId('destination'),
      position: LatLng(23.0756, 72.5667),
      infoWindow: InfoWindow(title: 'Destination'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
    );
  }

  getNavigation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    final GoogleMapController controller = await _controller.future;
    location.changeSettings(
        accuracy: loc.LocationAccuracy.high, distanceFilter: 10);
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    if (_permissionGranted == loc.PermissionStatus.granted) {
      _currentPosition = await location.getLocation();
      curLocation =
          LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
      locationSubscription =
          location.onLocationChanged.listen((LocationData currentLocation) {
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
          zoom: 18,
        )));
        if (mounted) {
          controller
              .showMarkerInfoWindow(MarkerId(soursePosition!.markerId.value));
          setState(() {
            curLocation =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
            soursePosition = Marker(
              markerId: MarkerId(currentLocation.toString()),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              position:
                  LatLng(currentLocation.latitude!, currentLocation.longitude!),
              infoWindow: InfoWindow(
                  title: double.parse(
                          (getDistance(LatLng(widget.lat, widget.lng))
                              .toStringAsFixed(2)))
                      .toString()),
              onTap: () {
                print('market tapped');
              },
            );
          });
          getDirection(LatLng(widget.lat, widget.lng));
        }
      });
    }
  }

  getDirection(LatLng dst) async {
    List<LatLng> polylinecoordinates = [];
    List<dynamic> points = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyCan8z9oL40cG1ntV-YBcJHvHJ9XZO5WOM',
        PointLatLng(curLocation.latitude, curLocation.longitude),
        PointLatLng(dst.latitude, dst.longitude),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylinecoordinates.add(LatLng(point.latitude, point.longitude));
        points.add({
          'lat': point.latitude,
          'lng': point.longitude,
        });
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylinecoordinates);
  }

  addPolyLine(List<LatLng> polylinecoordinates) {
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylinecoordinates,
      width: 3,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double getDistance(LatLng destination) {
    return calculateDistance(curLocation.latitude, curLocation.longitude,
        destination.latitude, destination.longitude);
  }
}
