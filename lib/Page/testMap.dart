import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TestMap extends StatefulWidget {
  @override
  _TestMapState createState() => _TestMapState();
}

class _TestMapState extends State<TestMap> {
  Position currentLocation;
  @override
  void initState() {
    Geolocator().getCurrentPosition().then((curlo) {
      setState(() {
        currentLocation = curlo;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      //onMapCreated: onMapCreated,
      initialCameraPosition: CameraPosition(target: LatLng(currentLocation.latitude, currentLocation.longitude), zoom: 16),
      // markers: Set<Marker>.of(markers.values),
      // circles: Set<Circle>.of(circles.values),
    ));
  }
}
