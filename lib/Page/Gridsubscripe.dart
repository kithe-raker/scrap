import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrap/Page/GridFollowing.dart';
import 'package:scrap/Page/GridTopScrap.dart';
import 'package:scrap/Page/profile/OptionSetting_My_Profile.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/FriendsCache.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/footer.dart';

class Gridsubscripe extends StatefulWidget {
  @override
  _GridsubscripeState createState() => _GridsubscripeState();
}

PublishSubject<bool> loadMoreTopScrap = PublishSubject();
PublishSubject<bool> loadMoreFollowingScrap = PublishSubject();

class _GridsubscripeState extends State<Gridsubscripe> {
  int page = 0;
  var controller = PageController();
  var followingController = RefreshController();
  var topController = RefreshController();
  StreamSubscription loadStatus, loadFollowStatus;
  bool loading = true;

  //top scrap
  List scraps = [], feedScrap = [];
  Map<String, int> comments = {};
  Map<String, int> commentsFollower = {};
  dynamic lessPoint;
  bool lastQuery = false;

  //following
  List<DocumentSnapshot> followingScraps = [];
  List friends = [];

  @override
  void initState() {
    initScraps();
    loadStatus =
        loadMoreTopScrap.listen((value) => value ? loadMoreScrap() : null);
    loadFollowStatus = loadMoreFollowingScrap
        .listen((value) => value ? loadMoreFollowScrap() : null);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    followingController.dispose();
    topController.dispose();
    loadStatus.cancel();
    loadFollowStatus.cancel();
    super.dispose();
  }

  Future<void> initScraps() async {
    List<String> docId = [];
    var ref = FirebaseDatabase.instance
        .reference()
        .child('scraps')
        .orderByChild('point')
        .limitToFirst(8);
    DataSnapshot data = await ref.once();
    if (data.value?.length != null && data.value.length > 0) {
      data.value.forEach((key, value) {
        docId.add(value['id']);
        comments[value['id']] = value['comment']?.abs() ?? 0;
        if (lessPoint == null)
          lessPoint = value['point'].abs();
        else if (lessPoint > value['point'].abs())
          lessPoint = value['point'].abs();
      });
      var docs = await fireStore
          .collectionGroup('ScrapDailys-th')
          .where('id', whereIn: docId)
          .getDocuments();
      feedScrap.addAll(docs.documents);
      scraps.addAll(docs.documents);
    }
    friends = await cacheFriends.getFollowing();
    if (friends.length > 0) {
      var followDocs = await Firestore.instance
          .collectionGroup('scrapCollection')
          .where('picker', whereIn: friends)
          .orderBy('timeStamp', descending: true)
          .limit(8)
          .getDocuments();
      followingScraps.addAll(followDocs.documents);
      if (followDocs.documents.length > 0) {
        followingScraps.forEach((doc) async {
          var ref = await FirebaseDatabase.instance
              .reference()
              .child('scraps/${doc.documentID}/comment')
              .once();
          commentsFollower[doc.documentID] = ref.value;
        });
      }
    }
    scraps.add(lessPoint);
    setState(() => loading = false);
  }

  loadMoreScrap() async {
    List<String> docId = [];
    var ref = FirebaseDatabase.instance
        .reference()
        .child('scraps')
        .orderByChild('point')
        .startAt(-(lessPoint - 1))
        .limitToFirst(8);
    DataSnapshot data = await ref.once();
    if (data.value?.length != null && data.value.length > 0) {
      data.value.forEach((key, value) {
        docId.add(value['id']);
        comments[value['id']] = value['comment']?.abs() ?? 0;
        if (lessPoint > value['point'].abs()) lessPoint = value['point'].abs();
      });
    }
    if (docId.length > 1 && !lastQuery) {
      var docs = await Firestore.instance
          .collectionGroup('ScrapDailys-th')
          .where('id', whereIn: docId)
          .getDocuments();
      feedScrap.addAll(docs.documents);
      scraps.addAll(docs.documents);
      docs.documents.length < 8 ? lastQuery = true : scraps.add(lessPoint);
      setState(() => topController.loadComplete());
    } else {
      topController.loadNoData();
    }
    loadMoreTopScrap.add(false);
  }

//following scrap query function
  loadMoreFollowScrap() async {
    var docs = await Firestore.instance
        .collectionGroup('scrapCollection')
        .where('picker', whereIn: friends)
        .orderBy('timeStamp', descending: true)
        .startAfterDocument(followingScraps.last)
        .limit(8)
        .getDocuments();
    followingScraps.addAll(docs.documents);
    if (docs.documents.length > 0) {
      followingScraps.forEach((doc) async {
        var ref = await FirebaseDatabase.instance
            .reference()
            .child('scraps/${doc.documentID}/comment')
            .once();
        commentsFollower[doc.documentID] = ref.value;
      });
    }
    docs.documents.length < 0
        ? setState(() => followingController.loadComplete())
        : followingController.loadNoData();
    loadMoreFollowingScrap.add(false);
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: appBarHeight / 1.42,
              width: screenWidthDp,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidthDp / 21,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      child: Container(
                          width: a.width / 18,
                          child: Image.asset("assets/Group 74.png",
                              fit: BoxFit.contain)),
                      onTap: () {
                        Navigator.pop(context);
                      }),
                  Row(
                    children: [
                      GestureDetector(
                        child: Text(
                          "สแครปน่าติดตาม",
                          style: page != 0
                              ? TextStyle(
                                  color: Colors.white, fontSize: a.width / 20)
                              : TextStyle(
                                  color: Colors.white,
                                  fontSize: a.width / 20,
                                  fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          if (controller.page != 0)
                            controller.previousPage(
                                duration: Duration(milliseconds: 120),
                                curve: Curves.ease);
                        },
                      ),
                      Text(
                        " | ",
                        style: TextStyle(
                            color: Colors.white, fontSize: a.width / 20),
                      ),
                      GestureDetector(
                          child: Text(
                            "จากผู้คนที่ติดตาม",
                            style: page != 1
                                ? TextStyle(
                                    color: Colors.white, fontSize: a.width / 20)
                                : TextStyle(
                                    color: Colors.white,
                                    fontSize: a.width / 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                          ),
                          onTap: () {
                            if (controller.page != 1)
                              controller.nextPage(
                                  duration: Duration(milliseconds: 120),
                                  curve: Curves.ease);
                          })
                    ],
                  ),
                  GestureDetector(
                      child: Icon(Icons.history,
                          color: Colors.white, size: a.width / 13),
                      onTap: () {
                        nav.push(context, HistoryScrap());
                      })
                ],
              ),
            ),
            Container(
                width: a.width,
                height: a.height,
                padding: EdgeInsets.only(top: appBarHeight / 1.35),
                child: PageView(
                  onPageChanged: (index) {
                    setState(() => page = index);
                  },
                  controller: controller,
                  children: <Widget>[
                    SmartRefresher(
                        footer: Footer(),
                        controller: topController,
                        enablePullDown: false,
                        enablePullUp: true,
                        onLoading: () {
                          loadMoreScrap();
                        },
                        child: GridTopScrap(
                            scraps: scraps,
                            feedScrap: feedScrap,
                            comments: comments)),
                    SmartRefresher(
                        footer: Footer(),
                        enablePullDown: false,
                        enablePullUp: true,
                        onLoading: () {
                          followingScraps.length > 0
                              ? loadMoreFollowScrap()
                              : followingController.loadNoData();
                        },
                        controller: followingController,
                        child: GridFollowing(
                            scraps: followingScraps,
                            comment: commentsFollower)),
                  ],
                )),
            loading ? Loading() : SizedBox()
          ],
        ),
      ),
    );
  }
}
