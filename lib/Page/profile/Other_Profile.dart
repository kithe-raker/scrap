import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrap/Page/bottomBarItem/WriteScrap.dart';
import 'package:scrap/assets/PaperTexture.dart';
import 'package:scrap/function/aboutUser/BlockingFunction.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/FriendsCache.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/function/follows/FollowsFunction.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/stream/UserStream.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/dialog/ScrapDialog.dart';
import 'package:scrap/widget/footer.dart';
import 'package:scrap/widget/peoplethrowpaper.dart';
import 'package:scrap/widget/showcontract.dart';
import 'package:scrap/widget/showdialogreport.dart';
import 'package:scrap/widget/thrown.dart';

class OtherProfile extends StatefulWidget {
  final Map data;
  final String uid;
  final String ref;
  OtherProfile({@required this.data, this.uid, this.ref});
  @override
  _OtherProfileState createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  int page = 0;
  String uid, ref;
  bool initScrapFinish = false;
  bool value = false, pickedScrap = true;
  List followList = [];
  List<DocumentSnapshot> pickScrap = [], scrapCrate = [];
  bool loading = true;
  var textGroup = AutoSizeGroup();
  StreamSubscription loadStream;
  var refreshController = RefreshController();
  var controller = PageController();

  Stream<Event> streamTransaction(String uid, String field) {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var userDb = FirebaseDatabase(app: db.userTransact);
    return userDb.reference().child('users/$uid/$field').onValue;
  }

  Future<DataSnapshot> futureTransaction(String uid, String field) {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var userDb = FirebaseDatabase(app: db.userTransact);
    return userDb.reference().child('users/$uid/$field').once();
  }

  @override
  void initState() {
    initList();
    initScrap();
    loadStream =
        followFunc.loading.listen((value) => setState(() => loading = value));
    super.initState();
  }

  Future<void> initList() async {
    widget.uid == null ? uid = widget.data['uid'] : uid = widget.uid;
    widget.ref == null ? ref = widget.data['ref'] : ref = widget.ref;
    followList = await cacheFriends.getFollowing();
    setState(() => loading = false);
  }

  Future<void> initScrap() async {
    var refColl = fireStore.collection(ref).document(uid);
    var scrapCollection = await refColl
        .collection('scrapCollection')
        .orderBy('timeStamp', descending: true)
        .limit(2)
        .getDocuments();
    var scrapCrates = await refColl
        .collection('thrownScraps')
        .where('pick', isEqualTo: true)
        .orderBy('timeStamp', descending: true)
        .limit(2)
        .getDocuments();
    pickScrap.addAll(scrapCollection.documents);
    scrapCrate.addAll(scrapCrates.documents);
    setState(() => initScrapFinish = true);
  }

  @override
  void dispose() {
    loadStream.cancel();
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserData>(context, listen: false);
    screenutilInit(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              StatefulBuilder(builder: (context, StateSetter setProfile) {
                return Container(
                  // margin: EdgeInsets.only(bottom: screenHeightDp / 21),
                  padding: EdgeInsets.only(top: appBarHeight / 1.35),
                  child: SmartRefresher(
                    footer: Footer(),
                    enablePullDown: false,
                    enablePullUp: true,
                    controller: refreshController,
                    onLoading: () async {
                      if (pickedScrap
                          ? pickScrap.length > 0
                          : scrapCrate.length > 0) {
                        var refColl = pickedScrap
                            ? fireStore
                                .collection('$ref/$uid/scrapCollection')
                                .orderBy('timeStamp', descending: true)
                                .startAfterDocument(pickScrap.last)
                            : fireStore
                                .collection('$ref/$uid/thrownScraps')
                                .where('pick', isEqualTo: true)
                                .orderBy('timeStamp', descending: true)
                                .startAfterDocument(scrapCrate.last);
                        var docs = await refColl.limit(4).getDocuments();
                        pickedScrap
                            ? pickScrap.addAll(docs.documents)
                            : scrapCrate.addAll(docs.documents);
                        docs.documents.length < 1
                            ? refreshController.loadNoData()
                            : refreshController.loadComplete();
                        setProfile(() {});
                      } else
                        refreshController.loadNoData();
                    },
                    // footer: footerList(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          height: screenWidthDp / 3.32,
                          width: screenWidthDp / 3.32,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 1.2),
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(screenHeightDp),
                              image: DecorationImage(
                                  image: NetworkImage(widget.data['img']),
                                  fit: BoxFit.cover)),
                        ),
                        SizedBox(height: appBarHeight / 5),
                        Text('@${widget.data['id']}',
                            style:
                                TextStyle(color: Colors.white, fontSize: s60)),
                        SizedBox(height: appBarHeight / 10),
                        Container(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                              dataProfile('เก็บไว้', uid, field: 'pick'),
                              dataProfile('แอทเทนชัน', uid, field: 'att'),
                              dataProfile('โดนปาใส่', uid, field: 'thrown'),
                            ])),
                        Container(height: screenHeightDp / 100),
                        SizedBox(height: screenHeightDp / 42),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[followButton(), throwButton()]),
                        SizedBox(height: screenHeightDp / 42),
                        widget.data['status'] == null
                            ? SizedBox()
                            : Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: screenWidthDp / 8.1),
                                child: Text('${widget.data['status'] ?? ''}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: s40),
                                    textAlign: TextAlign.center),
                              ),
                        Container(height: screenHeightDp / 72),
                        Divider(color: Colors.grey),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => setProfile(() => pickedScrap = true),
                              child: Container(
                                height: appBarHeight / 2,
                                decoration: BoxDecoration(
                                  border: pickedScrap
                                      ? Border(
                                          bottom: BorderSide(
                                              width: 2.0, color: Colors.white),
                                        )
                                      : null,
                                ),
                                child: Text(
                                  'เก็บจากที่ทิ้งไว้',
                                  style: TextStyle(
                                      fontSize: s48,
                                      color: Colors.white,
                                      fontWeight:
                                          pickedScrap ? FontWeight.bold : null),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                pickedScrap = false;
                                setProfile(() {});
                              },
                              child: Container(
                                height: appBarHeight / 2,
                                decoration: BoxDecoration(
                                    border: pickedScrap
                                        ? null
                                        : Border(
                                            bottom: BorderSide(
                                                width: 2.0,
                                                color: Colors.white))),
                                child: Text(
                                  'เก็บจากโดนปาใส่',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: s48,
                                      fontWeight:
                                          pickedScrap ? null : FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey, height: 0),
                        SizedBox(height: screenWidthDp / 36),
                        initScrapFinish
                            ? scrapGrid(pickedScrap ? pickScrap : scrapCrate)
                            : Container(
                                height: screenHeightDp / 8,
                                child:
                                    Center(child: CircularProgressIndicator())),
                        SizedBox(height: screenHeightDp / 42)
                        // SizedBox(height: screenWidthDp / 36),
                      ],
                    ),
                  ),
                );
              }),
              Positioned(
                  top: 0,
                  child: Container(
                    child: appbar_OtherProfile(context),
                  )),
              // Positioned(
              //     bottom: 0,
              //     child: Container(
              //       child: AdmobBanner(
              //           adUnitId: AdmobService().getBannerAdId(),
              //           adSize: AdmobBannerSize.FULL_BANNER),
              //     )),
              loading ? Loading() : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget footerList() {
    return CustomFooter(builder: (BuildContext context, LoadStatus mode) {
      switch (mode) {
        case LoadStatus.loading:
          return Center(child: CircularProgressIndicator());
          break;
        default:
          return SizedBox();
          break;
      }
    });
  }

  Widget followButton() {
    return StatefulBuilder(builder: (context, StateSetter setButton) {
      return GestureDetector(
          child: Container(
            /* padding: EdgeInsets.fromLTRB(appBarHeight / 3, appBarHeight / 50,
                appBarHeight / 3, appBarHeight / 50),*/
            // padding: EdgeInsets.only(
            //     top: appBarHeight / 4.4, bottom: appBarHeight / 4.4),
            padding: EdgeInsets.symmetric(
              vertical: screenWidthDp / 128,
            ),
            //height: appBarHeight / 2.2,
            width: appBarHeight * 1.5,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xfff26A4FF)),
                borderRadius: BorderRadius.circular(5),
                color: followList.contains(uid)
                    ? Colors.black
                    : Color(0xfff26A4FF)),
            child: Text(
              followList.contains(uid) ? 'กำลังติดตาม' : 'ติดตาม',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: followList.contains(uid)
                      ? Color(0xfff26A4FF)
                      : Colors.white,
                  fontSize: s52),
            ),
          ),
          onTap: () {
            if (followList.contains(uid)) {
              followFunc.unFollowUser(context,
                  otherUid: uid,
                  otherCollRef: ref,
                  followingCounts: followList.length);
              followList.remove(uid);
              setButton(() {});
            } else {
              followFunc.followUser(context,
                  otherUid: uid,
                  otherCollRef: ref,
                  followingCounts: followList.length);
              followList.add(uid);
              setButton(() {});
            }
          });
    });
  }

  Widget throwButton() {
    final user = Provider.of<UserData>(context, listen: false);
    return StreamBuilder(
        stream: streamTransaction(uid, 'allowThrow'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.snapshot.value ?? false
                ? Container(
                    margin: EdgeInsets.only(left: appBarHeight / 10),
                    child: GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(left: appBarHeight / 8.1),
                          /*padding: EdgeInsets.symmetric(
                            vertical: screenWidthDp / 128,
                          ),*/

                          // height: appBarHeight / 2.2,
                          width: appBarHeight * 1.5,
                          padding: EdgeInsets.only(
                            top: screenWidthDp / 128,
                            bottom: screenWidthDp / 128,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'ปาสแครป',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xfff26A4FF),
                              fontSize: s52,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () {
                          userStream.papers > 0
                              ? user.promise
                                  ? nav.push(
                                      context,
                                      WriteScrap(
                                          isThrow: true,
                                          data: widget.data,
                                          thrownUid: uid,
                                          ref: widget.ref))
                                  : dialogcontract(context,
                                      onPromise: () async {
                                      await userinfo.promiseUser();
                                      user.promise = true;
                                      nav.pushReplacement(
                                          context,
                                          WriteScrap(
                                              isThrow: true,
                                              data: widget.data,
                                              thrownUid: uid,
                                              ref: widget.ref));
                                    })
                              : toast.toast('กระดาษคุณหมดแล้ว');
                        }))
                : SizedBox();
          } else {
            return SizedBox();
          }
        });
  }

  // Appbar สำหรับ หน้า Profile ของคนอื่น
  Widget appbar_OtherProfile(BuildContext context) {
    return Container(
      height: appBarHeight / 1.42,
      width: screenWidthDp,
      color: Colors.black,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidthDp / 21,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
              child: Icon(Icons.arrow_back, color: Colors.white, size: s60),
              onTap: () {
                Navigator.pop(context, true);
              }),
          GestureDetector(
              child: Icon(Icons.more_horiz, color: Colors.white, size: s54),
              onTap: () => showButtonSheet(context)),
        ],
      ),
    );
  }

  Widget scrapGrid(List<DocumentSnapshot> scraps) {
    return GestureDetector(
      child: Container(
          child: scraps.length > 0
              ? Wrap(
                  spacing: screenWidthDp / 42,
                  runSpacing: screenWidthDp / 42,
                  alignment: WrapAlignment.start,
                  children: scraps.map((data) => scrap(data)).toList())
              : Container(
                  height: screenHeightDp / 7.2,
                  child: Center(
                    child: Text('ไม่พบกระดาษที่เก็บไว้',
                        style: TextStyle(color: Colors.white60, fontSize: s46)),
                  ))),
      onTap: () {},
    );
  }

  Widget scrap(DocumentSnapshot data) {
    return GestureDetector(
      child: Container(
          height: screenWidthDp / 2.16 * 1.21,
          width: screenWidthDp / 2.16,
          child: Stack(children: <Widget>[
            SvgPicture.asset(
                'assets/${texture.textures[data['scrap']['texture'] ?? 0]}',
                fit: BoxFit.cover),
            Center(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 64),
              child: AutoSizeText(data['scrap']['text'],
                  textAlign: TextAlign.center,
                  group: textGroup,
                  style: TextStyle(fontSize: s46)),
            )),
          ])),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => pickedScrap
                ? ScrapDialog(data: data, showTransaction: true)
                : Paperstranger(scrap: data, isHistory: true));
      },
    );
  }

  Widget checkValue(trans) {
    // < K
    if (trans < 1000 && trans >= 0) {
      return Container(
        child: Text(
          '${trans.floor()}',
          style: TextStyle(
              color: Colors.white,
              fontSize: s70 * 1.2,
              fontWeight: FontWeight.bold),
        ),
      );
    }
    // K <= value < M
    else if (trans < 10000) {
      return Container(
        child: Text(
          '${(trans / 1000).toStringAsFixed(2)}K',
          style: TextStyle(
              color: Colors.white,
              fontSize: s70 * 1.2,
              fontWeight: FontWeight.bold),
        ),
      );
    }
    // 10K
    else if (trans < 100000) {
      return Container(
        child: Text(
          '${(trans / 1000).toStringAsFixed(1)}K',
          style: TextStyle(
              color: Colors.white,
              fontSize: s70 * 1.2,
              fontWeight: FontWeight.bold),
        ),
      );
    } else if (trans < 1000000) {
      return Container(
        child: Text(
          '${(trans ~/ 1000)}K',
          style: TextStyle(
              color: Colors.white,
              fontSize: s70 * 1.2,
              fontWeight: FontWeight.bold),
        ),
      );
    }
    // >= M
    else {
      return Container(
        child: Text(
          '${(trans / 1000000).toStringAsFixed(2)}M',
          style: TextStyle(
              color: Colors.white,
              fontSize: s70 * 1.2,
              fontWeight: FontWeight.bold),
        ),
      );
    }
  }

  Widget dataProfile(String name, String uid, {@required String field}) {
    return SizedBox(
      width: screenWidthDp / 5.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FutureBuilder(
              future: futureTransaction(uid, field),
              builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                if (snapshot.hasData) {
                  var trans = snapshot.data.value;
                  return Container(
                      height: screenWidthDp / 6,
                      child: checkValue(trans.abs()));
                } else {
                  return Text(
                    '0',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: s70 * 1.2,
                        fontWeight: FontWeight.bold),
                  );
                }
              }),
          Container(
            child: Text(
              name,
              style: TextStyle(
                height: 0.21,
                color: Color(0xfff727272),
                fontWeight: FontWeight.bold,
                fontSize: s36,
              ),
            ),
          ),
        ],
      ),
    );
  }

// void bottomSheet ใช้กับ icon_horiz
  void showButtonSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            height: appBarHeight * 2.2,
            decoration: BoxDecoration(
              color: Color(0xff202020),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 12, bottom: 4),
                      width: screenWidthDp / 3.2,
                      height: screenHeightDp / 81,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(screenHeightDp / 42),
                        color: Color(0xff929292),
                      ),
                    )),
                Container(
                  //  margin: EdgeInsets.only(bottom: appBarHeight - 20),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: screenWidthDp / 12,
                            ),
                            GestureDetector(
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          screenHeightDp)),
                                  child: Icon(Icons.block,
                                      size: appBarHeight / 3)),
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        Loading());
                                await blocking.blockUser(context,
                                    otherUid: uid, public: true);
                                nav.pop(context);
                              },
                            ),
                            Text(
                              'ปิดกั้นการปา',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: s42,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: screenWidthDp / 12,
                            ),
                            GestureDetector(
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          screenHeightDp)),
                                  child: Icon(Icons.report_problem,
                                      size: appBarHeight / 3)),
                              onTap: () {
                                final report =
                                    Provider.of<Report>(context, listen: false);
                                report.targetId = uid;
                                nav.pop(context);
                                showDialogReport(context);
                              },
                            ),
                            Text(
                              'รายงาน',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: s42,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Positioned(
                //     bottom: 0,
                //     child: Container(
                //       child: AdmobBanner(
                //           adUnitId: AdmobService().getBannerAdId(),
                //           adSize: AdmobBannerSize.FULL_BANNER),
                //     )),
              ],
            ),
          );
        });
  }
}
