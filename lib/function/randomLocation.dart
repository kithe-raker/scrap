import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class RandomLocation {
  final random = Random();

  ///declear varieble [r] radius
  var r = 1000 / 111300; // = 1000 meters
  LatLng getLocation({double lat, double lng}) {
    ///random 2 double then init varieble [u] and [v]
    double u = random.nextDouble();
    double v = random.nextDouble();

    ///calurate latitude and longitude within [r]
    ///by get current location + random double
    var w = r * sqrt(u);
    var t = 2 * pi * v;
    var x = w * cos(t);
    var inLng = w * sin(t);
    var inLat = x / cos(lng);

    return LatLng(lat + inLat, lng + inLng);
  }
}

final random = RandomLocation();
