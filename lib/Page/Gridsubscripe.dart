import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrap/Page/GridFollowing.dart';
import 'package:scrap/Page/GridTopScrap.dart';
import 'package:scrap/Page/profile/OptionSetting_My_Profile.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/FriendsCache.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class Gridsubscripe extends StatefulWidget {
  @override
  _GridsubscripeState createState() => _GridsubscripeState();
}

class _GridsubscripeState extends State<Gridsubscripe> {
  int page = 0;
  var controller = PageController();
  var followingController = RefreshController();
  var topController = RefreshController();
  bool loading = true;

  //top scrap
  List scraps = [];
  Map<String, int> comments = {};
  int lessPoint;
  bool lastQuery = false;

  //following
  List<DocumentSnapshot> followingScraps = [];
  List friends = [];

  @override
  void initState() {
    initScraps();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    followingController.dispose();
    topController.dispose();
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
    friends = await cacheFriends.getFollowing();
    if (friends.length > 0) {
      var followDocs = await Firestore.instance
          .collectionGroup('scrapCollection')
          .where('picker', whereIn: friends)
          .orderBy('timeStamp', descending: true)
          .limit(8)
          .getDocuments();
      followingScraps.addAll(followDocs.documents);
    }
    scraps.addAll(docs.documents);
    scraps.add(lessPoint);
    setState(() => loading = false);
  }

  loadMoreScrap() async {
    List<String> docId = [];
    var ref = FirebaseDatabase.instance
        .reference()
        .child('scraps')
        .orderByChild('point')
        .startAt(-(++lessPoint))
        .limitToFirst(8);
    DataSnapshot data = await ref.once();
    data.value.forEach((key, value) {
      docId.add(value['id']);
      comments[value['id']] = value['comment']?.abs() ?? 0;
      if (lessPoint > value['point'].abs()) lessPoint = value['point'].abs();
    });
    if (docId.length > 1 && !lastQuery) {
      var docs = await Firestore.instance
          .collectionGroup('ScrapDailys-th')
          .where('id', whereIn: docId)
          .getDocuments();
      docs.documents.length < 8 ? lastQuery = true : scraps.add(lessPoint);
      scraps.addAll(docs.documents);
      setState(() => topController.loadComplete());
    } else {
      topController.loadNoData();
    }
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
    docs.documents.length < 0
        ? setState(() => followingController.loadComplete())
        : followingController.loadNoData();
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
                      InkWell(
                        child: Text(
                          "จากผู้คนที่ติดตาม",
                          style: page != 0
                              ? TextStyle(
                                  color: Colors.white, fontSize: a.width / 20)
                              : TextStyle(
                                  color: Colors.white,
                                  fontSize: a.width / 20,
                                  fontWeight: FontWeight.bold,
                                ),
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
                          "สแครปน่าติดตาม",
                          style: page != 1
                              ? TextStyle(
                                  color: Colors.white, fontSize: a.width / 20)
                              : TextStyle(
                                  color: Colors.white,
                                  fontSize: a.width / 20,
                                  fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          if (controller.page != 1)
                            controller.nextPage(
                                duration: Duration(milliseconds: 120),
                                curve: Curves.ease);
                        },
                      ),
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
                        enablePullDown: false,
                        enablePullUp: true,
                        onLoading: () {
                          followingScraps.length > 0
                              ? loadMoreFollowScrap()
                              : followingController.loadNoData();
                        },
                        controller: followingController,
                        child: GridFollowing(scraps: followingScraps)),
                    SmartRefresher(
                        controller: topController,
                        enablePullDown: false,
                        enablePullUp: true,
                        onLoading: () {
                          loadMoreScrap();
                        },
                        child: GridTopScrap(scraps: scraps, comments: comments))
                  ],
                )),
            loading ? Loading() : SizedBox()
          ],
        ),
      ),
    );
  }
}
