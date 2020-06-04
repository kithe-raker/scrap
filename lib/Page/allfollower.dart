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
    if (friendsUid.length > 0) {
      var queryList = friendsUid.take(12).toList();
      var docs = await fireStore
          .collectionGroup('users')
          .where('uid', whereIn: queryList)
          .getDocuments();
      friends.addAll(docs.documents);
      friendsUid.length < 12
          ? friendsUid.clear()
          : friendsUid.removeRange(0, 12);
    }
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
    Size a = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            width: screenWidthDp,
            height: screenHeightDp,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    // appbar(),
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
                          Text(
                            'ผู้ติดตาม',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: a.width / 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: screenWidthDp / 14,
                          )
                        ],
                      ),
                    ),
                    loading
                        ? Expanded(
                            child: Center(
                                child: Container(
                                    width: screenWidthDp / 3.6,
                                    height: screenWidthDp / 3.6,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.42),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: FlareActor('assets/scrapld.flr',
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
                                    var queryList =
                                        friendsUid.take(12).toList();
                                    if (queryList.length > 0) {
                                      var docs = await fireStore
                                          .collectionGroup('users')
                                          .where('uid', whereIn: queryList)
                                          .getDocuments();
                                      friends.addAll(docs.documents);
                                      friendsUid.length < 12
                                          ? friendsUid.clear()
                                          : friendsUid.removeRange(0, 12);
                                      setList(() {});
                                      docs.documents.length > 0
                                          ? controller.loadComplete()
                                          : controller.loadNoData();
                                    } else {
                                      controller.loadNoData();
                                    }
                                  },
                                  physics: BouncingScrollPhysics(),
                                  child: Column(
                                      children: friends
                                          .map((doc) => PersonCard(
                                              data: doc.data,
                                              uid: doc.documentID,
                                              ref: doc.reference.parent().path,
                                              enableNavigator: true))
                                          .toList()),
                                ),
                              );
                            }),
                          ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  /*Widget appbar() {
    Size a = MediaQuery.of(context).size;
    return Container(
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
              child: Icon(Icons.arrow_back, color: Colors.white, size: s60),
              onTap: () {
                Navigator.pop(context);
              }),
          Text(
            'ผู้ติดตาม',
            style: TextStyle(
                color: Colors.white,
                fontSize: a.width / 18,
                fontWeight: FontWeight.bold),
          ),
          SizedBox()
        ],
      ),
    );*/
  /*Container(
       height: appBarHeight / 1.42,
                    width: screenWidthDp,
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
    )*/

}
