import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/method/Navigator.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/widget/CountDownText.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/ads.dart';
import 'package:scrap/widget/sheets/CommentSheet.dart';
import 'package:scrap/widget/sheets/MapSheet.dart';
import 'package:scrap/widget/showdialogreport.dart';

class ScrapDialog extends StatefulWidget {
  final DocumentSnapshot data;
  ScrapDialog({@required this.data});
  @override
  _ScrapDialogState createState() => _ScrapDialogState();
}

class _ScrapDialogState extends State<ScrapDialog> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, List> history = {};

  bool inHistory(String field, String id) {
    return history[field].contains(id);
  }

  Future<DataSnapshot> scrapTransaction(String docId) async {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    var ref = scrapAll.reference().child('scraps').child(docId);
    history['like'] = await cacheHistory.readOnlyId(field: 'like') ?? [];
    history['picked'] = await cacheHistory.readOnlyId(field: 'picked') ?? [];
    return ref.once();
  }

  bool isExpired(DocumentSnapshot data) {
    DateTime startTime = data['scrap']['timeStamp'].toDate();
    return DateTime(startTime.year, startTime.month, startTime.day + 1,
            startTime.hour, startTime.second)
        .difference(DateTime.now())
        .isNegative;
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: (screenWidthDp - screenWidthDp / 1.04) / 2),
              width: screenWidthDp,
              height: screenHeightDp,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // counter.count == adsRate
                    //     ? SizedBox(
                    //         width: a.width / 1.04,
                    //         height: a.width / 1.04 * 1.29,
                    //         child: Stack(
                    //           children: <Widget>[
                    //             Container(
                    //               width: a.width / 1.04,
                    //               height: a.width / 1.04 * 1.29,
                    //               child: AdmobBanner(
                    //                   adUnitId:
                    //                       AdmobService().getBannerAdId(),
                    //                   adSize: AdmobBannerSize.FULL_BANNER),
                    //             ),
                    //             Positioned(
                    //                 top: 12,
                    //                 right: 12,
                    //                 child: GestureDetector(
                    //                     child: Container(
                    //                       width: screenWidthDp / 16,
                    //                       height: screenWidthDp / 16,
                    //                       decoration: BoxDecoration(
                    //                           color: Color(0xff000000)
                    //                               .withOpacity(0.47),
                    //                           borderRadius:
                    //                               BorderRadius.circular(
                    //                                   screenWidthDp / 18)),
                    //                       child: Icon(Icons.close,
                    //                           color: Colors.white,
                    //                           size: s42),
                    //                     ),
                    //                     onTap: () {
                    //                       randomAdsRate();
                    //                       counter.count = 0;
                    //                       Navigator.pop(context);
                    //                     }))
                    //           ],
                    //         ),
                    //       )
                    //     :
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                child: Image.asset(
                                  'assets/paper-readed.png',
                                  width: screenWidthDp / 1.04,
                                  height: screenWidthDp / 1.04 * 1.115,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 25, right: 25),
                                height: screenWidthDp / 1.04 * 1.115,
                                width: screenWidthDp / 1.04,
                                child: Text(
                                  widget.data['scrap']['text'],
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
                                        color:
                                            Color(0xff000000).withOpacity(0.47),
                                        borderRadius: BorderRadius.circular(
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
                          onDoubleTap: () {
                            _scaffoldKey.currentState.showBottomSheet(
                              (context) => MapSheet(
                                position: LatLng(
                                    widget
                                        .data['position']['geopoint'].latitude,
                                    widget.data['position']['geopoint']
                                        .longitude),
                              ),
                              backgroundColor: Colors.transparent,
                            );
                          },
                        ),
                        SizedBox(height: screenWidthDp / 21),
                        Container(
                          width: screenWidthDp,
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidthDp / 36),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.data['scrap']['writer'] ==
                                            'ไม่ระบุตัวตน'
                                        ? 'ใครบางคน'
                                        : '@${widget.data['scrap']['writer']}',
                                    style: TextStyle(
                                        fontSize: s48,
                                        height: 1.1,
                                        color: widget.data['scrap']['writer'] ==
                                                'ไม่ระบุตัวตน'
                                            ? Colors.white
                                            : Color(0xff26A4FF)),
                                  ),
                                  CountDownText(
                                      startTime: widget.data['scrap']
                                              ['timeStamp']
                                          .toDate())
                                ],
                              ),
                              GestureDetector(
                                  child: Icon(Icons.more_horiz,
                                      color: Colors.white, size: s70),
                                  onTap: () => showMore(context,
                                      writerUid: widget.data['uid']))
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenWidthDp / 42),
                    Divider(color: Color(0xff5D5D5D), thickness: 1.2),
                    SizedBox(height: screenWidthDp / 46),
                    SizedBox(
                      width: screenWidthDp,
                      height: screenHeightDp / 9.6,
                      child:
                          // counter.count == adsRate
                          //     ? Center(
                          //         child: GestureDetector(
                          //             child: iconWithLabel('ต่อไป',
                          //                 iconColor: Color(0xff000000),
                          //                 icon: Icons.forward),
                          //             onTap: () {
                          //               randomAdsRate();
                          //               counter.count = 0;
                          //               setDialog(() {});
                          //             }))
                          //     :
                          FutureBuilder(
                              future: scrapTransaction(widget.data.documentID),
                              builder: (context, event) {
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
                                                            'like',
                                                            widget.data
                                                                .documentID)
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    background: inHistory(
                                                            'like',
                                                            widget.data
                                                                .documentID)
                                                        ? Color(0xffFF4343)
                                                        : Colors.white,
                                                    iconColor: inHistory(
                                                            'like',
                                                            widget.data
                                                                .documentID)
                                                        ? Colors.white
                                                        : Color(0xffFF4343)),
                                                onTap: () {
                                                  if (isExpired(widget.data)) {
                                                    scrap.toast(
                                                        'สเเครปนี้ย่อยสลายแล้ว');
                                                  } else {
                                                    scrap.updateScrapTrans(
                                                        'like',
                                                        widget.data,
                                                        context,
                                                        comments: trans
                                                            .value['comment']);
                                                    if (inHistory(
                                                        'like',
                                                        widget
                                                            .data.documentID)) {
                                                      ++like;
                                                      history['like'].remove(
                                                          widget
                                                              .data.documentID);
                                                    } else {
                                                      --like;
                                                      history['like'].add(widget
                                                          .data.documentID);
                                                    }
                                                    setTrans(() {});
                                                  }
                                                },
                                              ),
                                              GestureDetector(
                                                child: iconWithLabel(
                                                    pick.abs().toString(),
                                                    background: inHistory(
                                                            'picked',
                                                            widget.data
                                                                .documentID)
                                                        ? Color(0xff0099FF)
                                                        : Colors.white,
                                                    iconColor: inHistory(
                                                            'picked',
                                                            widget.data
                                                                .documentID)
                                                        ? Colors.white
                                                        : Color(0xff0099FF),
                                                    icon: Icons.move_to_inbox),
                                                onTap: () {
                                                  if (isExpired(widget.data)) {
                                                    toast.toast(
                                                        'สเเครปนี้ย่อยสลายแล้ว');
                                                  } else {
                                                    scrap.updateScrapTrans(
                                                        'picked',
                                                        widget.data,
                                                        context);
                                                    if (inHistory(
                                                        'picked',
                                                        widget
                                                            .data.documentID)) {
                                                      ++pick;
                                                    } else {
                                                      --pick;
                                                    }
                                                    setTrans(() {});
                                                  }
                                                },
                                              ),
                                              GestureDetector(
                                                child: iconWithLabel(
                                                    trans?.value['comment']
                                                        .abs()
                                                        .toString(),
                                                    iconColor: Color(0xff000000)
                                                        .withOpacity(0.83),
                                                    icon: Icons.sms),
                                                onTap: () {
                                                  Scaffold.of(context)
                                                      .showBottomSheet(
                                                    (BuildContext context) =>
                                                        CommentSheet(
                                                            scrapSnapshot:
                                                                widget.data),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                        ),
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
  }

  void showMore(context, {@required String writerUid}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            height: appBarHeight * 3.4,
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
                  margin: EdgeInsets.only(
                    bottom: appBarHeight - 20,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                              onTap: () {},
                            ),
                            Text(
                              'บล็อคผู้ใช้',
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
                                report.targetId = writerUid;
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
                Positioned(bottom: 0, child: Container(child: Ads())),
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
