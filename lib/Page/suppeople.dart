import 'dart:async';

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
import 'package:scrap/provider/WriteScrapProvider.dart';
import 'package:scrap/widget/LoadNoBlur.dart';
import 'package:scrap/widget/PersonCard.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/Page/allfollower.dart';

class Subpeople extends StatefulWidget {
  final String searchText;
  final bool hasAppbar;
  Subpeople({@required this.searchText, this.hasAppbar = true});
  @override
  _SubpeopleState createState() => _SubpeopleState();
}

class _SubpeopleState extends State<Subpeople>
    with AutomaticKeepAliveClientMixin {
  List following = [], recently = [];
  bool loading = true;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    initFollows();
    super.initState();
  }

  Future<void> initFollows() async {
    if (await cacheFriends.exist()) {
      recently = await cacheFriends.getRecently() ?? [];
      following = await cacheFriends.getRandomFollowing() ?? [];
    }
    if (this.mounted) setState(() => loading = false);
  }

  Stream<Event> streamTransaction(String field) {
    final user = Provider.of<UserData>(context, listen: false);
    var userDb = dbRef.userTransact;
    return userDb.child('users/${user.uid}/follows/$field').onValue;
  }

  bool subindex = true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: widget.hasAppbar ? screenWidthDp / 4.2 : 0),
                  Expanded(
                      child: loading
                          ? Center(
                              child: Container(
                                width: screenWidthDp / 3.6,
                                height: screenWidthDp / 3.6,
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
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidthDp / 72),
                              child: widget.searchText != null &&
                                      widget.searchText.length > 0
                                  ? serachResult()
                                  : recently.length < 1 && following.length < 1
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
                                        ),
                            ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget selectbutton(String text) {
    Size a = MediaQuery.of(context).size;
    return Container(
      height: a.width / 8 / 1.2,
      width: screenWidthDp / 2.5,
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xfff26A4FF)),
          borderRadius: BorderRadius.circular(5),
          color: subindex == true ? Colors.black : Color(0xfff26A4FF)),
      child: Text(
        text,
        style: TextStyle(fontSize: s60, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget recentlyThrow() {
    screenutilInit(context);
    return Container(
        width: screenWidthDp,
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xff292929)))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          SizedBox(height: screenWidthDp / 24),
          Container(
            padding: EdgeInsets.only(left: screenWidthDp / 25),
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
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Container(
            width: screenWidthDp,
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
                      .where('id', isGreaterThanOrEqualTo: widget.searchText)
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
    final scrapData = Provider.of<WriteScrapProvider>(context, listen: false);
    return GestureDetector(
        child: PersonCard(
            data: doc.data,
            uid: doc.documentID,
            ref: doc.reference.parent().path),
        onTap: () async {
          if (scrapData.text == null) {
            bool resault = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OtherProfile(
                        data: doc.data,
                        uid: doc.documentID,
                        ref: doc.reference.parent().path)));
            if (resault) initFollows();
          }
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
