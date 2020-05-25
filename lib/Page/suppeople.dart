import 'dart:async';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/FriendsCache.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/personcard.dart';
import 'package:scrap/Page/allfollower.dart';
import 'package:stream_transform/stream_transform.dart';

class Subpeople extends StatefulWidget {
  @override
  _SubpeopleState createState() => _SubpeopleState();
}

class _SubpeopleState extends State<Subpeople> {
  List following = [], recently = [];
  bool loading = true, searching = false;
  String search;
  var focus = FocusNode();
  StreamController<String> streamController = StreamController();

  @override
  void initState() {
    initFollows();
    super.initState();
  }

  Future<void> initFollows() async {
    if (await cacheFriends.exist()) {
      recently = await cacheFriends.getRecently();
      following = await cacheFriends.getRandomFollowing();
    }
    setState(() => loading = false);
  }

  Stream<Event> streamTransaction(String field) {
    final user = Provider.of<UserData>(context, listen: false);
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var userDb = FirebaseDatabase(app: db.userTransact);
    return userDb.reference().child('users/${user.uid}/follows/$field').onValue;
  }

  @override
  void dispose() {
    focus.dispose();
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          width: a.width,
          height: a.height,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: screenHeightDp / 3.4,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Color(0xff262626)))),
                    padding: EdgeInsets.only(
                        left: a.width / 50, right: a.width / 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            width: a.width,
                            height: screenHeightDp / 12.4,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    child: Icon(Icons.arrow_back,
                                        color: Colors.white,
                                        size: a.width / 15),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  // followerButton(),
                                ])),
                        Text(
                          searching ? "\tติดตามผู้คน" : "\tค้นหาผู้คน",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: s54,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "\tค้นหาผู้คนเพื่ออ่านสแครปหรือปาสแครปหาพวกเขา",
                          style: TextStyle(
                              height: 1.2, color: Colors.white, fontSize: s42),
                        ),
                        SizedBox(height: a.width / 30),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: a.width / 8,
                                padding: EdgeInsets.only(
                                    left: a.width / 100,
                                    top: a.width / 500,
                                    bottom: 0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  color: Color(0xff262626),
                                ),
                                child: TextField(
                                  focusNode: focus,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: a.width / 18),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    // fillColor: Colors.red,
                                    hintText: '@someone',
                                    hintStyle: TextStyle(
                                        fontSize: a.width / 18,
                                        color: Colors.grey[600],
                                        height: a.width / 150),
                                  ),
                                  onTap: () {
                                    focus.requestFocus();
                                    setState(() => searching = true);
                                  },
                                  onChanged: (val) {
                                    streamController.add(val.trim());
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: a.width / 100),
                            searching
                                ? GestureDetector(
                                    child: Text(
                                      '\t\tยกเลิก\t',
                                      style: TextStyle(
                                          fontSize: a.width / 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    onTap: () {
                                      focus.unfocus();
                                      setState(() => searching = false);
                                    },
                                  )
                                : SizedBox()
                          ],
                        )
                      ],
                    ),
                  ),
                  StatefulBuilder(builder: (context, StateSetter setSearch) {
                    if (!streamController.hasListener)
                      streamController.stream
                          .debounce(Duration(milliseconds: 540))
                          .listen((value) => setSearch(() => search = value));
                    return Expanded(
                        child: loading
                            ? Center(
                                child: Container(
                                  width: a.width / 3.6,
                                  height: a.width / 3.6,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.42),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: FlareActor(
                                    'assets/paper_loading.flr',
                                    animation: 'Untitled',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : !searching
                                ? recently.length < 1 && following.length < 1
                                    ? Center(
                                        child: guide('ไม่มีคนที่คุณติดตาม'))
                                    : ListView(
                                        physics: BouncingScrollPhysics(),
                                        children: <Widget>[
                                          recently.length > 0
                                              ? Container(
                                                  width: a.width,
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: Color(
                                                                  0xff292929)))),
                                                  padding: EdgeInsets.only(
                                                    left: a.width / 50,
                                                  ),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: a.width / 25,
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            "\tล่าสุดที่ปาใส่",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    a.width /
                                                                        15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: a.width / 20,
                                                        ),
                                                        Wrap(
                                                          children: <Widget>[
                                                            Personcard(),
                                                            Personcard(),
                                                            Personcard(),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                a.width / 30),
                                                      ]))
                                              : SizedBox(),
                                          following.length > 0
                                              ? Container(
                                                  width: a.width,
                                                  padding: EdgeInsets.only(
                                                      //top: a.width / 20,
                                                      left: a.width / 50,
                                                      right: a.width / 50),
                                                  child: Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: a.width / 45,
                                                      ),
                                                      Container(
                                                        width: a.width,
                                                        height: a.width / 10,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              "กำลังติดตาม " +
                                                                  "125",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      a.width /
                                                                          15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            GestureDetector(
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "ทั้งหมด",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            a.width /
                                                                                15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Icon(
                                                                      Icons
                                                                          .keyboard_arrow_right,
                                                                      color: Colors
                                                                          .white,
                                                                      size:
                                                                          a.width /
                                                                              15)
                                                                ],
                                                              ),
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              Allfollower()),
                                                                );
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: a.width / 20,
                                                      ),
                                                      Wrap(
                                                        children: <Widget>[
                                                          Personcard1(),
                                                          Personcard1(),
                                                          Personcard1(),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                          height: a.width / 7),
                                                    ],
                                                  ),
                                                )
                                              : SizedBox()
                                        ],
                                      )
                                : serachResult());
                  })
                ],
              ),
              Positioned(
                bottom: 0,
                child: AdmobBanner(
                    adUnitId: AdmobService().getBannerAdId(),
                    adSize: AdmobBannerSize.FULL_BANNER),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget serachResult() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        search == null || search == ''
            ? Padding(
                padding: EdgeInsets.only(top: screenWidthDp / 8.1),
                child: guide('ใส่ไอดีของคนที่ผู้คน'))
            : Container(
                width: screenWidthDp,
                padding: EdgeInsets.only(
                    left: screenWidthDp / 50, right: screenWidthDp / 50),
                child: Column(children: <Widget>[
                  SizedBox(
                    height: screenWidthDp / 25,
                  ),
                  Container(
                    width: screenWidthDp,
                    child: Row(
                      children: <Widget>[
                        Text(
                          "\tผู้คน",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidthDp / 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenWidthDp / 20),
                  FutureBuilder(
                      future: fireStore
                          .collectionGroup('users')
                          .where('id', isGreaterThanOrEqualTo: search)
                          .limit(6)
                          .getDocuments(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<DocumentSnapshot> docs = snapshot.data.documents;
                          return Column(
                              children: docs
                                  .map((doc) => Personcard1(data: doc.data))
                                  .toList());
                        } else {
                          return Column(
                            children: <Widget>[],
                          );
                        }
                      }),
                  SizedBox(height: screenWidthDp / 7),
                ]))
      ],
    );
  }

  Widget followerButton() {
    return StreamBuilder(
        stream: streamTransaction('followers'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var trans = snapshot.data.snapshot.value;
            return trans > 0
                ? Row(
                    children: <Widget>[
                      Text("$trans ผู้ติดตาม",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidthDp / 18,
                              fontWeight: FontWeight.bold)),
                      Icon(Icons.keyboard_arrow_right,
                          color: Colors.white, size: screenWidthDp / 15)
                    ],
                  )
                : SizedBox();
          } else {
            return SizedBox();
          }
        });
  }

  Widget guide(String text) {
    return Container(
      height: screenHeightDp / 2.5,
      width: screenWidthDp,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/paper.png',
              color: Colors.white60, height: screenHeightDp / 10),
          Text(
            text,
            style: TextStyle(
                fontSize: screenWidthDp / 16,
                color: Colors.white60,
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
