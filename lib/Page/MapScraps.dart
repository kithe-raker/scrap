import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/subjects.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/function/scrapFilter.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/provider/AdsCounter.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';

class MapScraps extends StatefulWidget {
  final String uid;
  MapScraps({@required this.uid});
  @override
  _MapScrapsState createState() => _MapScrapsState();
}

class _MapScrapsState extends State<MapScraps> {
  final geoLocator = Geolocator();
  final random = Random();
  Position currentLocation;
  StreamSubscription subLimit;
  int adsRate = 0;
  int i = 0;
  String date, time;
  PublishSubject<int> streamLimit = PublishSubject();
  DocumentSnapshot recentScrap;
  List<DocumentSnapshot> allScrap = [];
  bool loadFin = false;
  BitmapDescriptor _curcon, scrapIcon;
  bool checkPlatform = Platform.isIOS;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<CircleId, Circle> circles = <CircleId, Circle>{};
  GoogleMapController mapController;
  FirebaseMessaging fcm = FirebaseMessaging();
  DateTime now = DateTime.now();
  Set ads = {};
  Map randData = {};
  Map<String, List> history = {};
  Scraps scrap = Scraps();
  final infoKey = GlobalKey();
  ScrapFilter filter = ScrapFilter();
  StreamSubscription streamLocation;

  @override
  void initState() {
    if (this.mounted) {
      time = DateFormat('Hm').format(now);
      date = DateFormat('d/M/y').format(now);
      streamLocation = geoLocator
          .getPositionStream()
          .listen((event) => setState(() => currentLocation = event));
      randomAdsRate();
      initUserHistory();
      super.initState();
    }
  }

  void randomAdsRate() {
    adsRate = 3;
    adsRate += random.nextInt(2) + 1;
  }

  Future<void> initUserHistory() async {
    history['like'] = await cacheHistory.readOnlyId(field: 'like') ?? [];
    history['picked'] = await cacheHistory.readOnlyId(field: 'picked') ?? [];
    setState(() => loadFin = true);
  }

  bool inHistory(String field, String id) {
    return history[field].contains(id);
  }

  Future<DataSnapshot> scrapTransaction(String docId) {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    var ref = scrapAll.reference().child('scraps').child(docId);
    return ref.once();
  }

  void updateScrapTrans(String field, DocumentSnapshot doc) {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    var defaultDb = FirebaseDatabase.instance;
    var ref = 'scraps/${doc.documentID}';

    if (inHistory(field, doc.documentID)) {
      history[field].remove(doc.documentID);
      cacheHistory.removeHistory(field, doc.documentID);
      scrapAll.reference().child(ref).once().then((mutableData) {
        defaultDb.reference().child(ref).update({
          field: mutableData.value[field] + 1,
          'point': field == 'like'
              ? mutableData.value['point'] + 1
              : mutableData.value['point'] + 3
        });
        scrapAll.reference().child(ref).update({
          field: mutableData.value[field] + 1,
          'point': field == 'like'
              ? mutableData.value['point'] + 1
              : mutableData.value['point'] + 3
        });
      });
      if (field == 'like')
        fcm.unsubscribeFromTopic(doc.documentID);
      else
        pickScrap(doc.data, cancel: true);
    } else {
      history[field].add(doc.documentID);
      cacheHistory.addHistory(
          doc.documentID, doc['scrap']['time'].toDate(), doc['scrap']['user'],
          field: field);
      defaultDb.reference().child(ref).once().then((mutableData) {
        defaultDb.reference().child(ref).update({
          field: mutableData.value[field] - 1,
          'point': field == 'like'
              ? mutableData.value['point'] - 1
              : mutableData.value['point'] - 3
        });
        scrapAll.reference().child(ref).update({
          field: mutableData.value[field] - 1,
          'point': field == 'like'
              ? mutableData.value['point'] - 1
              : mutableData.value['point'] - 3
        });
      });

      if (field == 'like')
        fcm.subscribeToTopic(doc.documentID);
      else
        pickScrap(doc.data);
    }
  }

  error(BuildContext context, String sub) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            "ขออภัย",
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            sub,
            style: TextStyle(fontSize: 16),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'ตกลง',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  commentSheet(DocumentSnapshot scrapSnapshot) {
    bool canSend = false;
    List commentList = [];
    var controller = RefreshController();
    TextEditingController comment = TextEditingController();
    CollectionReference ref = Firestore.instance.collection(
        'Users/${scrapSnapshot['uid']}/scraps/${scrapSnapshot.documentID}/comments');
    return SizedBox(
        width: screenWidthDp,
        height: screenHeightDp / 1.18,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Container(
            margin: EdgeInsets.only(top: screenWidthDp / 8.1),
            decoration: BoxDecoration(
                color: Color(0xff282828),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24))),
            child: Column(
              children: <Widget>[
                Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 12, bottom: 4),
                          width: screenWidthDp / 3.2,
                          height: screenHeightDp / 81,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(screenHeightDp / 42),
                            color: Color(0xff929292),
                          ),
                        )
                      ],
                    )),
                Expanded(
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidthDp / 56),
                      child: FutureBuilder(
                          future: ref
                              .orderBy('timeStamp', descending: true)
                              .limit(8)
                              .getDocuments(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              commentList.addAll(snapshot.data.documents);
                              return StatefulBuilder(
                                  builder: (context, StateSetter setComment) {
                                return SmartRefresher(
                                    enablePullUp: true,
                                    enablePullDown: true,
                                    controller: controller,
                                    onRefresh: () {
                                      setComment(() {});
                                      controller.refreshCompleted();
                                    },
                                    onLoading: () async {
                                      var docs = await ref
                                          .orderBy('timeStamp',
                                              descending: true)
                                          .startAfterDocument(commentList.last)
                                          .limit(8)
                                          .getDocuments();
                                      if (docs.documents.length > 0) {
                                        commentList.addAll(docs.documents);
                                        setComment(() {});
                                        controller.loadComplete();
                                      } else {
                                        controller.loadNoData();
                                      }
                                    },
                                    child: ListView(
                                        children: commentList
                                            .map((doc) => commentBox(doc))
                                            .toList()));
                              });
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          })),
                ),
                StatefulBuilder(builder: (context, StateSetter setSheet) {
                  comment.selection = TextSelection.fromPosition(
                      TextPosition(offset: comment.text.length));
                  return Container(
                      width: screenWidthDp,
                      height: screenHeightDp / 12,
                      decoration: BoxDecoration(
                          color: Color(0xff282828),
                          border: Border(
                              top: BorderSide(
                                  color: Color(0xff414141), width: 1.2))),
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: screenWidthDp / 32),
                          Expanded(
                              child: Container(
                            height: screenHeightDp / 17.4,
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: Color(0xff313131),
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: comment,
                              onChanged: (val) {
                                val.trim().length > 0
                                    ? setSheet(() => canSend = true)
                                    : setSheet(() => canSend = false);
                                comment.text = val;
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'พิมพ์อะไรสักอย่างสิ',
                                  hintStyle: TextStyle(
                                      color: Colors.white38,
                                      fontSize: s48,
                                      height: 0.72)),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: s48,
                                  height: 0.72),
                              textInputAction: TextInputAction.done,
                              onSubmitted: (val) {
                                addComment(
                                    commentList, ref, scrapSnapshot.documentID,
                                    comment: comment.text.trim());
                                comment.clear();
                                setSheet(() => canSend = false);
                                controller.requestRefresh();
                              },
                            ),
                          )),
                          SizedBox(width: screenWidthDp / 32),
                          GestureDetector(
                            child: Icon(
                              Icons.send,
                              color: canSend
                                  ? Color(0xff26A4FF)
                                  : Color(0xff6C6C6C),
                              size: s60,
                            ),
                            onTap: () {
                              addComment(
                                  commentList, ref, scrapSnapshot.documentID,
                                  comment: comment.text);
                              comment.clear();
                              setSheet(() => canSend = false);
                              controller.requestRefresh();
                            },
                          ),
                          SizedBox(width: screenWidthDp / 32),
                        ],
                      ));
                })
              ],
            ),
          ),
        ));
  }

  Widget commentBox(dynamic comment) {
    return Container(
        child: ListTile(
      leading: ClipRRect(
          borderRadius: BorderRadius.circular(screenWidthDp),
          child: CachedNetworkImage(
            imageUrl: comment['image'],
            fit: BoxFit.cover,
            width: screenWidthDp / 8.1,
            height: screenWidthDp / 8.1,
          )),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Text(
            '${comment['name']}',
            style: TextStyle(
                color: Colors.white,
                fontSize: s48,
                fontWeight: FontWeight.bold),
          ),
          Text(
            ' ${readTimestamp(comment['timeStamp'])}',
            style:
                TextStyle(color: Colors.white, fontSize: s32, wordSpacing: 0.5),
          )
        ],
      ),
      subtitle: Text(
        comment['comment'],
        style: TextStyle(color: Colors.white, fontSize: s42, height: 0.9),
      ),
    ));
  }

  String readTimestamp(dynamic timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date =
        timestamp.runtimeType == Timestamp ? timestamp.toDate() : timestamp;
    var diff = now.difference(date);
    var time = '';
    if (diff.inDays < 1) {
      if (diff.inSeconds <= 30) {
        time = 'ไม่กี่วินาทีที่ผ่านมานี้';
      } else if (diff.inSeconds <= 60) {
        time = diff.inSeconds.toString() + ' วินาทีที่แล้ว';
      } else if (diff.inMinutes < 5) {
        time = 'เมื่อไม่นานมานี้';
      } else if (diff.inMinutes < 60) {
        time = diff.inMinutes.toString() + ' นาทีที่แล้ว';
      } else {
        time = diff.inHours.toString() + ' ชั่วโมงที่แล้ว';
      }
    } else if (diff.inDays < 7) {
      diff.inDays == 1
          ? time = 'เมื่อวานนี้'
          : time = diff.inDays.toString() + ' วันที่แล้ว';
    } else {
      diff.inDays == 7 ? time = ' สัปดาที่แล้ว' : time = format.format(date);
    }
    return time;
  }

  addComment(List commentList, CollectionReference ref, String scrapId,
      {@required String comment}) async {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    var defaultDb = FirebaseDatabase.instance;
    var refChild = 'scraps/$scrapId';

    Map data = await userinfo.readContents();
    commentList.insert(0, {
      'name': data['name'],
      'image': data['img'],
      'comment': comment,
      'timeStamp': DateTime.now()
    });
    ref.add({
      'name': data['name'],
      'image': data['img'],
      'comment': comment,
      'timeStamp': FieldValue.serverTimestamp()
    });

    scrapAll.reference().child(refChild).once().then((mutableData) {
      defaultDb.reference().child(refChild).update({
        'comment': mutableData.value['comment'] - 1,
        'point': mutableData.value['point'] - 2
      });
      scrapAll.reference().child(refChild).update({
        'comment': mutableData.value['comment'] - 1,
        'point': mutableData.value['point'] - 2
      });
    });
  }

  //sssss
  void dialog(DocumentSnapshot doc) {
    final counter = Provider.of<AdsCounterProvider>(context, listen: false);
    var data = doc;
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      Size a = MediaQuery.of(context).size;
      return StatefulBuilder(builder: (context, StateSetter setDialog) {
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
                        counter.count == adsRate
                            ? Center(
                                child: Text(
                                'โฆษณา',
                                style: TextStyle(
                                    fontSize: s42,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ))
                            : SizedBox(height: a.height / 42),
                        counter.count == adsRate
                            ? SizedBox(
                                width: a.width / 1.04,
                                height: a.width / 1.04 * 1.29,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      width: a.width / 1.04,
                                      height: a.width / 1.04 * 1.29,
                                      child: AdmobBanner(
                                          adUnitId:
                                              AdmobService().getBannerAdId(),
                                          adSize: AdmobBannerSize.FULL_BANNER),
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
                                                          screenWidthDp / 18)),
                                              child: Icon(Icons.close,
                                                  color: Colors.white,
                                                  size: s42),
                                            ),
                                            onTap: () {
                                              randomAdsRate();
                                              counter.count = 0;
                                              Navigator.pop(context);
                                            }))
                                  ],
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Container(
                                        child: Image.asset(
                                          'assets/paper-readed.png',
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
                                          filter.censorString(
                                              data['scrap']['text']),
                                          style: TextStyle(
                                            height: 1.35,
                                            fontSize: s60,
                                          ),
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
                                                        screenWidthDp / 18)),
                                            child: Icon(Icons.close,
                                                color: Colors.white, size: s42),
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      )
                                    ],
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
                                              data['scrap']['user'] ==
                                                      'ไม่ระบุตัวตน'
                                                  ? 'ใครบางคน'
                                                  : '@${data['scrap']['user']}',
                                              style: TextStyle(
                                                  fontSize: s48,
                                                  height: 1.1,
                                                  color: data['scrap']
                                                              ['user'] ==
                                                          'ไม่ระบุตัวตน'
                                                      ? Colors.white
                                                      : Color(0xff26A4FF)),
                                            ),
                                            Text(
                                                'เวลา : ${DateFormat('HH:mm').format(data['scrap']['time'].toDate())}',
                                                style: TextStyle(
                                                    fontSize: s36,
                                                    height: 0.8,
                                                    color: Color(0xff969696)))
                                          ],
                                        ),
                                        Icon(Icons.more_horiz,
                                            color: Colors.white, size: s70)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(height: screenWidthDp / 42),
                        Divider(color: Color(0xff5D5D5D), thickness: 1.2),
                        SizedBox(height: screenWidthDp / 46),
                        SizedBox(
                          width: a.width,
                          height: screenHeightDp / 9.6,
                          child: counter.count == adsRate
                              ? Center(
                                  child: GestureDetector(
                                      child: iconWithLabel('ต่อไป',
                                          iconColor: Color(0xff000000),
                                          icon: Icons.forward),
                                      onTap: () {
                                        randomAdsRate();
                                        counter.count = 0;
                                        setDialog(() {});
                                      }))
                              : FutureBuilder(
                                  future: scrapTransaction(data.documentID),
                                  builder: (context,
                                      AsyncSnapshot<DataSnapshot> event) {
                                    if (event.hasData) {
                                      var trans = event.data;
                                      var like = trans.value['like'];
                                      var pick = trans.value['picked'];
                                      return StatefulBuilder(builder:
                                          (context, StateSetter setTrans) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              width: screenWidthDp / 2,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  GestureDetector(
                                                    child: iconWithLabel(
                                                        like.abs().toString(),
                                                        icon: inHistory('like',
                                                                data.documentID)
                                                            ? Icons.favorite
                                                            : Icons
                                                                .favorite_border,
                                                        background: inHistory(
                                                                'like',
                                                                data.documentID)
                                                            ? Color(0xffFF4343)
                                                            : Colors.white,
                                                        iconColor: inHistory(
                                                                'like',
                                                                data.documentID)
                                                            ? Colors.white
                                                            : Color(
                                                                0xffFF4343)),
                                                    onTap: () {
                                                      inHistory('like',
                                                              data.documentID)
                                                          ? ++like
                                                          : --like;
                                                      updateScrapTrans(
                                                          'like', data);

                                                      setTrans(() {});
                                                    },
                                                  ),
                                                  GestureDetector(
                                                    child: iconWithLabel(
                                                        pick.abs().toString(),
                                                        background: inHistory(
                                                                'picked',
                                                                data.documentID)
                                                            ? Color(0xff0099FF)
                                                            : Colors.white,
                                                        iconColor: inHistory(
                                                                'picked',
                                                                data.documentID)
                                                            ? Colors.white
                                                            : Color(0xff0099FF),
                                                        icon: Icons
                                                            .move_to_inbox),
                                                    onTap: () {
                                                      inHistory('picked',
                                                              data.documentID)
                                                          ? ++pick
                                                          : --pick;
                                                      updateScrapTrans(
                                                          'picked', data);

                                                      setTrans(() {});
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
                                                      Scaffold.of(context)
                                                          .showBottomSheet(
                                                        (BuildContext
                                                                context) =>
                                                            commentSheet(data),
                                                        backgroundColor:
                                                            Colors.transparent,
                                                      );
                                                    },
                                                  )
                                                  // Container(
                                                  //   decoration: BoxDecoration(
                                                  //       color: Colors.white,
                                                  //       borderRadius: BorderRadius.circular(a.width)),
                                                  //   child: Row(
                                                  //     mainAxisAlignment: MainAxisAlignment.center,
                                                  //     children: <Widget>[
                                                  //       writer != 'สุ่มโดย Scrap'
                                                  //           ? InkWell(
                                                  //               child: Container(
                                                  //                 margin: EdgeInsets.only(
                                                  //                     right: a.width / 42),
                                                  //                 width: a.width / 6,
                                                  //                 height: a.width / 6,
                                                  //                 child: Column(
                                                  //                     mainAxisAlignment:
                                                  //                         MainAxisAlignment.center,
                                                  //                     children: <Widget>[
                                                  //                       Icon(
                                                  //                         Icons.whatshot,
                                                  //                         color: Colors.grey[600],
                                                  //                         size: a.width / 14,
                                                  //                       ),
                                                  //                       Text(
                                                  //                         "เผา",
                                                  //                         style: TextStyle(
                                                  //                             color: Colors.grey[600],
                                                  //                             fontSize: a.width / 25),
                                                  //                       )
                                                  //                     ]),
                                                  //               ),
                                                  //               onTap: () async {
                                                  //                 await burn(id);
                                                  //                 Navigator.pop(context);
                                                  //                 Taoast().toast('คุณได้เผากระดาษไปแล้ว');
                                                  //               },
                                                  //             )
                                                  //           : SizedBox(),
                                                  //       InkWell(
                                                  //         child: Container(
                                                  //           margin: EdgeInsets.only(right: a.width / 40),
                                                  //           width: a.width / 6,
                                                  //           height: a.width / 6,
                                                  //           child: Column(
                                                  //               mainAxisAlignment:
                                                  //                   MainAxisAlignment.center,
                                                  //               children: <Widget>[
                                                  //                 Image.asset('assets/garbage_grey.png',
                                                  //                     width: a.width / 14,
                                                  //                     height: a.width / 14,
                                                  //                     fit: BoxFit.cover),
                                                  //                 Text(
                                                  //                   "ทิ้งไว้",
                                                  //                   style: TextStyle(
                                                  //                       color: Colors.grey[600],
                                                  //                       fontSize: a.width / 25),
                                                  //                 )
                                                  //               ]),
                                                  //         ),
                                                  //         onTap: () {
                                                  //           Navigator.pop(context);
                                                  //         },
                                                  //       ),
                                                  //       InkWell(
                                                  //         child: Container(
                                                  //           width: a.width / 6,
                                                  //           height: a.width / 6,
                                                  //           child: Column(
                                                  //               mainAxisAlignment:
                                                  //                   MainAxisAlignment.center,
                                                  //               children: <Widget>[
                                                  //                 Icon(
                                                  //                   Icons.save_alt,
                                                  //                   color: Colors.grey[600],
                                                  //                   size: a.width / 14,
                                                  //                 ),
                                                  //                 Text(
                                                  //                   "เก็บไว้",
                                                  //                   style: TextStyle(
                                                  //                       color: Colors.grey[600],
                                                  //                       fontSize: a.width / 25),
                                                  //                 )
                                                  //               ]),
                                                  //         ),
                                                  //         onTap: () async {
                                                  //           Navigator.pop(context);
                                                  //           await pickScrap(
                                                  //               id, text, '$time $date', writer);
                                                  //         },
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: screenWidthDp / 42),
                                              child: GestureDetector(
                                                child: iconWithLabel('ต่อไป',
                                                    iconColor:
                                                        Color(0xff000000),
                                                    icon: Icons.forward),
                                                onTap: () {
                                                  counter.count += 1;
                                                  allScrap.remove(data);
                                                  markers.remove(MarkerId(
                                                      data.documentID));
                                                  if (allScrap.isNotEmpty &&
                                                      allScrap.length > 0) {
                                                    setDialog(() =>
                                                        data = allScrap.first);
                                                    streamLimit.add(
                                                        16 - allScrap.length);
                                                  } else {
                                                    Taoast()
                                                        .toast('กระดาษหมดแล้ว');
                                                  }
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
                        Expanded(
                          child: AdmobBanner(
                              adUnitId: AdmobService().getBannerAdId(),
                              adSize: AdmobBannerSize.FULL_BANNER),
                        )
                      ])),
            ));
      });
    }));
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

  burn(String scrapID) async {
    await Firestore.instance
        .collection('Scraps')
        .document('hatyai')
        .collection('scrapsPosition')
        .document(scrapID)
        .updateData({
      'burned': FieldValue.arrayUnion([widget.uid])
    });
  }

  pickScrap(Map scrap, {bool cancel = false}) {
    if (cancel) {
      Firestore.instance
          .collection('Users')
          .document(widget.uid)
          .collection('scrapCollection')
          .document(scrap['id'])
          .delete();
    } else {
      scrap['picker'] = widget.uid;
      scrap['timeStamp'] = FieldValue.serverTimestamp();
      Firestore.instance
          .collection('Users')
          .document(widget.uid)
          .collection('scrapCollection')
          .document(scrap['id'])
          .setData(scrap);
    }
  }

  @override
  dispose() {
    subLimit?.cancel();
    streamLocation?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    _createMarkerImageFromAsset(context);
    _createScrapImageFromAsset(context);
    screenutilInit(context);
    return currentLocation == null
        ? gpsCheck(a, 'กรุณาตรวจสอบ GPS ของคุณ')
        : Scaffold(
            backgroundColor: Colors.grey[900],
            body: Stack(
              children: <Widget>[
                Container(
                  color: Colors.grey[900],
                  width: a.width,
                  height: a.height,
                  child: loadFin
                      ? GoogleMap(
                          myLocationButtonEnabled: false,
                          myLocationEnabled: false,
                          onMapCreated: onMapCreated,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(currentLocation?.latitude ?? 0,
                                  currentLocation?.longitude ?? 0),
                              zoom: 18.5,
                              tilt: 90),
                          markers: Set<Marker>.of(markers.values),
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
                //  Positioned(left: -56, bottom: a.height / 3.6, child: slider())
              ],
            ));
  }

  Widget gpsCheck(Size a, String text) {
    return Center(
      child: Container(
        width: a.width / 1.2,
        height: a.width / 3.2,
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                width: a.width / 3.2,
                height: a.width / 3.2,
                child: FlareActor(
                  'assets/paper_loading.flr',
                  animation: 'Untitled',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  text,
                  style: TextStyle(fontSize: a.width / 16, color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }

  cameraAnime2(GoogleMapController controller, double howClose) {
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            currentLocation?.latitude ?? 0, currentLocation?.longitude ?? 0),
        zoom: howClose,
        bearing: 0.0,
        tilt: 90)));
  }
  /*
         Set id = {};
            List scraps = [];
            for (var usersID in snap.data['id']) {
              id.add(usersID);
              for (var scrap in snap.data['scraps'][usersID]) {
                scraps.add(scrap);
              }
            } */

  changeMapMode() {
    getJsonFile("assets/mapStyle.json").then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    this.mapController.setMapStyle(mapStyle);
  }

  void onMapCreated(GoogleMapController controller) {
    this.mapController = controller;
    changeMapMode();
    if (this.mounted) {
      updateMap(currentLocation);
      subLimit = streamLimit.listen((value) {
        if (value > 0) addMoreScrap(value);
      });
      addMoreScrap(16);
    }
    streamLocation.onData((position) {
      if (this.mounted) {
        userMarker(position.latitude, position.longitude);
      }
    });
  }

  updateMap(Position location) {
    userMarker(location.latitude, location.longitude);
    _animateToUser(position: location);
  }

  void _updateMarkers(List<DocumentSnapshot> documentList, Position position) {
    userMarker(position.latitude, position.longitude);
    allScrap.addAll(documentList);
    documentList.forEach((DocumentSnapshot document) {
      var data = document.data;
      GeoPoint loca = data['position']['geopoint'];
      if (data['uid'] != widget.uid) {
        _addMarker(loca.latitude, loca.longitude, document, data['uid']);
      }
    });
  }

  _animateToUser({Position position}) async {
    var pos = await Geolocator().getCurrentPosition();
    this
        .mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(
            position == null ? pos.latitude : position.latitude,
            position == null ? pos.longitude : position.longitude,
          ),
          zoom: 16.9,
          tilt: 90.0,
        )));
  }

  addMoreScrap(int limit) async {
    var pos = await Geolocator().getCurrentPosition();
    var ref = recentScrap == null
        ? Firestore.instance
            .collection('Scraps/hatyai/test')
            .orderBy('scrap.time', descending: true)
            .limit(limit)
        : Firestore.instance
            .collection('Scraps/hatyai/test')
            .orderBy('scrap.time', descending: true)
            .startAfterDocument(recentScrap)
            .limit(limit);
    var doc = await ref.getDocuments();
    if (doc.documents.length > 0) {
      recentScrap = doc.documents.last;
      _updateMarkers(doc.documents, pos);
    }
  }

  cameraAnime(GoogleMapController controller, double lat, double lng) {
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, lng), zoom: 18.5, bearing: 0.0, tilt: 90)));
  }

  void _addMarker(
      double lat, double lng, DocumentSnapshot doc, String writerUid) {
    final MarkerId markerId = MarkerId(doc.documentID);
    final counter = Provider.of<AdsCounterProvider>(context, listen: false);
    var date = doc['scrap']['time'].toDate();
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      icon: scrapIcon,
      onTap: () async {
        try {
          allScrap.remove(doc);
          markers.remove(markerId);
          setState(() {});
          dialog(doc);
          counter.count += 1;
          // scrap.increaseTransaction(writerUid, 'read');
          // increasHistTran(writerUid, '${date.year},${date.month},${date.day}',
          //     doc.documentID);
          streamLimit.add(16 - allScrap.length);
        } catch (e) {
          print(e.toString());
          error(context,
              'เกิดข้อผิดพลาด ไม่ทราบสาเหตุกรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต');
        }
      },
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  userMarker(double lat, double lng) {
    MarkerId markerId = MarkerId('user');
    LatLng position = LatLng(lat, lng);
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      icon: _curcon,
      draggable: false,
    );
    if (this.mounted) {
      setState(() {
        markers[markerId] = marker;
      });
    }
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_curcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/yourlocation-icon-l.png')
          .then(_updateBitmap);
    }
  }

  Future<void> _createScrapImageFromAsset(BuildContext context) async {
    if (scrapIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration,
              checkPlatform
                  ? 'assets/paper-mini01.png'
                  : 'assets/paper-mini01.png')
          .then(_updateBitScrap);
    }
  }

  void _updateBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _curcon = bitmap;
    });
  }

  void _updateBitScrap(BitmapDescriptor bitmap) {
    setState(() {
      scrapIcon = bitmap;
    });
  }

  increasHistTran(String uid, String date, String docID) {
    Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('history')
        .document(date)
        .updateData({docID: FieldValue.increment(1)});
  }
}
