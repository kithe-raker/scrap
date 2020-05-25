import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/FriendsCache.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/personcard.dart';

class Allfollower extends StatefulWidget {
  @override
  _AllfollowerState createState() => _AllfollowerState();
}

class _AllfollowerState extends State<Allfollower> {
  var controller = RefreshController();
  List friendsUid = [];
  List<DocumentSnapshot> friends = [];
  bool loading = true;

  @override
  void initState() {
    initFriends();
    super.initState();
  }

  initFriends() async {
    friendsUid = await cacheFriends.getFollowing();
    var queryList = friendsUid.take(12).toList();
    var docs = await fireStore
        .collectionGroup('users')
        .where('uid', whereIn: queryList)
        .getDocuments();
    friends.addAll(docs.documents);
    friendsUid.length < 12 ? friendsUid.clear() : friendsUid.removeRange(0, 12);
    setState(() => loading = false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          width: screenWidthDp,
          height: screenHeightDp,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: screenHeightDp / 64),
                  appbar(),
                  loading
                      ? Expanded(
                          child: Center(
                              child: Container(
                                  width: screenWidthDp / 3.6,
                                  height: screenWidthDp / 3.6,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.42),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: FlareActor('assets/paper_loading.flr',
                                      animation: 'Untitled',
                                      fit: BoxFit.cover))),
                        )
                      : Expanded(
                          child: StatefulBuilder(
                              builder: (context, StateSetter setList) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidthDp / 36),
                              child: SmartRefresher(
                                enablePullDown: false,
                                controller: controller,
                                onLoading: () async {
                                  var queryList = friendsUid.take(12).toList();
                                  var docs = await fireStore
                                      .collectionGroup('users')
                                      .where('uid', whereIn: queryList)
                                      .getDocuments();
                                  friends.addAll(docs.documents);
                                  friendsUid.length < 12
                                      ? friendsUid.clear()
                                      : friendsUid.removeRange(0, 12);
                                  setList(() {});
                                  controller.loadComplete();
                                },
                                physics: BouncingScrollPhysics(),
                                child: Column(
                                    children: friends
                                        .map((doc) => PersonCard(
                                              data: doc.data,
                                              uid: doc.documentID,
                                              ref: doc.reference.toString(),
                                            ))
                                        .toList()),
                              ),
                            );
                          }),
                        ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget appbar() {
    Size a = MediaQuery.of(context).size;
    return Container(
      width: a.width,
      height: a.width / 5.4,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          Text(
            'ผู้ติดตาม',
            style: TextStyle(
                color: Colors.white,
                fontSize: a.width / 18,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(width: a.width / 7.5),
        ],
      ),
    );
  }
}
