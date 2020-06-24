import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/bottomBarItem/Explore/FeedNearby.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/models/ScrapModel.dart';
import 'package:scrap/models/TopPlaceModel.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/stream/NearbyStream.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class ScrapNearby extends StatefulWidget {
  final TopPlaceModel place;
  ScrapNearby({@required this.place});
  @override
  _ScrapNearbyState createState() => _ScrapNearbyState();
}

class _ScrapNearbyState extends State<ScrapNearby> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<CircleId, Circle> circles = <CircleId, Circle>{};
  BitmapDescriptor scrapIcon, placeIcon;
  GoogleMapController mapController;
  StreamSubscription scrapStream;

  @override
  void dispose() {
    scrapStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _createScrapImageFromAsset(context);
    screenutilInit(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'สแครปบริเวณต่างๆ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: s48),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              GoogleMap(
                  onMapCreated: onMapCreated,
                  compassEnabled: false,
                  myLocationButtonEnabled: false,
                  markers: Set<Marker>.of(markers.values),
                  circles: Set<Circle>.of(circles.values),
                  initialCameraPosition: CameraPosition(
                      target: widget.place.location, zoom: 14.8)),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidthDp / 54,
                    vertical: screenWidthDp / 42),
                margin: EdgeInsets.symmetric(
                    horizontal: screenWidthDp / 32,
                    vertical: screenHeightDp / 46),
                decoration: BoxDecoration(
                    color: Color(0xff2E2E2E),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6.0,
                          spreadRadius: 3.0,
                          offset: Offset(0.0, 3.2))
                    ],
                    borderRadius: BorderRadius.circular(screenWidthDp / 72)),
                child: Stack(
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Hero(
                              tag: widget.place.id,
                              child: Container(
                                  padding: EdgeInsets.all(screenWidthDp / 64),
                                  decoration: BoxDecoration(
                                      color: Color(0xff357EED),
                                      borderRadius:
                                          BorderRadius.circular(screenWidthDp)),
                                  child: Icon(Icons.school,
                                      size: s58, color: Colors.black87)),
                            ),
                            SizedBox(width: screenWidthDp / 64),
                            Text(
                              widget.place.name,
                              style: TextStyle(
                                  fontSize: s52,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                          transactionBox(widget.place.id)
                        ]),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Stream placeTransaction(String placeId) {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var placeAll = FirebaseDatabase(app: db.placeAll);
    var ref = placeAll.reference().child('places/$placeId/allCount');
    var data = ref.onValue;
    return data;
  }

  Widget transactionBox(String placeId) {
    return StreamBuilder(
        stream: placeTransaction(placeId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data.snapshot?.value != null) {
            var trans = snapshot.data.snapshot?.value ?? 0;
            return trans < 0
                ? Container(
                    padding: EdgeInsets.only(
                        left: screenWidthDp / 64, right: screenWidthDp / 42),
                    decoration: BoxDecoration(
                        color: Color(0xff585858),
                        borderRadius:
                            BorderRadius.circular(screenWidthDp / 18)),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset('assets/paper.svg',
                            // color: Color(0xfff434343),
                            width: screenWidthDp / 14,
                            height: screenWidthDp / 14,
                            fit: BoxFit.contain),
                        Text(
                          trans.abs().toString(),
                          style:
                              TextStyle(fontSize: s42, color: Colors.white70),
                        )
                      ],
                    ),
                  )
                : SizedBox();
          } else
            return SizedBox();
        });
  }

  void onMapCreated(GoogleMapController googleMapController) {
    this.mapController = googleMapController;
    changeMapMode();
    placeMarker();
    addCircle();
    Future.delayed(Duration(milliseconds: 320), () {
      googleMapController.moveCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(widget.place.location.latitude,
                  widget.place.location.longitude),
              zoom: 14.8)));
    });
    scrapStream = nearby.nearbyStream
        .listen((scraps) => scraps.forEach((scrap) => addMarkers(scrap)));
  }

  placeMarker() {
    MarkerId markerId = MarkerId(widget.place.id);
    LatLng position = widget.place.location;
    Marker marker = Marker(
        markerId: markerId,
        position: position,
        icon: placeIcon,
        draggable: false);
    if (this.mounted) setState(() => markers[markerId] = marker);
  }

  addMarkers(ScrapModel scrap) {
    MarkerId markerId = MarkerId(scrap.scrapId);
    LatLng position = scrap.position;
    Marker marker = Marker(
        markerId: markerId,
        position: position,
        icon: scrapIcon,
        draggable: false,
        onTap: () {
          setState(() => markers.remove(markerId));
          nav.push(context,
              FeedNearby(place: widget.place, tapScrapId: scrap.scrapId));
        });
    if (this.mounted) setState(() => markers[markerId] = marker);
  }

  Future<void> _createScrapImageFromAsset(BuildContext context) async {
    final ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context);
    BitmapDescriptor.fromAssetImage(
            imageConfiguration, 'assets/paper-small.png')
        .then(_updateBitScrap);
    BitmapDescriptor.fromAssetImage(
            imageConfiguration, 'assets/locationmarker.png')
        .then(updateBitplace);
    // 'locationmarker.png'
  }

  void _updateBitScrap(BitmapDescriptor bitmap) {
    setState(() => scrapIcon = bitmap);
  }

  void updateBitplace(BitmapDescriptor bitmap) {
    setState(() => placeIcon = bitmap);
  }

  addCircle() {
    final CircleId circleId = CircleId('circle_id');
    final Circle circle = Circle(
        circleId: circleId,
        consumeTapEvents: true,
        strokeColor: Color(0xFFffffff)
            .withOpacity(0.64), //Color.fromRGBO(23, 23, 23, 0.4),
        fillColor: Color.fromRGBO(67, 78, 80, 0.1),
        strokeWidth: 3,
        center: widget.place.location,
        radius: 1000);
    setState(() => circles[circleId] = circle);
  }

  changeMapMode() {
    getJsonFile("assets/mapStyle.json").then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    this.mapController.setMapStyle(mapStyle);
  }
}
