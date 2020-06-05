import 'dart:math';
import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/provider/AdsCounter.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/widget/CountDownText.dart';
import 'package:scrap/widget/LoadNoBlur.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/ads.dart';
import 'package:scrap/widget/beforeburn.dart';
import 'package:scrap/widget/sheets/CommentSheet.dart';
import 'package:scrap/widget/sheets/MapSheet.dart';
import 'package:scrap/widget/showdialogreport.dart';

class ScrapFeedDialog extends StatefulWidget {
  final List scraps;
  final int currentIndex;
  ScrapFeedDialog({@required this.scraps, @required this.currentIndex});
  @override
  _ScrapFeedDialogState createState() => _ScrapFeedDialogState();
}

class _ScrapFeedDialogState extends State<ScrapFeedDialog> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool initHistoryFinish = false;
  int adsRate = 0, index = 0;
  final random = Random();
  Map<String, List> history = {};
  List allScrap = [];

  void randomAdsRate() {
    adsRate = 3;
    adsRate += random.nextInt(2) + 1;
  }

  bool inHistory(String field, String id) {
    return history[field].contains(id);
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

  @override
  void initState() {
    initUserHistory();
    randomAdsRate();
    super.initState();
  }

  Future<void> initUserHistory() async {
    allScrap = widget.scraps;
    index = widget.currentIndex;
    history['like'] = await cacheHistory.readOnlyId(field: 'like') ?? [];
    history['picked'] = await cacheHistory.readOnlyId(field: 'picked') ?? [];
    history['burn'] = await cacheHistory.readOnlyId(field: 'burn') ?? [];
    setState(() => initHistoryFinish = true);
  }

  @override
  void didUpdateWidget(ScrapFeedDialog oldWidget) {
    if (oldWidget.scraps != widget.scraps) allScrap = widget.scraps;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<AdsCounterProvider>(context, listen: false);
    screenutilInit(context);
    var data = allScrap[index];
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: (screenWidthDp - screenWidthDp / 1.04) / 2),
                  width: screenWidthDp,
                  height: screenHeightDp,
                  child: FutureBuilder(
                      future: scrapTransaction(data.documentID),
                      builder: (context, AsyncSnapshot<DataSnapshot> event) {
                        if (event.hasData && event.data?.value != null) {
                          var trans = event.data;
                          var like = trans.value['like'];
                          var pick = trans.value['picked'];
                          return Column(
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
                                    : SizedBox(height: screenHeightDp / 42),
                                counter.count == adsRate
                                    ? Expanded(
                                        child: Container(
                                          width: screenWidthDp / 1.04,
                                          child: AdmobBanner(
                                              adUnitId: AdmobService()
                                                  .getBannerAdId(),
                                              adSize:
                                                  AdmobBannerSize.FULL_BANNER),
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          GestureDetector(
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  child: Image.asset(
                                                    'assets/paperscrap.jpg',
                                                    width: screenWidthDp / 1.04,
                                                    height: screenWidthDp /
                                                        1.04 *
                                                        1.115,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.only(
                                                      left: 25, right: 25),
                                                  height: screenWidthDp /
                                                      1.04 *
                                                      1.115,
                                                  width: screenWidthDp / 1.04,
                                                  child: Text(
                                                    data['scrap']['text'],
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
                                                      height:
                                                          screenWidthDp / 16,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xff000000)
                                                                  .withOpacity(
                                                                      0.47),
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
                                              _scaffoldKey.currentState
                                                  .showBottomSheet(
                                                (context) => MapSheet(
                                                  position: LatLng(
                                                      data['position']
                                                              ['geopoint']
                                                          .latitude,
                                                      data['position']
                                                              ['geopoint']
                                                          .longitude),
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                              );
                                            },
                                          ),
                                          SizedBox(height: screenWidthDp / 21),
                                          Container(
                                            width: screenWidthDp,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: screenWidthDp / 36),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      data['scrap']['writer'] ==
                                                              'ไม่ระบุตัวตน'
                                                          ? 'ใครบางคน'
                                                          : '@${data['scrap']['writer']}',
                                                      style: TextStyle(
                                                          fontSize: s48,
                                                          height: 1.1,
                                                          color: data['scrap'][
                                                                      'writer'] ==
                                                                  'ไม่ระบุตัวตน'
                                                              ? Colors.white
                                                              : Color(
                                                                  0xff26A4FF)),
                                                    ),
                                                    CountDownText(
                                                        startTime: data['scrap']
                                                                ['timeStamp']
                                                            .toDate())
                                                  ],
                                                ),
                                                GestureDetector(
                                                    child: Icon(
                                                        Icons.more_horiz,
                                                        color: Colors.white,
                                                        size: s70),
                                                    onTap: () => showMore(
                                                        context,
                                                        scrap: data))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                SizedBox(height: screenWidthDp / 42),
                                Divider(
                                    color: Color(0xff5D5D5D), thickness: 1.2),
                                SizedBox(height: screenWidthDp / 46),
                                SizedBox(
                                    width: screenWidthDp,
                                    height: screenHeightDp / 9.6,
                                    child: counter.count == adsRate
                                        ? Center(
                                            child: GestureDetector(
                                                child: iconWithLabel('ต่อไป',
                                                    iconColor:
                                                        Color(0xff000000),
                                                    icon: Icons.forward),
                                                onTap: () {
                                                  randomAdsRate();
                                                  counter.count = 0;
                                                  setState(() {});
                                                }))
                                        : StatefulBuilder(builder:
                                            (context, StateSetter setTrans) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                            like
                                                                .abs()
                                                                .toString(),
                                                            icon: inHistory(
                                                                    'like',
                                                                    data
                                                                        .documentID)
                                                                ? Icons.favorite
                                                                : Icons
                                                                    .favorite_border,
                                                            background: inHistory(
                                                                    'like',
                                                                    data
                                                                        .documentID)
                                                                ? Color(
                                                                    0xffFF4343)
                                                                : Colors.white,
                                                            iconColor: inHistory(
                                                                    'like',
                                                                    data
                                                                        .documentID)
                                                                ? Colors.white
                                                                : Color(
                                                                    0xffFF4343)),
                                                        onTap: () {
                                                          if (isExpired(data)) {
                                                            toast.toast(
                                                                'สเเครปนี้ย่อยสลายแล้ว');
                                                          } else {
                                                            scrap.updateScrapTrans(
                                                                'like',
                                                                data,
                                                                context,
                                                                comments: trans
                                                                        .value[
                                                                    'comment']);
                                                            if (inHistory(
                                                                'like',
                                                                data.documentID)) {
                                                              ++like;
                                                              history['like']
                                                                  .remove(data
                                                                      .documentID);
                                                            } else {
                                                              --like;
                                                              history['like']
                                                                  .add(data
                                                                      .documentID);
                                                            }
                                                            setTrans(() {});
                                                          }
                                                        },
                                                      ),
                                                      GestureDetector(
                                                        child: iconWithLabel(
                                                            pick
                                                                .abs()
                                                                .toString(),
                                                            background: inHistory(
                                                                    'picked',
                                                                    data
                                                                        .documentID)
                                                                ? Color(
                                                                    0xff0099FF)
                                                                : Colors.white,
                                                            iconColor: inHistory(
                                                                    'picked',
                                                                    data
                                                                        .documentID)
                                                                ? Colors.white
                                                                : Color(
                                                                    0xff0099FF),
                                                            icon: Icons
                                                                .move_to_inbox),
                                                        onTap: () {
                                                          if (isExpired(data)) {
                                                            scrap.toast(
                                                                'สเเครปนี้ย่อยสลายแล้ว');
                                                          } else {
                                                            scrap
                                                                .updateScrapTrans(
                                                                    'picked',
                                                                    data,
                                                                    context);
                                                            if (inHistory(
                                                                'picked',
                                                                data.documentID)) {
                                                              ++pick;
                                                              history['picked']
                                                                  .remove(data
                                                                      .documentID);
                                                            } else {
                                                              --pick;
                                                              history['picked']
                                                                  .add(data
                                                                      .documentID);
                                                            }
                                                            setTrans(() {});
                                                          }
                                                        },
                                                      ),
                                                      GestureDetector(
                                                        child: iconWithLabel(
                                                            trans?.value[
                                                                    'comment']
                                                                .abs()
                                                                .toString(),
                                                            iconColor: Color(
                                                                    0xff000000)
                                                                .withOpacity(
                                                                    0.83),
                                                            icon: Icons.sms),
                                                        onTap: () {
                                                          Scaffold.of(context)
                                                              .showBottomSheet(
                                                            (BuildContext
                                                                    context) =>
                                                                CommentSheet(
                                                                    scrapSnapshot:
                                                                        data),
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                          );
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right:
                                                          screenWidthDp / 42),
                                                  child: GestureDetector(
                                                    child: iconWithLabel(
                                                        'ต่อไป',
                                                        iconColor:
                                                            Color(0xff000000),
                                                        icon: Icons.forward),
                                                    onTap: () {
                                                      counter.count += 1;
                                                      if (allScrap.isNotEmpty &&
                                                          allScrap.length > 0) {
                                                        index + 1 ==
                                                                allScrap.length
                                                            ? toast.toast(
                                                                'คุณตามทันสแครปทั้งหมดแล้ว')
                                                            : setState(
                                                                () => index++);
                                                      } else {
                                                        toast.toast(
                                                            'คุณตามทันสแครปทั้งหมดแล้ว');
                                                      }
                                                    },
                                                  ),
                                                )
                                              ],
                                            );
                                          })

                                    // }),
                                    ),
                                SizedBox(height: screenWidthDp / 36),
                                counter.count == adsRate
                                    ? SizedBox()
                                    : Expanded(
                                        child: AdmobBanner(
                                            adUnitId:
                                                AdmobService().getBannerAdId(),
                                            adSize:
                                                AdmobBannerSize.FULL_BANNER),
                                      )
                              ]);
                        } else if (event.connectionState ==
                            ConnectionState.waiting) {
                          return Stack(
                            children: <Widget>[
                              Container(
                                margin:
                                    EdgeInsets.only(top: screenHeightDp / 42),
                                width: screenWidthDp / 1.04,
                                height: screenWidthDp / 1.04 * 1.115,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage('assets/paperscrap.jpg'),
                                        fit: BoxFit.cover)),
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
                              ),
                              Center(child: LoadNoBlur())
                            ],
                          );
                        } else {
                          return burntScrap(onNext: () {
                            counter.count += 1;
                            if (allScrap.isNotEmpty && allScrap.length > 0) {
                              index + 1 == allScrap.length
                                  ? toast.toast('คุณตามทันสแครปทั้งหมดแล้ว')
                                  : setState(() => index++);
                            } else
                              toast.toast('คุณตามทันสแครปทั้งหมดแล้ว');
                          });
                        }
                      })),
              initHistoryFinish ? SizedBox() : Loading()
            ],
          ),
        ));
  }

  Widget burntScrap({@required Function onNext}) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: screenHeightDp / 42),
            child: Stack(
              children: <Widget>[
                Container(
                    width: screenWidthDp / 1.04,
                    height: screenWidthDp / 1.04 * 1.115,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/paperscrap.jpg'),
                            fit: BoxFit.cover)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3.2, sigmaY: 3.2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.whatshot,
                              size: screenWidthDp / 3,
                              color: Color(0xffFF8F3A)),
                          Text("สแครปนี้โดนเผาแล้ว !",
                              style: TextStyle(
                                  fontSize: s54,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    child: Container(
                      width: screenWidthDp / 16,
                      height: screenWidthDp / 16,
                      decoration: BoxDecoration(
                          color: Color(0xff000000).withOpacity(0.47),
                          borderRadius:
                              BorderRadius.circular(screenWidthDp / 18)),
                      child: Icon(Icons.close, color: Colors.white, size: s42),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: screenWidthDp / 21),
          SizedBox(height: screenWidthDp / 42),
          Divider(color: Color(0xff5D5D5D), thickness: 1.2),
          SizedBox(height: screenWidthDp / 46),
          Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 36),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'กระดาษแผ่นนี้ถูกเผาแล้ว🔥',
                    style: TextStyle(color: Colors.white, fontSize: s46),
                  ),
                  GestureDetector(
                    child: iconWithLabel('ต่อไป',
                        iconColor: Color(0xff000000), icon: Icons.forward),
                    onTap: onNext,
                  ),
                ],
              )),
          SizedBox(height: screenWidthDp / 36),
          Expanded(
            child: AdmobBanner(
                adUnitId: AdmobService().getBannerAdId(),
                adSize: AdmobBannerSize.FULL_BANNER),
          )
        ]);
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
                                  history['burn'].add(scrap.documentID);
                                  showdialogBurn(context);
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
}
