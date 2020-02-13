import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScraps extends StatefulWidget {
  final Position currentLocation;
  final List users;
  final Map scraps;
  final String uid;
  MapScraps(
      {@required this.currentLocation,
      @required this.users,
      @required this.scraps,
      @required this.uid});
  @override
  _MapScrapsState createState() => _MapScrapsState();
}

class _MapScrapsState extends State<MapScraps> {
  Position currentLocation;
  List users = [];
  Map scraps = {};
  BitmapDescriptor _curcon, scrapIcon;
  bool checkPlatform = Platform.isIOS;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<CircleId, Circle> circles = <CircleId, Circle>{};
  GoogleMapController mapController;

  @override
  void initState() {
    currentLocation = widget.currentLocation;
    for (var user in widget.users) {
      users.add(user);
      scraps[user] = widget.scraps[user];
    }
    super.initState();
  }

  error(BuildContext context, String sub) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            "ขออภัย",
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            sub,
            style: TextStyle(fontSize: 16),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'ตกลง',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  dialog(String text) {
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              backgroundColor: Colors.transparent,
              content:
                  StatefulBuilder(builder: (context, StateSetter setState) {
                Size a = MediaQuery.of(context).size;
                return Container(
                  width: a.width,
                  height: a.height / 1.76,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: a.width,
                        child: Image.asset(
                          'assets/paper-readed.png',
                          width: a.width,
                          height: a.height / 2.1,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('เขียนโดย : ใครสักคน'),
                                Text('เวลา : 9:00')
                              ],
                            ),
                          )),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: a.width / 1.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  width: a.width / 3.5,
                                  height: a.width / 6.5,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(a.width)),
                                  alignment: Alignment.center,
                                  child: Text("เก็บไว้",
                                      style: TextStyle(
                                          fontSize: a.width / 15,
                                          color: Color(0xff26A4FF))),
                                ),
                                onTap: () async {
                                  Navigator.pop(context);
                                  await Firestore.instance
                                      .collection('User')
                                      .document('scraps')
                                      .updateData({
                                    'collects': FieldValue.arrayUnion([text])
                                  });
                                },
                              ),
                              InkWell(
                                child: Container(
                                  width: a.width / 3.5,
                                  height: a.width / 6.5,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(a.width)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "ทิ้งไว้",
                                    style: TextStyle(fontSize: a.width / 15),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          left: a.width / 16,
                          top: a.height / 12,
                          child: Container(
                            alignment: Alignment.center,
                            height: a.height / 3.2,
                            width: a.width / 1.48,
                            child: Text(
                              text,
                              style: TextStyle(fontSize: a.width / 14),
                            ),
                          ))
                    ],
                  ),
                );
              }));
        });
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    _createMarkerImageFromAsset(context);
    _createScrapImageFromAsset(context);
    return Scaffold(
        body: Container(
      width: a.width,
      height: a.height,
      child: GoogleMap(
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        onMapCreated: onMapCreated,
        initialCameraPosition: CameraPosition(
            target: LatLng(currentLocation?.latitude ?? 0,
                currentLocation?.longitude ?? 0),
            zoom: 16),
        markers: Set<Marker>.of(markers.values),
        circles: Set<Circle>.of(circles.values),
      ),
    ));
  }
  /*
         Set id = {};
            List scraps = [];
            for (var usersID in snap.data['id']) {
              id.add(usersID);
              for (var scrap in snap.data['scraps'][usersID]) {
                scraps.add(scrap);
              }
            } */

  void onMapCreated(GoogleMapController controller) {
    this.mapController = controller;
    userMarker();
    _addCircle(800);
    for (var usersID in users) {
      for (var scrap in scraps[usersID]) {
        if (calculateDistance(currentLocation.latitude,
                    currentLocation.longitude, scrap['lat'], scrap['lng']) <=
                800 &&
            usersID != widget.uid) {
          _addMarker(usersID, scrap['text'], scrap['lat'], scrap['lng'],
              scraps[usersID].indexOf(scrap));
        } else {
          print('nope');
        }
      }
    }
  }

  void _addMarker(String id, String text, double lat, double lng, int index) {
    final MarkerId markerId = MarkerId(id + index.toString());
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      icon: scrapIcon,
      onTap: () async {
        try {
          markers.remove(markerId);
          setState(() {});
          dialog(text);
        } catch (e) {
          print(e.toString());
          error(context,
              'เกิดข้อผิดพลาด ไม่ทราบสาเหตุกรุณาตรวจสอบการเชื่อต่ออินเทอร์เน็ต');
        }
      },
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  userMarker() {
    MarkerId markerId = MarkerId('user');
    LatLng position = LatLng(
        currentLocation != null ? currentLocation.latitude : 0.0,
        currentLocation != null ? currentLocation.longitude : 0.0);
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      icon: _curcon,
      draggable: false,
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  void _addCircle(double radius) {
    final CircleId circleId = CircleId('circle_id');
    final Circle circle = Circle(
      circleId: circleId,
      consumeTapEvents: true,
      strokeColor: Color.fromRGBO(23, 23, 23, 0.4),
      fillColor: Color.fromRGBO(67, 78, 80, 0.1),
      strokeWidth: 4,
      center: LatLng(currentLocation.latitude, currentLocation.longitude),
      radius: radius,
    );
    setState(() {
      circles[circleId] = circle;
    });
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_curcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration,
              checkPlatform
                  ? 'assets/yourlocation-icon-l.png'
                  : 'assets/yourlocation-icon-l.png')
          .then(_updateBitmap);
    }
  }

  Future<void> _createScrapImageFromAsset(BuildContext context) async {
    if (scrapIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration,
              checkPlatform
                  ? 'assets/paper-mini01.png'
                  : 'assets/paper-mini01.png')
          .then(_updateBitScrap);
    }
  }

  void _updateBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _curcon = bitmap;
    });
  }

  void _updateBitScrap(BitmapDescriptor bitmap) {
    setState(() {
      scrapIcon = bitmap;
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
