import 'dart:async';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/profile/Other_Profile.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/FriendsCache.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/widget/LoadNoBlur.dart';
import 'package:scrap/widget/PersonCard.dart';
import 'package:scrap/widget/ScreenUtil.dart';
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
  final TextEditingController _controller = new TextEditingController();
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: a.width,
          height: a.height,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: appBarHeight / 1.42,
                    width: screenWidthDp,
                    color: Colors.black,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidthDp / 21,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                            child: Icon(Icons.arrow_back,
                                color: Colors.white, size: s60),
                            onTap: () {
                              Navigator.pop(context);
                            }),
                        SizedBox(),
                        SizedBox()
                      ],
                    ),
                  ),
                  Container(
                    height: screenWidthDp / 2.7,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Color(0xff262626)))),
                    padding: EdgeInsets.only(
                        left: a.width / 50, right: a.width / 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: a.width / 25),
                          child: Text(
                            searching ? "ค้นหาผู้คน" : "ค้นหาผู้คน",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: s54,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: a.width / 25),
                          child: Text(
                            "ค้นหาผู้คนเพื่ออ่านสแครปหรือปาสแครปหาพวกเขา",
                            style: TextStyle(
                                height: 1.2,
                                color: Colors.white,
                                fontSize: s42),
                          ),
                        ),
                        SizedBox(height: a.width / 30),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: a.width / 8,
                                margin: EdgeInsets.only(
                                    left: a.width / 25, right: a.width / 25),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  color: Color(0xff262626),
                                ),
                                child: TextField(
                                  controller: _controller,
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
                                      height: a.width / 315,
                                      //height: screenWidthDp / 320,
                                      // height: appBarHeight / 65,
                                      fontSize: a.width / 18,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  onTap: () {
                                    focus.requestFocus();
                                    setState(() => searching = true);
                                  },
                                  onChanged: (val) {
                                    var trim = val.trim();
                                    trim[0] == '@'
                                        ? streamController
                                            .add(trim.substring(1))
                                        : streamController.add(trim);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: a.width / 100),
                            searching
                                ? Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Text(
                                          'ยกเลิก',
                                          style: TextStyle(
                                              fontSize: a.width / 18,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white),
                                        ),
                                        onTap: () {
                                          focus.unfocus();
                                          _controller.clear();
                                          setState(() => searching = false);
                                        },
                                      ),
                                      SizedBox(width: a.width / 100),
                                    ],
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
                                    'assets/loadingpaper.flr',
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
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        children: <Widget>[
                                          recently.length > 0
                                              ? recentlyThrow()
                                              : SizedBox(),
                                          following.length > 0
                                              ? followingList()
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

  Widget recentlyThrow() {
    Size a = MediaQuery.of(context).size;
    screenutilInit(context);
    return Container(
        width: screenWidthDp,
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xff292929)))),
        padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 50),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          SizedBox(height: screenWidthDp / 24),
          Container(
            padding: EdgeInsets.only(left: a.width / 25),
            child: Text("ล่าสุดที่ปาใส่",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: s48,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: screenWidthDp / 20),
          Column(
              children: recently
                  .map((user) => PersonCard(data: user, enableNavigator: true))
                  .toList()),
          SizedBox(height: screenWidthDp / 30),
        ]));
  }

  Widget followingList() {
    return Container(
      width: screenWidthDp,
      padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 50),
      child: Column(
        children: <Widget>[
          SizedBox(height: screenWidthDp / 24),
          Container(
              width: screenWidthDp,
              height: screenWidthDp / 10,
              child: allFollowingButton()),
          SizedBox(height: screenWidthDp / 20),
          FutureBuilder(
              future: fireStore
                  .collectionGroup('users')
                  .where('uid', whereIn: following)
                  .limit(3)
                  .getDocuments(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> docs = snapshot.data.documents;
                  return Column(
                      children: docs.map((doc) => userCard(doc)).toList());
                } else {
                  return Center(
                    child: LoadNoBlur(),
                  );
                }
              }),
          SizedBox(height: screenWidthDp / 7),
        ],
      ),
    );
  }

  Widget allFollowingButton() {
    Size a = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: streamTransaction('following'),
        builder: (context, snapshot) {
          return Container(
            padding: EdgeInsets.only(left: a.width / 25, right: a.width / 25),
            child: Column(
              children: <Widget>[
                // SizedBox(height: screenWidthDp / 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      snapshot?.data == null
                          ? "กำลังติดตาม 0"
                          : 'กำลังติดตาม ${snapshot.data.snapshot?.value ?? 0}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: s48,
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                        child: Row(
                          children: <Widget>[
                            Text(
                              "ทั้งหมด",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: s48,
                                  fontWeight: FontWeight.normal),
                            ),
                            Icon(Icons.keyboard_arrow_right,
                                color: Colors.white, size: screenWidthDp / 15)
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Allfollowing()));
                        })
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget serachResult() {
    final user = Provider.of<UserData>(context, listen: false);
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
                              fontSize: screenWidthDp / 18,
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
                          return docs.length > 0
                              ? Column(
                                  children: docs
                                      .map((doc) => doc['img'] != null
                                          // &&doc.documentID != user.uid
                                          ? userCard(doc)
                                          : SizedBox())
                                      .toList())
                              : guide('ไม่พบไอดีดังกล่าวในระบบ');
                        } else {
                          return Center(child: LoadNoBlur());
                        }
                      }),
                  SizedBox(height: screenWidthDp / 7),
                ]))
      ],
    );
  }

  Widget userCard(DocumentSnapshot doc) {
    return GestureDetector(
        child: PersonCard(
            data: doc.data,
            uid: doc.documentID,
            ref: doc.reference.parent().path),
        onTap: () async {
          bool resault = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OtherProfile(
                      data: doc.data,
                      uid: doc.documentID,
                      ref: doc.reference.parent().path)));
          if (resault) initFollows();
        });
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
          SvgPicture.asset('assets/paper.svg',
              color: Colors.white60,
              height: screenWidthDp / 3.5,
              fit: BoxFit.contain),
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
