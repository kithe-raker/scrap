import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class MapScraps extends StatefulWidget {
  final Position currentLocation;
  final String uid;
  final List collection;
  MapScraps(
      {@required this.currentLocation,
      @required this.uid,
      @required this.collection});
  @override
  _MapScrapsState createState() => _MapScrapsState();
}

class _MapScrapsState extends State<MapScraps> {
  Position currentLocation;
  bool loadMap = false;
  BitmapDescriptor _curcon, scrapIcon;
  bool checkPlatform = Platform.isIOS;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<CircleId, Circle> circles = <CircleId, Circle>{};
  GoogleMapController mapController;
  var radius = BehaviorSubject<double>.seeded(0.1);
  Stream<dynamic> query;
  StreamSubscription subscription;
  Set picked = {};

  @override
  void initState() {
    currentLocation = widget.currentLocation;
    loadMap = true;
    super.initState();
  }

  error(BuildContext context, String sub) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            "ขออภัยค่ะ",
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

  dialog(String text, String writer, String time) {
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
                                Text('เขียนโดย : @$writer'),
                                Text('เวลา : $time')
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
                                      .collection('Users')
                                      .document(widget.uid)
                                      .collection('scraps')
                                      .document('collection')
                                      .updateData({
                                    'scraps': FieldValue.arrayUnion([text])
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
        body: Stack(
      children: <Widget>[
        Container(
          width: a.width,
          height: a.height,
          child: loadMap
              ? GoogleMap(
                  myLocationButtonEnabled: false,
                  myLocationEnabled: false,
                  onMapCreated: onMapCreated,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(currentLocation?.latitude ?? 0,
                          currentLocation?.longitude ?? 0),
                      zoom: 18),
                  markers: Set<Marker>.of(markers.values),
                  circles: Set<Circle>.of(circles.values),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            padding: EdgeInsets.only(bottom: a.width / 10),
            alignment: Alignment.bottomCenter,
            width: a.width,
            height: a.height / 1.1,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: a.width / 7,
                    height: a.width / 7,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff1a1a1a),
                            blurRadius: 3.0,
                            spreadRadius: 2.0,
                            offset: Offset(
                              0.0,
                              3.2,
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.circular(a.width),
                        color: Colors.white),
                    child: IconButton(
                      icon: Icon(Icons.location_on),
                      color: Color(0xff26A4FF),
                      iconSize: a.width / 12,
                      onPressed: () {
                        _animateToUser();
                      },
                    ),
                  ),
                  SizedBox(
                    width: a.width / 21,
                  ),
                  SizedBox(
                    width: a.width / 7,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
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

  changeMapMode() {
    getJsonFile("assets/mapStyle.json").then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    this.mapController.setMapStyle(mapStyle);
  }

  void onMapCreated(GoogleMapController controller) {
    this.mapController = controller;
    changeMapMode();
    userMarker(
      currentLocation != null ? currentLocation.latitude : 0.0,
      currentLocation != null ? currentLocation.longitude : 0.0,
    );
    _addCircle(100, currentLocation.latitude, currentLocation.longitude);
    _startQuery();
    Geolocator().getPositionStream().listen((location) {
      userMarker(location.latitude, location.longitude);
      _addCircle(100, location.latitude, location.longitude);
      _startQuery(position: location);
      _animateToUser(position: location);
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList, Position position) {
    markers.clear();
    userMarker(position.latitude, position.longitude);
    documentList.forEach((DocumentSnapshot document) {
      var data = document.data;
      GeoPoint loca = data['position']['geopoint'];
      widget.collection.contains(data['text']) ||
              data['uid'] == widget.uid ||
              picked.contains(data['id'])
          ? null
          : _addMarker(
              data['id'],
              data['uid'],
              data['scrap']['user'],
              data['scrap']['text'],
              data['scrap']['time'],
              loca.latitude,
              loca.longitude);
    });
  }

  _animateToUser({Position position}) async {
    var pos = await Geolocator().getCurrentPosition();
    this
        .mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(
            position == null ? pos.latitude : position.latitude,
            position == null ? pos.longitude : position.longitude,
          ),
          zoom: 18.0,
        )));
  }

  _startQuery({Position position}) async {
    var pos = await Geolocator().getCurrentPosition();
    // Make a referece to firestore
    var ref = Firestore.instance
        .collection('Scraps')
        .document('hatyai')
        .collection('scrapsPosition');
    GeoFirePoint center = Geoflutterfire().point(
        latitude: position?.latitude ?? pos.latitude,
        longitude: position?.longitude ?? pos.longitude);

    // subscribe to query
    subscription = radius.switchMap((rad) {
      return Geoflutterfire().collection(collectionRef: ref).within(
          center: center, radius: rad, field: 'position', strictMode: true);
    }).listen((list) {
      _updateMarkers(list, position ?? pos);
    });
  }

  cameraAnime(GoogleMapController controller, double lat, double lng) {
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, lng), zoom: 12, bearing: 90, tilt: 45)));
  }

  void _addMarker(String id, String user, String writer, String text,
      String time, double lat, double lng) {
    final MarkerId markerId = MarkerId(id);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      icon: scrapIcon,
      onTap: () async {
        try {
          markers.remove(markerId);
          picked.add(id);
          setState(() {});
          dialog(text, writer, time);
          increaseTransaction(user, 'read');
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

  userMarker(double lat, double lng) {
    MarkerId markerId = MarkerId('user');
    LatLng position = LatLng(lat, lng);
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

  void _addCircle(double radius, double lat, double lng) {
    final CircleId circleId = CircleId('circle_id');
    final Circle circle = Circle(
      circleId: circleId,
      consumeTapEvents: true,
      strokeColor: Color.fromRGBO(23, 23, 23, 0.4),
      fillColor: Color.fromRGBO(67, 78, 80, 0.1),
      strokeWidth: 4,
      center: LatLng(lat, lng),
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

  increaseTransaction(String uid, String key) async {
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document(uid)
        .get()
        .then((value) => Firestore.instance
            .collection('Users')
            .document(uid)
            .collection('info')
            .document(uid)
            .updateData(
                {key: value?.data[key] == null ? 1 : ++value.data[key]}));
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }
}
