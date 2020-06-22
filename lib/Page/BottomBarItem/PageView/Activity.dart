import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/widget/CountDownText.dart';
import 'package:scrap/widget/LoadNoBlur.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/beforeburn.dart';
import 'package:scrap/widget/dialog/ScrapDialog.dart';
import 'package:scrap/widget/dialog/ScrapFeedDialog.dart';
import 'package:scrap/widget/sheets/CommentSheet.dart';
import 'package:scrap/widget/sheets/MapSheet.dart';
import 'package:scrap/widget/showdialogreport.dart';

class Activity extends StatefulWidget {
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity>
    with AutomaticKeepAliveClientMixin {
  List cacheComments = [];
  var refreshController = RefreshController();
  Map<String, List> history = {};
  bool loading = true;
  var textGroup = AutoSizeGroup();

  @override
  void initState() {
    initScrap();
    super.initState();
  }

  initScrap() async {
    cacheComments = await cacheHistory.readHistory(field: 'picked') ?? [];
    history['like'] = await cacheHistory.readOnlyId(field: 'like') ?? [];
    history['picked'] = await cacheHistory.readOnlyId(field: 'picked') ?? [];
    history['burn'] = await cacheHistory.readOnlyId(field: 'burn') ?? [];
    setState(() => loading = false);
  }

  Timestamp yesterDay() {
    var now = DateTime.now();
    return Timestamp.fromDate(
        DateTime(now.year, now.month, now.day - 1, now.hour, now.minute));
  }

  bool isExpired(DocumentSnapshot data) {
    DateTime startTime = data['scrap']['timeStamp'].toDate();
    return DateTime(startTime.year, startTime.month, startTime.day + 1,
            startTime.hour, startTime.second)
        .difference(DateTime.now())
        .isNegative;
  }

  Future<DataSnapshot> scrapTransaction(String docId) {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    var ref = scrapAll.reference().child('scraps').child(docId);
    return ref.once();
  }

  bool inHistory(String field, String id) {
    return history[field].contains(id);
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    screenutilInit(context);
    return Scaffold(
        backgroundColor: Colors.black,
        body: loading
            ? Center(child: LoadNoBlur())
            : Container(
                width: screenWidthDp,
                height: screenHeightDp,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: screenHeightDp / 42),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidthDp / 48),
                        child: Text(
                          'สแครปโยนล่าสุดของคุณ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: s46,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: screenHeightDp / 72),
                      Container(
                        height: screenWidthDp / 2.16 * 1.21,
                        child: StreamBuilder(
                            stream: fireStore
                                .collection(
                                    'Users/th/users/J4Dx9hXQbibuQCO9T10Urb8JR6K2/history')
                                .orderBy('scrap.timeStamp', descending: true)
                                .where('scrap.timeStamp',
                                    isGreaterThan: yesterDay())
                                .limit(10)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<DocumentSnapshot> writtenScrap =
                                    snapshot.data.documents;
                                return writtenScrap.length > 0
                                    ? ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: writtenScrap
                                            .map((dat) => Container(
                                                  margin: EdgeInsets.only(
                                                      left: screenWidthDp / 48),
                                                  child: scrapWidget(dat,
                                                      showComment: false),
                                                ))
                                            .toList())
                                    : Center(
                                        child: Text(
                                          'ยังไม่มีสแครปที่คุณโยนในวันนี้',
                                          style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.51),
                                              fontWeight: FontWeight.bold,
                                              fontSize: s52),
                                        ),
                                      );
                              } else
                                return Center(child: LoadNoBlur());
                            }),
                      ),
                      SizedBox(height: screenHeightDp / 48),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidthDp / 48),
                        child: Text(
                          'สแครปเก็บล่าสุดของคุณ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: s46,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: screenHeightDp / 72),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidthDp / 48),
                        child: StreamBuilder(
                            stream: fireStore
                                .collection(
                                    'Users/th/users/J4Dx9hXQbibuQCO9T10Urb8JR6K2/scrapCollection')
                                .orderBy('scrap.timeStamp', descending: true)
                                .where('scrap.timeStamp',
                                    isGreaterThan: yesterDay())
                                .limit(10)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<DocumentSnapshot> scraps =
                                    snapshot.data.documents;
                                return scraps.length > 0
                                    ? Wrap(
                                        spacing: screenWidthDp / 42,
                                        runSpacing: screenWidthDp / 42,
                                        alignment: WrapAlignment.center,
                                        children: scraps
                                            .map((scrap) => scrapWidget(scrap,
                                                docs: scraps))
                                            .toList())
                                    : Container(
                                        margin: EdgeInsets.only(
                                            top: screenWidthDp / 5.1),
                                        child: Center(
                                          child: Text(
                                            'ยังไม่มีสแครปที่คุณเก็บในวันนี้',
                                            style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.51),
                                                fontWeight: FontWeight.bold,
                                                fontSize: s52),
                                          ),
                                        ),
                                      );
                              } else
                                return Center(child: LoadNoBlur());
                            }),
                      ),
                      SizedBox(height: screenHeightDp / 42)
                    ],
                  ),
                ),
              ));
  }

  Widget text(String textt) {
    Size a = MediaQuery.of(context).size;
    return Text(textt,
        style: TextStyle(
            color: Color(0xfffFFFFFF).withOpacity(0.51),
            fontWeight: FontWeight.bold,
            fontSize: a.width / 15));
  }

  Widget scrapWidget(DocumentSnapshot data,
      {List docs, bool showComment = true}) {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    int ments, comments;
    if (showComment && cacheComments.length > 0) {
      var result =
          cacheComments.where((cache) => cache['id'] == data['id']).toList();
      result.length > 0 ? comments = result.first['comments'] : comments = 0;
    }

    return GestureDetector(
      child: FutureBuilder(
          future:
              scrapAll.reference().child('scraps/${data['id']}/comment').once(),
          builder: (context, snapshot) {
            ments = snapshot.data?.value ?? null;
            return Container(
              height: screenWidthDp / 2.16 * 1.21,
              width: screenWidthDp / 2.16,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/paperscrap.jpg'),
                      fit: BoxFit.cover)),
              child: Stack(
                children: <Widget>[
                  Center(
                      child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidthDp / 64),
                    child: AutoSizeText(data['text'] ?? data['scrap']['text'],
                        textAlign: TextAlign.center,
                        group: textGroup,
                        style: TextStyle(fontSize: s46)),
                  )),
                  showComment
                      ? snapshot.hasData && snapshot.data?.value == null
                          ? Container(
                              height: screenWidthDp / 2.16 * 1.21,
                              width: screenWidthDp / 2.16,
                              color: Colors.black38,
                              child: ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 8.1, sigmaY: 8.1),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.whatshot,
                                            size: 50, color: Color(0xffFF8F3A)),
                                        Text('ถูกเผาแล้ว',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: s48,
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                ),
                              ))
                          : SizedBox()
                      : data['burnt'] ?? false
                          ? Container(
                              height: screenWidthDp / 2.16 * 1.21,
                              width: screenWidthDp / 2.16,
                              color: Colors.black38,
                              child: ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 8.1, sigmaY: 8.1),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.whatshot,
                                            size: 50, color: Color(0xffFF8F3A)),
                                        Text('ถูกเผาแล้ว',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: s48,
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                ),
                              ))
                          : SizedBox(),
                  showComment
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: snapshot.hasData
                              ? ments != null
                                  ? commentTransactionBox(
                                      ments.abs(), comments?.abs() ?? 0)
                                  : SizedBox()
                              : commentTransactionBox(
                                  comments?.abs() ?? 0, comments?.abs() ?? 0))
                      : SizedBox()
                ],
              ),
            );
          }),
      onTap: () {
        if (ments != null && showComment) {
          if (ments.abs() != comments?.abs() ?? 0) {
            cacheHistory.updateFollowingScrap(
                data['id'], ments, data['scrap']['timeStamp'].toDate());
            if (cacheComments.length > 0) {
              var result = cacheComments
                  .where((cache) => cache['id'] == data['id'])
                  .toList();
              if (result.length > 0) {
                cacheComments.firstWhere(
                    (scrap) => scrap['id'] == data['id'])['comments'] = ments;
              } else
                cacheComments.add({'id': data['id'], 'comments': ments});
            } else
              cacheComments.add({'id': data['id'], 'comments': ments});
          }
          setState(() {});

          // dialog(cacheComments.indexOf(data));
          showDialog(
              context: context,
              builder: (BuildContext context) => ScrapFeedDialog(
                  scraps: docs, currentIndex: docs.indexOf(data)));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) => ScrapDialog(data: data));
        }
      },
    );
  }

  Widget commentTransactionBox(int comments, int cacheComment) {
    return Container(
        margin: EdgeInsets.all(screenWidthDp / 45),
        alignment: Alignment.center,
        width: screenWidthDp / 6,
        height: screenWidthDp / 13,
        decoration: BoxDecoration(
            color: comments == cacheComment
                ? Color(0xff707070)
                : Color(0xff0077CC),
            borderRadius: BorderRadius.circular(screenWidthDp / 80)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('$comments',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: screenWidthDp / 20)),
              Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: Icon(Icons.sms, color: Colors.white))
            ]));
  }

  void dialog(int index, List<DocumentSnapshot> docs) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      Size a = MediaQuery.of(context).size;
      return StatefulBuilder(builder: (context, StateSetter setDialog) {
        Map doc = docs[index].data;
        DocumentSnapshot docData;
        return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: (a.width - a.width / 1.04) / 2),
                  width: a.width,
                  height: a.height,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: a.height / 42),
                        FutureBuilder(
                            future: Firestore.instance
                                .collection(doc['path'])
                                .document(doc['id'])
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var data = snapshot.data;
                                docData = data;
                                var scrap = data['scrap'];
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            child: Image.asset(
                                              'assets/paperscrap.jpg',
                                              //--เปลี่ยนขนาดกระดาษ
                                              width: a.width / 1.04,
                                              height: a.width / 1.04 * 1.115,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(
                                                left: 25, right: 25),
                                            height: a.width / 1.04 * 1.115,
                                            width: a.width / 1.04,
                                            child: Text(
                                              doc['text'],
                                              style: TextStyle(
                                                  height: 1.35, fontSize: s60),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Positioned(
                                            top: 12,
                                            right: 12,
                                            child: GestureDetector(
                                              child: Container(
                                                width: screenWidthDp / 16,
                                                height: screenWidthDp / 16,
                                                decoration: BoxDecoration(
                                                    color: Color(0xff000000)
                                                        .withOpacity(0.47),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            screenWidthDp /
                                                                18)),
                                                child: Icon(Icons.close,
                                                    color: Colors.white,
                                                    size: s42),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      onDoubleTap: () {
                                        showDialog(
                                          context: Scaffold.of(context).context,
                                          builder: (BuildContext context) =>
                                              MapSheet(
                                            position: LatLng(
                                                data['position']['geopoint']
                                                    .latitude,
                                                data['position']['geopoint']
                                                    .longitude),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: screenWidthDp / 21),
                                    Container(
                                      width: a.width,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidthDp / 36),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                scrap['writer'] ==
                                                        'ไม่ระบุตัวตน'
                                                    ? 'ใครบางคน'
                                                    : '@${scrap['writer']}',
                                                style: TextStyle(
                                                    fontSize: s48,
                                                    height: 1.1,
                                                    color: scrap['writer'] ==
                                                            'ไม่ระบุตัวตน'
                                                        ? Colors.white
                                                        : Color(0xff26A4FF)),
                                              ),
                                              CountDownText(
                                                  startTime: data['scrap']
                                                          ['timeStamp']
                                                      .toDate())
                                            ],
                                          ),
                                          GestureDetector(
                                            child: Icon(Icons.more_horiz,
                                                color: Colors.white, size: s70),
                                            onTap: () => showMore(context,
                                                scrap: docData),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Column(
                                  children: <Widget>[
                                    Container(
                                      width: a.width / 1.04,
                                      height: a.width / 1.04 * 1.115,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/paperscrap.jpg'),
                                              fit: BoxFit.cover)),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    ),
                                    SizedBox(height: screenHeightDp / 12)
                                  ],
                                );
                              }
                            }),
                        SizedBox(height: screenWidthDp / 42),
                        Divider(color: Color(0xff5D5D5D), thickness: 1.2),
                        SizedBox(height: screenWidthDp / 46),
                        SizedBox(
                          width: a.width,
                          height: screenHeightDp / 9.6,
                          child: FutureBuilder(
                              future: scrapTransaction(doc['id']),
                              builder:
                                  (context, AsyncSnapshot<DataSnapshot> event) {
                                if (event.hasData) {
                                  var trans = event.data;
                                  var like = trans.value['like'];
                                  var pick = trans.value['picked'];
                                  return StatefulBuilder(
                                      builder: (context, StateSetter setTrans) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          width: screenWidthDp / 2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              GestureDetector(
                                                child: iconWithLabel(
                                                    like.abs().toString(),
                                                    icon: inHistory(
                                                            'like', doc['id'])
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    background: inHistory(
                                                            'like', doc['id'])
                                                        ? Color(0xffFF4343)
                                                        : Colors.white,
                                                    iconColor: inHistory(
                                                            'like', doc['id'])
                                                        ? Colors.white
                                                        : Color(0xffFF4343)),
                                                onTap: () {
                                                  if (docData != null) {
                                                    if (isExpired(docData)) {
                                                      scrap.toast(
                                                          'แสครปนี้ย่อยสลายแล้ว');
                                                    } else {
                                                      if (inHistory(
                                                          'like', doc['id'])) {
                                                        ++like;
                                                        history['like']
                                                            .remove(doc['id']);
                                                      } else {
                                                        --like;
                                                        history['like']
                                                            .add(doc['id']);
                                                      }
                                                      scrap.updateScrapTrans(
                                                          'like', context,
                                                          doc: docData);
                                                      setTrans(() {});
                                                    }
                                                  }
                                                },
                                              ),
                                              GestureDetector(
                                                child: iconWithLabel(
                                                    pick.abs().toString(),
                                                    background: inHistory(
                                                            'picked', doc['id'])
                                                        ? Color(0xff0099FF)
                                                        : Colors.white,
                                                    iconColor: inHistory(
                                                            'picked', doc['id'])
                                                        ? Colors.white
                                                        : Color(0xff0099FF),
                                                    icon: Icons.move_to_inbox),
                                                onTap: () {
                                                  if (docData != null) {
                                                    if (isExpired(docData)) {
                                                      scrap.toast(
                                                          'แสครปนี้ย่อยสลายแล้ว');
                                                    } else {
                                                      if (inHistory('picked',
                                                          doc['id'])) {
                                                        ++pick;
                                                        history['picked']
                                                            .remove(doc['id']);
                                                      } else {
                                                        --pick;
                                                        history['picked']
                                                            .add(doc['id']);
                                                      }
                                                      scrap.updateScrapTrans(
                                                          'picked', context,
                                                          doc: docData,
                                                          comments: trans.value[
                                                              'comment']);
                                                      setTrans(() {});
                                                    }
                                                  }
                                                },
                                              ),
                                              GestureDetector(
                                                  child: iconWithLabel(
                                                      trans?.value['comment']
                                                          .abs()
                                                          .toString(),
                                                      iconColor: Color(
                                                              0xff000000)
                                                          .withOpacity(0.83),
                                                      icon: Icons.sms),
                                                  onTap: () {
                                                    if (docData != null)
                                                      Scaffold.of(context)
                                                          .showBottomSheet(
                                                        (BuildContext
                                                                context) =>
                                                            CommentSheet(
                                                                doc: docData),
                                                        backgroundColor:
                                                            Colors.transparent,
                                                      );
                                                  })
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: screenWidthDp / 42),
                                          child: GestureDetector(
                                            child: iconWithLabel('ต่อไป',
                                                iconColor: Color(0xff000000),
                                                icon: Icons.forward),
                                            onTap: () {
                                              doc == cacheComments.last
                                                  ? index = 0
                                                  : ++index;
                                              setDialog(() {});
                                            },
                                          ),
                                        )
                                      ],
                                    );
                                  });
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              }),
                        ),
                        SizedBox(height: screenWidthDp / 36),
                        // Expanded(
                        //   child: AdmobBanner(
                        //       adUnitId: AdmobService().getBannerAdId(),
                        //       adSize: AdmobBannerSize.FULL_BANNER),
                        // )
                      ])),
            ));
      });
    }));
  }

  void showMore(context, {@required DocumentSnapshot scrap}) {
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
                  // margin: EdgeInsets.only(
                  //   bottom: appBarHeight - 20,
                  // ),
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
                                  child: Icon(Icons.whatshot,
                                      color: Color(0xffFF8F3A),
                                      size: appBarHeight / 3)),
                              onTap: () {
                                if (inHistory('burn', scrap.documentID)) {
                                  toast.toast('คุณเคยเผาสแครปก้อนนี้แล้ว');
                                } else {
                                  final report = Provider.of<Report>(context,
                                      listen: false);
                                  report.scrapId = scrap.documentID;
                                  report.scrapRef =
                                      scrap.reference.parent().path;
                                  report.targetId = scrap['uid'];
                                  report.region = scrap['region'];
                                  showdialogBurn(context,
                                      burntScraps: history['burn']);
                                }
                              },
                            ),
                            Text(
                              'เผา',
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
                                report.targetId = scrap['uid'];
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

  Widget iconWithLabel(String label,
      {Color background = Colors.white,
      @required Color iconColor,
      @required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: screenWidthDp / 9,
          width: screenWidthDp / 9,
          decoration: BoxDecoration(
              color: background, // Color(0xffFF4343),
              borderRadius: BorderRadius.circular(screenWidthDp / 8)),
          child: Icon(
            icon, // Icons.favorite_border,
            color: iconColor,
            size: s46,
          ),
        ),
        Text(
          label,
          style: TextStyle(
              color: Colors.white,
              fontSize: s42,
              height: 1.2,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
