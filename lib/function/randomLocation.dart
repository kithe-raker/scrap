import 'dart:math';

class RandomLocation {
  final random = Random();
  var r = 72 / 111300; // = 64 meters
  Map getLocation({double lat, double lng}) {
    double u = random.nextDouble();
    double v = random.nextDouble();
    var w = r * sqrt(u);
    var t = 2 * pi * v;
    var x = w * cos(t);
    var inLng = w * sin(t);
    var inLat = x / cos(lng);
    double ranLat() {
      return lat + inLat;
    }

    double ranLng() {
      return lng + inLng;
    }

    return {'lat': ranLat(), 'lng': ranLng()};
  }
}
