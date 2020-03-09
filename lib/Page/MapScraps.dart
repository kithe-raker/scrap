import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrap/function/randomLocation.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/widget/Toast.dart';

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
  int i = 0;
  String date, time;
  bool loadMap = false;
  BitmapDescriptor _curcon, scrapIcon;
  bool checkPlatform = Platform.isIOS;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<CircleId, Circle> circles = <CircleId, Circle>{};
  GoogleMapController mapController;
  var radius = BehaviorSubject<double>.seeded(0.1);
  StreamSubscription subscription;
  DateTime now = DateTime.now();
  Set scpContent = {};
  Map randData = {};
  Set picked = {};
  Scraps scrap = Scraps();
  final infoKey = GlobalKey();

  @override
  void initState() {
    time = DateFormat('Hm').format(now);
    date = DateFormat('d/M/y').format(now);
    currentLocation = widget.currentLocation;
    loadMap = true;
    queryManagement();
    loopRandomMarker(currentLocation);
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

  //sssss
  void dialog(String text, String writer, String time, String date, String id) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      Size a = MediaQuery.of(context).size;
      return StatefulBuilder(builder: (context, StateSetter setState) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              InkWell(
                child: Container(
                  child: Image.asset(
                    'assets/bg.png',
                    fit: BoxFit.cover,
                    width: a.width,
                    height: a.height,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Container(
                margin: EdgeInsets.only(
                  top: a.height / 8,
                ),
                padding:
                    EdgeInsets.only(left: a.width / 20, right: a.width / 20),
                width: a.width,
                height: a.height / 1.3,
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              width: a.width,
                              child: Image.asset(
                                'assets/paper-readed.png',
                                width: a.width,
                                height: a.height / 1.6,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                                top: 12,
                                left: 12,
                                right: 12,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        writer == 'ไม่ระบุตัวตน'
                                            ? 'เขียนโดย : ใครบางคน'
                                            : 'เขียนโดย : @$writer',
                                        style:
                                            TextStyle(fontSize: a.width / 25),
                                      ),
                                      Text('เวลา : $time $date',
                                          style:
                                              TextStyle(fontSize: a.width / 25))
                                    ],
                                  ),
                                )),
                            Positioned(
                                left: a.width / 16,
                                top: a.height / 6.6,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: a.height / 3.2,
                                  width: a.width / 1.3,
                                  child: Text(
                                    text,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: a.width / 14),
                                  ),
                                )),
                            // Positioned(
                            //   bottom: 0,
                            //   left: 12,
                            //   right: 12,
                            //   child: Container(
                            //     width: a.width,
                            //     alignment: Alignment.center,
                            //     child: Row(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceBetween,
                            //       children: <Widget>[
                            //         InkWell(
                            //           child: Container(
                            //             width: a.width / 3.5,
                            //             height: a.width / 6.5,
                            //             decoration: BoxDecoration(
                            //                 color: Colors.white,
                            //                 borderRadius:
                            //                     BorderRadius.circular(a.width)),
                            //             alignment: Alignment.center,
                            //             child: Row(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.center,
                            //               children: <Widget>[
                            //                 Icon(
                            //                   Icons.arrow_downward,
                            //                   color: Color(0xff26A4FF),
                            //                 ),
                            //                 Text("เก็บไว้",
                            //                     style: TextStyle(
                            //                         fontSize: a.width / 15,
                            //                         color: Color(0xff26A4FF))),
                            //               ],
                            //             ),
                            //           ),
                            //           onTap: () async {
                            //             Navigator.pop(context);
                            //             await pickScrap(
                            //                 id, text, '$time $date', writer);
                            //           },
                            //         ),
                            //         InkWell(
                            //           child: Container(
                            //             width: a.width / 3.5,
                            //             height: a.width / 6.5,
                            //             decoration: BoxDecoration(
                            //                 color: Colors.white,
                            //                 borderRadius:
                            //                     BorderRadius.circular(a.width)),
                            //             alignment: Alignment.center,
                            //             child: Row(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.center,
                            //               children: <Widget>[
                            //                 Icon(Icons.clear),
                            //                 Text(
                            //                   "ทิ้งไว้",
                            //                   style: TextStyle(
                            //                       fontSize: a.width / 15),
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //           onTap: () {
                            //             Navigator.pop(context);
                            //           },
                            //         ),
                            //         InkWell(
                            //           child: Container(
                            //             width: a.width / 3.5,
                            //             height: a.width / 6.5,
                            //             decoration: BoxDecoration(
                            //                 color: Colors.white,
                            //                 borderRadius:
                            //                     BorderRadius.circular(a.width)),
                            //             alignment: Alignment.center,
                            //             child: Row(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.center,
                            //               children: <Widget>[
                            //                 Icon(
                            //                   Icons.whatshot,
                            //                   color: Colors.red,
                            //                 ),
                            //                 Text(
                            //                   "เผา",
                            //                   style: TextStyle(
                            //                     fontSize: a.width / 15,
                            //                     color: Colors.red,
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //           onTap: () {
                            //             Navigator.pop(context);
                            //           },
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // Positioned(
                            //     left: a.width / 16,
                            //     top: a.height / 6.6,
                            //     child: Container(
                            //       alignment: Alignment.center,
                            //       height: a.height / 3.2,
                            //       width: a.width / 1.3,
                            //       child: Text(
                            //         text,
                            //         textAlign: TextAlign.center,
                            //         style: TextStyle(fontSize: a.width / 14),
                            //       ),
                            //     )),
                            // writer == 'สุ่มโดย Scrap'
                            //     ? Positioned(
                            //         top: 12,
                            //         right: 12,
                            //         child: Row(
                            //           children: <Widget>[
                            //             FlatButton(
                            //                 child: Icon(Icons.whatshot),
                            //                 onPressed: () async {
                            //                   await burn(id);
                            //                   print(id);
                            //                   Navigator.pop(context);
                            //                   Taoast().toast('คุณได้เผากระดาษไปแล้ว');
                            //                 }),
                            //             Tooltip(
                            //               key: infoKey,
                            //               message: 'เผากระดาษ',
                            //               child: Icon(Icons.info_outline),
                            //             )
                            //           ],
                            //         ))
                            //     : SizedBox(),
                          ],
                        ),
                        SizedBox(height: a.width / 15),
                        Container(
                          width: a.width,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              writer != 'สุ่มโดย Scrap'
                                  ? SizedBox()
                                  : SizedBox(
                                      width: a.width / 12,
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.arrow_downward,
                                        color: Color(0xff26A4FF),
                                      ),
                                      Text("เก็บไว้",
                                          style: TextStyle(
                                              fontSize: a.width / 15,
                                              color: Color(0xff26A4FF))),
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  Navigator.pop(context);
                                  await pickScrap(
                                      id, text, '$time $date', writer);
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.clear),
                                      Text(
                                        "ทิ้งไว้",
                                        style:
                                            TextStyle(fontSize: a.width / 15),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              writer != 'สุ่มโดย Scrap'
                                  ? InkWell(
                                      child: Container(
                                        width: a.width / 3.5,
                                        height: a.width / 6.5,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(a.width)),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.whatshot,
                                              color: Colors.red,
                                            ),
                                            Text(
                                              "เผา",
                                              style: TextStyle(
                                                fontSize: a.width / 15,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () async {
                                        await burn(id);
                                        print(id);
                                        Navigator.pop(context);
                                        Taoast().toast('คุณได้เผากระดาษไปแล้ว');
                                      },
                                    )
                                  : SizedBox(
                                      width: a.width / 12,
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
    }));
  }

  burn(String scrapID) async {
    await Firestore.instance
        .collection('Scraps')
        .document('hatyai')
        .collection('scrapsPosition')
        .document(scrapID)
        .updateData({
      'burned': FieldValue.arrayUnion([widget.uid])
    });
  }

  pickScrap(String id, String text, String time, String writer) async {
    await Firestore.instance
        .collection('Users')
        .document(widget.uid)
        .collection('scraps')
        .document('collection')
        .setData({
      'id': FieldValue.arrayUnion([id]),
      'scraps': {
        id: FieldValue.arrayUnion([
          {'text': text, 'time': time, 'writer': writer}
        ])
      }
    }, merge: true);
  }

  @override
  dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    _createMarkerImageFromAsset(context);
    _createScrapImageFromAsset(context);
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.grey[900],
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
                          zoom: 18.5,
                          tilt: 90),
                      markers: Set<Marker>.of(markers.values),
                      circles: Set<Circle>.of(circles.values),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
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
    updateMap(currentLocation);
    Geolocator().getPositionStream().listen((location) {
      updateMap(location);
    });
  }

  loopRandomMarker(Position location) {
    for (int i = scpContent.length; i < 3; i++) {
      randomScrap(location);
    }
  }

  updateMap(Position location) {
    userMarker(location.latitude, location.longitude);
    _addCircle(100, location.latitude, location.longitude);
    _animateToUser(position: location);
    _startQuery(position: location);
  }

  randomScrap(Position location) {
    final random = Random();
    int con, type;
    Map randLocation = RandomLocation()
        .getLocation(lat: location.latitude, lng: location.longitude);
    Firestore.instance.collection('Contents').getDocuments().then((docs) {
      if (scpContent.length < 3) {
        type = random.nextInt(docs.documents.length);
        List randContens = docs.documents[type].data['Contents'];
        con = random.nextInt(randContens.length);
        String getContent = randContens[con];
        scpContent.add(getContent);
        randData[getContent] = {
          'text': getContent,
          'lat': randLocation['lat'],
          'lng': randLocation['lng'],
          'time': '$time  $date',
        };
        _addOfficial(
            getContent, time, date, randLocation['lat'], randLocation['lng']);
      }
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList, Position position) {
    markers.removeWhere((key, value) => !scpContent.contains(key.value));
    userMarker(position.latitude, position.longitude);
    documentList.forEach((DocumentSnapshot document) {
      var data = document.data;
      List read = data['read'] ?? [];
      GeoPoint loca = data['position']['geopoint'];
      if (markers.length < 8) {
        if (widget.collection.contains(data['id']) ||
            data['uid'] == widget.uid ||
            picked.contains(data['id']) ||
            read.contains(widget.uid)) {
        } else {
          _addMarker(
              data['id'],
              data['uid'],
              data['scrap']['user'],
              data['scrap']['text'],
              data['scrap']['timeStamp'],
              loca.latitude,
              loca.longitude);
        }
      } else {
        subscription.pause();
      }
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
          zoom: 18.5,
          tilt: 90.0,
        )));
  }

  queryManagement() {
    if (subscription?.isPaused != null) {
      subscription.isPaused && markers.length < 8
          ? subscription.resume()
          : subscription.pause();
    }
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
    }).listen((list) async {
      _updateMarkers(list, position ?? pos);
    });
  }

  cameraAnime(GoogleMapController controller, double lat, double lng) {
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, lng), zoom: 18.5, bearing: 0.0, tilt: 90)));
  }

  void _addOfficial(
      String text, String time, String date, double lat, double lng) {
    final MarkerId officialId = MarkerId(text);
    final Marker marker = Marker(
      markerId: officialId,
      position: LatLng(lat, lng),
      icon: scrapIcon,
      onTap: () {
        try {
          markers.remove(officialId);
          picked.add(text);
          scpContent.remove(text);
          setState(() {});
          dialog(text, 'สุ่มโดย Scrap', time, date, text);
        } catch (e) {
          print(e.toString());
          error(context,
              'เกิดข้อผิดพลาด ไม่ทราบสาเหตุกรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต');
        }
      },
    );
    setState(() {
      markers[officialId] = marker;
    });
  }

  void _addMarker(String id, String user, String writer, String text,
      Timestamp time, double lat, double lng) {
    id == null ? ++i : null;
    DateTime convTime = time.toDate();
    final MarkerId markerId = MarkerId(id ?? i.toString());
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      icon: scrapIcon,
      onTap: () async {
        try {
          markers.remove(markerId);
          picked.add(id);
          setState(() {});
          dialog(text, writer, '${convTime.hour}:${convTime.minute}',
              '${convTime.day}/${convTime.month}/${convTime.year}', id);
          addRead(id);
          scrap.increaseTransaction(user, 'read');
          increasHistTran(
              user, '${convTime.year},${convTime.month},${convTime.day}', id);
        } catch (e) {
          print(e.toString());
          error(context,
              'เกิดข้อผิดพลาด ไม่ทราบสาเหตุกรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต');
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

  addRead(String scrapID) async {
    Firestore.instance
        .collection('Scraps')
        .document('hatyai')
        .collection('scrapsPosition')
        .document(scrapID)
        .updateData({
      'read': FieldValue.arrayUnion([widget.uid])
    });
  }

  increasHistTran(String uid, String date, String docID) {
    Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('history')
        .document(date)
        .updateData({docID: FieldValue.increment(1)});
  }
}
