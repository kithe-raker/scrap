import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import 'package:scrap/function/randomLocation.dart';
import 'package:scrap/function/scrapFilter.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/widget/Toast.dart';

class MapScraps extends StatefulWidget {
  final String uid;
  MapScraps({@required this.uid});
  @override
  _MapScrapsState createState() => _MapScrapsState();
}

class _MapScrapsState extends State<MapScraps> {
  final random = Random();
  final geoLocator = Geolocator();
  Position currentLocation;
  StreamSubscription subLimit;
  int i = 0;
  String date, time;
  PublishSubject<int> streamLimit = PublishSubject();
  DocumentSnapshot recentScrap;
  bool loadMap = false;
  BitmapDescriptor _curcon, scrapIcon;
  bool checkPlatform = Platform.isIOS;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<CircleId, Circle> circles = <CircleId, Circle>{};
  GoogleMapController mapController;
  DateTime now = DateTime.now();
  Set scpContent = {};
  Map randData = {};
  Scraps scrap = Scraps();
  final infoKey = GlobalKey();
  ScrapFilter filter = ScrapFilter();
  StreamSubscription streamLocation;

  @override
  void initState() {
    if (this.mounted) {
      time = DateFormat('Hm').format(now);
      date = DateFormat('d/M/y').format(now);
      streamLocation = geoLocator
          .getPositionStream()
          .listen((event) => setState(() => currentLocation = event));
      loadMap = true;
      super.initState();
    }
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
  void dialog(String text, String writer, String time, String id) {
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                      Text('เวลา : $time',
                                          style:
                                              TextStyle(fontSize: a.width / 25))
                                    ],
                                  ),
                                )),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 25, right: 25),
                              height: a.height / 1.6,
                              width: a.width,
                              child: Text(
                                filter.censorString(text),
                                style: TextStyle(
                                  height: 1.35,
                                  fontSize: a.width / 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: a.width / 15),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(a.width)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              writer != 'สุ่มโดย Scrap'
                                  ? InkWell(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            right: a.width / 42),
                                        width: a.width / 6,
                                        height: a.width / 6,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.whatshot,
                                                color: Colors.grey[600],
                                                size: a.width / 14,
                                              ),
                                              Text(
                                                "เผา",
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: a.width / 25),
                                              )
                                            ]),
                                      ),
                                      onTap: () async {
                                        await burn(id);
                                        Navigator.pop(context);
                                        Taoast().toast('คุณได้เผากระดาษไปแล้ว');
                                      },
                                    )
                                  : SizedBox(),
                              InkWell(
                                child: Container(
                                  margin: EdgeInsets.only(right: a.width / 40),
                                  width: a.width / 6,
                                  height: a.width / 6,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset('assets/garbage_grey.png',
                                            width: a.width / 14,
                                            height: a.width / 14,
                                            fit: BoxFit.cover),
                                        Text(
                                          "ทิ้งไว้",
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: a.width / 25),
                                        )
                                      ]),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              InkWell(
                                child: Container(
                                  width: a.width / 6,
                                  height: a.width / 6,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.save_alt,
                                          color: Colors.grey[600],
                                          size: a.width / 14,
                                        ),
                                        Text(
                                          "เก็บไว้",
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: a.width / 25),
                                        )
                                      ]),
                                ),
                                onTap: () async {
                                  Navigator.pop(context);
                                  await pickScrap(
                                      id, text, '$time $date', writer);
                                },
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
    subLimit.cancel();
    streamLocation.cancel();
    super.dispose();
  }

  double zoom;

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    _createMarkerImageFromAsset(context);
    _createScrapImageFromAsset(context);
    return currentLocation == null
        ? gpsCheck(a, 'กรุณาตรวจสอบ GPS ของคุณ')
        : Scaffold(
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
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
                //  Positioned(left: -56, bottom: a.height / 3.6, child: slider())
              ],
            ));
  }

  Widget gpsCheck(Size a, String text) {
    return Center(
      child: Container(
        width: a.width / 1.2,
        height: a.width / 3.2,
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                width: a.width / 3.2,
                height: a.width / 3.2,
                child: FlareActor(
                  'assets/paper_loading.flr',
                  animation: 'Untitled',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  text,
                  style: TextStyle(fontSize: a.width / 16, color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }

  cameraAnime2(GoogleMapController controller, double howClose) {
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            currentLocation?.latitude ?? 0, currentLocation?.longitude ?? 0),
        zoom: howClose,
        bearing: 0.0,
        tilt: 90)));
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
    if (this.mounted) {
      updateMap(currentLocation);
      subLimit = streamLimit.listen((value) {
        if (value > 0) addMoreScrap(value);
      });
      addMoreScrap(7);
    }
    streamLocation.onData((position) {
      if (this.mounted) {
        updateMap(position);
      }
    });
  }

  loopRandomMarker(GeoPoint location) {
    for (int i = scpContent.length; i < 3; i++) {
      randomScrap(location);
    }
  }

  updateMap(Position location) {
    userMarker(location.latitude, location.longitude);
    _animateToUser(position: location);
  }

  randomScrap(GeoPoint location) {
    Map randLocation = RandomLocation()
        .getLocation(lat: location.latitude, lng: location.longitude);

    if (scpContent.length < 3) {
      _addOfficial(randLocation);
    }
  }

  void _updateMarkers(List<DocumentSnapshot> documentList, Position position) {
    userMarker(position.latitude, position.longitude);
    documentList.forEach((DocumentSnapshot document) {
      var data = document.data;
      GeoPoint loca = data['position']['geopoint'];

      if (data['uid'] != widget.uid) {
        _addMarker(
            data['id'],
            data['uid'],
            data['scrap']['user'],
            data['scrap']['text'],
            data['scrap']['time'],
            // data['scrap']['timeStamp'],
            loca.latitude,
            loca.longitude);
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
          zoom: 16.9,
          tilt: 90.0,
        )));
  }

  addMoreScrap(int limit) async {
    var pos = await Geolocator().getCurrentPosition();
    var ref = recentScrap == null
        ? Firestore.instance
            .collection('Scraps/hatyai/test')
            .orderBy('scrap.time', descending: true)
            .limit(limit)
        : Firestore.instance
            .collection('Scraps/hatyai/test')
            .orderBy('scrap.time', descending: true)
            .startAfterDocument(recentScrap)
            .limit(limit);
    var doc = await ref.getDocuments();
    _updateMarkers(doc.documents, pos);
    if (doc.documents.length > 0) {
      recentScrap = doc.documents.last;
      var randIndex = random.nextInt(doc.documents.length);
      loopRandomMarker(doc.documents[randIndex]['position']['geopoint']);
    }
  }

  cameraAnime(GoogleMapController controller, double lat, double lng) {
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, lng), zoom: 18.5, bearing: 0.0, tilt: 90)));
  }

  void _addOfficial(Map randomLocation) {
    var id = DateTime.now().millisecondsSinceEpoch;
    final MarkerId officialId = MarkerId(id.toString());
    scpContent.add(id.toString());
    final Marker marker = Marker(
      markerId: officialId,
      position: LatLng(randomLocation['lat'], randomLocation['lng']),
      icon: scrapIcon,
      onTap: () {
        try {
          markers.remove(officialId);
          scpContent.remove(id);
          setState(() {});
          // dialog(text, 'สุ่มโดย Scrap', time, date, text);
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
          setState(() {});
          dialog(text, writer, DateFormat('HH:mm d/M/y').format(convTime), id);
          // addRead(id);
          // scrap.increaseTransaction(user, 'read');
          // increasHistTran(
          //     user, '${convTime.year},${convTime.month},${convTime.day}', id);
          streamLimit.add(7 - markers.length + 3);
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
    if (this.mounted) {
      setState(() {
        markers[markerId] = marker;
      });
    }
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_curcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/yourlocation-icon-l.png')
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
