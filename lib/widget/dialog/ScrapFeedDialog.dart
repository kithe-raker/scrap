import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'dart:math' as math;
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scrap/assets/PaperTexture.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/widget/CountDownText.dart';
import 'package:scrap/widget/LoadNoBlur.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/beforeburn.dart';
import 'package:scrap/widget/sheets/CommentSheet.dart';
import 'package:scrap/widget/sheets/MapSheet.dart';
import 'package:scrap/widget/showdialogreport.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';

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
  // StreamSubscription loadStatus, loadFollowStatus;
  int index = 0;
  final random = Random();
  Map<String, List> history = {'like': [], 'picked': [], 'burn': []};
  List allScrap = [];
  //adsRate = 0,
  // void randomAdsRate() {
  //   adsRate = 3;
  //   adsRate += random.nextInt(2) + 1;
  // }

  bool inHistory(String field, String id) {
    return history[field].contains(id);
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
    // if (widget.topScrap) {
    //   loadStatus = loadMoreTopScrap
    //       .listen((value) => setState(() => initHistoryFinish = !value));
    // } else {
    //   loadFollowStatus = loadMoreFollowingScrap
    //       .listen((value) => setState(() => initHistoryFinish = !value));
    // }
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
  void dispose() {
    // widget.topScrap ? loadStatus.cancel() : loadFollowStatus.cancel();
    super.dispose();
  }

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    // final counter = Provider.of<AdsCounterProvider>(context, listen: false);
    screenutilInit(context);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              StatefulBuilder(builder: (context, StateSetter setDialog) {
                var data = allScrap[index];
                return Container(
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
                                  // counter.count == adsRate
                                  //     ? Center(
                                  //         child: Text(
                                  //         'โฆษณา',
                                  //         style: TextStyle(
                                  //             fontSize: s42,
                                  //             color: Colors.white,
                                  //             fontWeight: FontWeight.bold),
                                  //       ))
                                  //     :
                                  SizedBox(height: screenHeightDp / 42),
                                  // counter.count == adsRate
                                  //     ? Expanded(
                                  //         child: Container(
                                  //           width: screenWidthDp / 1.04,
                                  //           child: AdmobBanner(
                                  //               adUnitId: AdmobService()
                                  //                   .getBannerAdId(),
                                  //               adSize:
                                  //                   AdmobBannerSize.FULL_BANNER),
                                  //         ),
                                  //       )
                                  //     :
                                  Screenshot(
                                    controller: screenshotController,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        GestureDetector(
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                width: screenWidthDp / 1.04,
                                                height: screenWidthDp /
                                                    1.04 *
                                                    1.115,
                                                child: SvgPicture.asset(
                                                    'assets/${texture.textures[data['scrap']['texture'] ?? 0]}',
                                                    fit: BoxFit.cover),
                                                //  child: Image.asset('assets/paperscrap.jpg'),
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
                                              context: _scaffoldKey
                                                  .currentState.context,
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
                                          width: screenWidthDp,
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
                                                  child: Transform(
                                                    alignment: Alignment.center,
                                                    transform:
                                                        Matrix4.rotationY(
                                                            math.pi),
                                                    child: Icon(
                                                      Icons.reply,
                                                      color: Colors.white,
                                                      size: s65,
                                                    ),
                                                  ),
                                                  onTap: () => showMore(context,
                                                      scrap: data))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: screenWidthDp / 42),
                                  Divider(
                                      color: Color(0xff5D5D5D), thickness: 1.2),
                                  SizedBox(height: screenWidthDp / 46),
                                  SizedBox(
                                      width: screenWidthDp,
                                      height: screenHeightDp / 9.6,
                                      child:
                                          //  counter.count == adsRate
                                          //     ? Center(
                                          //         child: GestureDetector(
                                          //             child: iconWithLabel('ต่อไป',
                                          //                 iconColor:
                                          //                     Color(0xff000000),
                                          //                 icon: Icons.forward),
                                          //             onTap: () {
                                          //               randomAdsRate();
                                          //               counter.count = 0;
                                          //               setState(() {});
                                          //             }))
                                          //     :
                                          StatefulBuilder(builder:
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
                                                      child: iconfrommilla(
                                                          inHistory(
                                                                  'like',
                                                                  data
                                                                      .documentID)
                                                              ? 'assets/heart-fill-icon.svg'
                                                              : 'assets/heart-icon.svg',
                                                          like.abs().toString(),
                                                          iconColor: inHistory(
                                                                  'like',
                                                                  data
                                                                      .documentID)
                                                              ? Colors.white
                                                              : Colors.red,
                                                          backgroundColor:
                                                              inHistory(
                                                                      'like',
                                                                      data
                                                                          .documentID)
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .white),
                                                      onTap: () {
                                                        scrap.updateScrapTrans(
                                                            'like',
                                                            doc: data);
                                                        if (inHistory('like',
                                                            data.documentID)) {
                                                          ++like;
                                                          history['like']
                                                              .remove(data
                                                                  .documentID);
                                                        } else {
                                                          --like;
                                                          history['like'].add(
                                                              data.documentID);
                                                        }
                                                        setTrans(() {});
                                                      }),
                                                  GestureDetector(
                                                      child: iconfrommilla(
                                                          inHistory(
                                                                  'picked',
                                                                  data
                                                                      .documentID)
                                                              ? 'assets/keep-icon.svg'
                                                              : 'assets/keep-icon.svg',
                                                          pick.abs().toString(),
                                                          iconColor: inHistory(
                                                                  'picked',
                                                                  data
                                                                      .documentID)
                                                              ? Colors.white
                                                              : Colors.blue,
                                                          backgroundColor:
                                                              inHistory(
                                                                      'picked',
                                                                      data
                                                                          .documentID)
                                                                  ? Colors.blue
                                                                  : Colors
                                                                      .white),
                                                      onTap: () {
                                                        scrap.updateScrapTrans(
                                                            'picked',
                                                            doc: data,
                                                            comments:
                                                                trans.value[
                                                                    'comment']);
                                                        if (inHistory('picked',
                                                            data.documentID)) {
                                                          ++pick;
                                                          history['picked']
                                                              .remove(data
                                                                  .documentID);
                                                        } else {
                                                          --pick;
                                                          history['picked'].add(
                                                              data.documentID);
                                                        }
                                                        setTrans(() {});
                                                      }),
                                                  GestureDetector(
                                                    child: iconfrommilla(
                                                        'assets/comment-icon.svg',
                                                        trans?.value['comment']
                                                            .abs()
                                                            .toString(),
                                                        iconColor: Colors.black,
                                                        backgroundColor:
                                                            Colors.white),
                                                    onTap: () {
                                                      Scaffold.of(context)
                                                          .showBottomSheet(
                                                        (BuildContext
                                                                context) =>
                                                            CommentSheet(
                                                                doc: data),
                                                        backgroundColor:
                                                            Colors.transparent,
                                                      );
                                                    },
                                                  )
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
                                                  // counter.count += 1;
                                                  if (allScrap.isNotEmpty &&
                                                      allScrap.length > 0) {
                                                    index + 1 == allScrap.length
                                                        ? toast.toast(
                                                            'คุณตามทันสแครปทั้งหมดแล้ว')
                                                        : setDialog(
                                                            () => index++);

                                                    // if (widget.topScrap &&
                                                    //     index ==
                                                    //         allScrap.length - 2)
                                                    //   loadMoreTopScrap
                                                    //       .add(true);
                                                    // else
                                                    //   loadMoreFollowingScrap
                                                    //       .add(true);
                                                  } else
                                                    toast.toast(
                                                        'คุณตามทันสแครปทั้งหมดแล้ว');
                                                },
                                              ),
                                            )
                                          ],
                                        );
                                      })),
                                  // SizedBox(height: screenWidthDp / 36),
                                  // counter.count == adsRate
                                  //     ? SizedBox()
                                  //     :
                                  // Expanded(
                                  //   child: AdmobBanner(
                                  //       adUnitId:
                                  //           AdmobService().getBannerAdId(),
                                  //       adSize: AdmobBannerSize.FULL_BANNER),
                                  // )
                                ]);
                          } else if (event.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              margin: EdgeInsets.only(top: screenHeightDp / 42),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width: screenWidthDp / 1.04,
                                    height: screenWidthDp / 1.04 * 1.115,
                                    child: SvgPicture.asset(
                                        'assets/${texture.textures[data['scrap']['texture'] ?? 0]}',
                                        fit: BoxFit.cover),
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
                              ),
                            );
                          } else {
                            return burntScrap(onNext: () {
                              // counter.count += 1;
                              if (allScrap.isNotEmpty && allScrap.length > 0) {
                                index + 1 == allScrap.length
                                    ? toast.toast('คุณตามทันสแครปทั้งหมดแล้ว')
                                    : setDialog(() => index++);
                                // if (widget.topScrap &&
                                //     index == allScrap.length - 2)
                                //   loadMoreTopScrap.add(true);
                                // else
                                //   loadMoreFollowingScrap.add(true);
                              } else
                                toast.toast('คุณตามทันสแครปทั้งหมดแล้ว');
                            });
                          }
                        }));
              }),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: AdmobBanner(
                      adUnitId: AdmobService().getBannerAdId(),
                      adSize: AdmobBannerSize.FULL_BANNER),
                ),
              ),
              initHistoryFinish ? SizedBox() : Loading()
            ],
          ),
        ));
  }

  Widget iconfrommilla(
    String asset,
    String label, {
    //Color background = Colors.white,
    @required Color iconColor,
    @required Color backgroundColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(screenWidthDp / 40),
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(screenWidthDp)),
          //  child:
          child: SvgPicture.asset(
            asset,
            color: iconColor,
            height: screenWidthDp / 15,
            width: screenWidthDp / 15,
          ),
        ),
        Text(
          label,
          style: TextStyle(
              color: Color(0xffff5f5f5),
              fontSize: s42,
              height: 1.2,
              fontWeight: FontWeight.bold),
        )
      ],
    );
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
              color: background,
              borderRadius: BorderRadius.circular(screenWidthDp / 8)),
          child: Icon(icon, color: iconColor, size: s46),
        ),
        Text(label,
            style: TextStyle(
                color: Colors.white,
                fontSize: s42,
                height: 1.2,
                fontWeight: FontWeight.bold))
      ],
    );
  }

  void showMore(context, {@required DocumentSnapshot scrap}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            height: screenWidthDp / 1.1,
            decoration: BoxDecoration(
              color: Color(0xff202020),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
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
                  margin: EdgeInsets.only(bottom: screenWidthDp / 15),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //  SizedBox(
                        //   height: screenWidthDp / 20,
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: screenWidthDp / 25,
                            ),
                            Text(
                              'แบ่งปันไปยัง',
                              style: TextStyle(
                                fontSize: s48,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        Container(
                          padding: EdgeInsets.only(top: screenWidthDp / 25),
                          width: screenWidthDp,
                          height: screenWidthDp / 3.9,
                          child: ListView(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            physics: AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              // story ig
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    GestureDetector(
                                        onTap: () async {
                                          SocialShare
                                                  .checkInstalledAppsForShare()
                                              .then((data) async {
                                            data['instagram'] == true
                                                ? await screenshotController
                                                    .capture(pixelRatio: 1.5)
                                                    .then((image) async {
                                                    SocialShare.shareInstagramStory(
                                                        image.path,
                                                        "#212121",
                                                        "#000000",
                                                        "https://scrap.bualoitech.com/");
                                                  })
                                                : Fluttertoast.showToast(
                                                    msg: "โหลดไอจีก่อนฮะ",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                  );
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          height: screenWidthDp / 7,
                                          width: screenWidthDp / 7,
                                          child: SvgPicture.asset(
                                            'assets/ig-story-icon.svg',
                                          ),
                                        )),
                                    Text(
                                      'stories',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: s42,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // facebook story
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    GestureDetector(
                                        onTap: () async {
                                          SocialShare
                                                  .checkInstalledAppsForShare()
                                              .then((data) async {
                                            data['facebook'] == true
                                                ? await screenshotController
                                                    .capture(pixelRatio: 1.5)
                                                    .then((image) async {
                                                    {
                                                      Platform.isAndroid
                                                          ? SocialShare.shareFacebookStory(
                                                                  image.path,
                                                                  "#212121",
                                                                  "#000000",
                                                                  "https://scrap.bualoitech.com/",
                                                                  appId:
                                                                      "152617042778122")
                                                              .then((data) {
                                                              print(data);
                                                            })
                                                          : SocialShare
                                                                  .shareFacebookStory(
                                                                      image
                                                                          .path,
                                                                      "#212121",
                                                                      "#000000",
                                                                      "https://scrap.bualoitech.com/")
                                                              .then((data) {
                                                              print(data);
                                                            });
                                                    }
                                                  })
                                                : Fluttertoast.showToast(
                                                    msg: "โหลดเฟซบุ๊คก่อนฮะ",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                  );
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          height: screenWidthDp / 7,
                                          width: screenWidthDp / 7,
                                          child: SvgPicture.asset(
                                            'assets/facebook-icon.svg',
                                          ),
                                        )),
                                    Text(
                                      'facebook',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: s42,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Divider(
                          color: Color(0xfffa5a5a5),
                          indent: screenWidthDp / 25,
                          endIndent: screenWidthDp / 25,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: screenWidthDp / 25,
                            ),
                            Text(
                              'เพิ่มเติม',
                              style: TextStyle(
                                fontSize: s48,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          // padding: EdgeInsets.only(top: screenWidthDp / 25),
                          width: screenWidthDp,
                          height: screenWidthDp / 4,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            //mainAxisAlignment: MainAxisAlignment.start,
                            physics: AlwaysScrollableScrollPhysics(),
                            children: <Widget>[
                              Container(
                                child: Column(
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
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      screenHeightDp)),
                                          child: Icon(Icons.whatshot,
                                              color: Color(0xffFF8F3A),
                                              size: appBarHeight / 2.4)),
                                      onTap: () {
                                        if (inHistory(
                                            'burn', scrap.documentID)) {
                                          toast.toast(
                                              'คุณเคยเผาสแครปก้อนนี้แล้ว');
                                        } else {
                                          final report = Provider.of<Report>(
                                              context,
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
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
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
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      screenHeightDp)),
                                          child: Icon(Icons.report_problem,
                                              size: appBarHeight / 2.4)),
                                      onTap: () {
                                        final report = Provider.of<Report>(
                                            context,
                                            listen: false);
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: screenWidthDp / 9,
                        width: screenWidthDp,
                        color: Colors.grey[800],
                        // color: Color(0xfffa5a5a5),
                        child: Center(
                          child: Text(
                            'ยกเลิก',
                            style: TextStyle(
                                fontSize: s48,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
