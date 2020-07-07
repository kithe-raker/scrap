import 'dart:async';
import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scrap/assets/PaperTexture.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/models/TopPlaceModel.dart';
import 'package:scrap/stream/NearbyStream.dart';
import 'package:scrap/widget/PlaceText.dart';
import 'package:social_share/social_share.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/models/ScrapModel.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/widget/LoadNoBlur.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/beforeburn.dart';
import 'package:scrap/widget/sheets/CommentSheet.dart';
import 'package:scrap/widget/sheets/MapSheet.dart';
import 'package:scrap/widget/showdialogreport.dart';
import 'dart:io';
import 'dart:math' as math;

class FeedNearby extends StatefulWidget {
  final TopPlaceModel place;
  final String tapScrapId;
  FeedNearby({@required this.place, @required this.tapScrapId});
  @override
  _FeedNearbyState createState() => _FeedNearbyState();
}

class _FeedNearbyState extends State<FeedNearby> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool initHistory = false;
  int current = 0;
  var pageController;
  Map<String, List> history = {};

  bool inHistory(String field, String id) {
    return history[field].contains(id);
  }

  @override
  void initState() {
    initIndex();
    initUserHistory();
    super.initState();
  }

  Future<void> initUserHistory() async {
    history['like'] = await cacheHistory.readOnlyId(field: 'like') ?? [];
    history['picked'] = await cacheHistory.readOnlyId(field: 'picked') ?? [];
    history['burn'] = await cacheHistory.readOnlyId(field: 'burn') ?? [];
    setState(() => initHistory = true);
  }

  void initIndex() {
    var whereMatch = nearby.scraps
        .where((scrap) => scrap.scrapId == widget.tapScrapId)
        .toList();
    if (whereMatch.length > 0)
      current = nearby.scraps.indexOf(whereMatch.first);
    if (current < 0) current = 0;
    pageController = PageController(initialPage: current);
    if (current == nearby.scraps.length - 1)
      nearby.loadMore(context, placeId: widget.place.id);
  }

  @override
  void didUpdateWidget(FeedNearby oldWidget) {
    if (widget.tapScrapId != oldWidget.tapScrapId) initIndex();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void listener() {
    if (pageController.position.pixels >
        pageController.position.maxScrollExtent)
      toast.toast('คุณตามทันสแครปทั้งหมดแล้ว');
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            !initHistory
                ? Center(child: LoadNoBlur())
                : Expanded(
                    child: StreamBuilder(
                        initialData: nearby.scraps,
                        stream: nearby.nearbyStream,
                        builder: (context,
                            AsyncSnapshot<List<ScrapModel>> snapshot) {
                          if (snapshot.hasData) {
                            return Listener(
                              onPointerUp: (event) => listener(),
                              child: Screenshot(
                                  controller: screenshotController,
                                  child: PageView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    controller: pageController,
                                    onPageChanged: (index) {
                                      if (current + 1 == index &&
                                          (index + 1) % 3 == 0) {
                                        nearby.loadMore(context,
                                            placeId: widget.place.id);
                                      }
                                      current = index;
                                    },
                                    scrollDirection: Axis.vertical,
                                    children: nearby.scraps
                                        .map((scrap) => scrapWidget(scrap))
                                        .toList(),
                                  )),
                            );
                          } else {
                            return Center(child: LoadNoBlur());
                          }
                        }),
                  ),
          ],
        )));
  }

  ScreenshotController screenshotController = ScreenshotController();
  void replyButtonSheet(context, {@required ScrapModel scrap}) {
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
                          padding: EdgeInsets.only(top: screenWidthDp / 25),
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
                                        if (inHistory('burn', scrap.scrapId)) {
                                          toast.toast(
                                              'คุณเคยเผาสแครปก้อนนี้แล้ว');
                                        } else {
                                          final report = Provider.of<Report>(
                                              context,
                                              listen: false);
                                          report.scrapId = scrap.scrapId;
                                          report.targetId = scrap.writerUid;
                                          report.region = scrap.scrapRegion;
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
                                        report.targetId = scrap.writerUid;
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

  Widget scrapWidget(ScrapModel scrapModel) {
    var transac = scrapModel.transaction;
    return StatefulBuilder(builder: (context, StateSetter setDialog) {
      return Container(
          padding: EdgeInsets.symmetric(
              horizontal: (screenWidthDp - screenWidthDp / 1.04) / 2),
          child: Column(
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
                //     ? Container(
                //         width: a.width / 1.04,
                //         height: a.width / 1.04 * 1.115,
                //         decoration: BoxDecoration(
                //             image: DecorationImage(
                //                 image: AssetImage(
                //                     'assets/paperscrap.jpg'),
                //                 fit: BoxFit.cover)),
                //         child: AdmobBanner(
                //             adUnitId:
                //                 AdmobService().getBannerAdId(),
                //             adSize: AdmobBannerSize
                //                 .MEDIUM_RECTANGLE),
                //       )
                //     :
                Column(
                  // screenshot here
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      //addscrappaper
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: screenWidthDp / 1.04,
                            height: screenWidthDp / 1.04 * 1.115,
                            child: SvgPicture.asset(
                                'assets/${texture.textures[scrapModel.textureIndex] ?? 'paperscrap.svg'}'),
                            //  child: Image.asset('assets/paperscrap.jpg'),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: screenWidthDp / 1.04,
                            height: screenWidthDp / 1.04 * 1.115,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 25, right: 25),
                            child: Text(scrapModel.text,
                                style: TextStyle(height: 1.35, fontSize: s60),
                                textAlign: TextAlign.center),
                          ),
                        ),
                        Positioned(
                          // top: screenWidthDp / 21 / 1.5,
                          // left: screenWidthDp / 21 / 1.5,
                          top: screenWidthDp / 42,
                          left: screenWidthDp / 42,
                          child: GestureDetector(
                              onTap: () {
                                nav.pop(context);
                              },
                              child: Container(
                                width: screenWidthDp / 12,
                                height: screenWidthDp / 12,
                                padding:
                                    EdgeInsets.only(right: screenWidthDp / 168),
                                decoration: BoxDecoration(
                                    color: Colors.grey[800].withOpacity(0.5),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(screenWidthDp))),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: s42,
                                ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: screenWidthDp / 36),
                    Container(
                      width: screenWidthDp,
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidthDp / 36),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                scrapModel.writer == 'ไม่ระบุตัวตน'
                                    ? 'ใครบางคน'
                                    : '@${scrapModel.writer}',
                                style: TextStyle(
                                    fontSize: s48,
                                    height: 1.1,
                                    color: scrapModel.writer == 'ไม่ระบุตัวตน'
                                        ? Colors.white
                                        : Color(0xff26A4FF)),
                              ),
                              PlaceText(
                                  time: scrapModel.litteredTime,
                                  placeName: scrapModel.placeName)
                            ],
                          ),
                          GestureDetector(
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(math.pi),
                                child: Icon(
                                  Icons.reply,
                                  color: Colors.white,
                                  size: s65,
                                ),
                              ),
                              onTap: () async {
                                // showShareSheet(context, scrap: scrapModel);
                                replyButtonSheet(context, scrap: scrapModel);
                                //showShare(context);
                              }),
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
                        //                 iconColor:
                        //                     Color(0xff000000),
                        //                 icon: Icons.forward),
                        //             onTap: () {
                        //               randomAdsRate();
                        //               counter.count = 0;
                        //               setDialog(() {});
                        //             }))
                        //     :
                        StatefulBuilder(
                            builder: (context, StateSetter setTrans) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: screenWidthDp / 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                  child: iconfrommilla(
                                      inHistory('like', scrapModel.scrapId)
                                          ? 'assets/heart-fill-icon.svg'
                                          : 'assets/heart-icon.svg',
                                      transac.like.abs().toString(),
                                      iconColor:
                                          inHistory('like', scrapModel.scrapId)
                                              ? Colors.white
                                              : Colors.red,
                                      backgroundColor:
                                          inHistory('like', scrapModel.scrapId)
                                              ? Colors.red
                                              : Colors.white),
                                  onTap: () {
                                    scrap.updateScrapTrans('like',
                                        scrap: scrapModel);
                                    if (inHistory('like', scrapModel.scrapId)) {
                                      ++transac.like;
                                      history['like']
                                          .remove(scrapModel.scrapId);
                                    } else {
                                      --transac.like;
                                      history['like'].add(scrapModel.scrapId);
                                    }
                                    setTrans(() {});
                                  },
                                ),
                                GestureDetector(
                                  child: iconfrommilla(
                                      inHistory('picked', scrapModel.scrapId)
                                          ? 'assets/keep-icon.svg'
                                          : 'assets/keep-icon.svg',
                                      transac.picked.abs().toString(),
                                      iconColor: inHistory(
                                              'picked', scrapModel.scrapId)
                                          ? Colors.white
                                          : Colors.blue,
                                      backgroundColor: inHistory(
                                              'picked', scrapModel.scrapId)
                                          ? Colors.blue
                                          : Colors.white),
                                  onTap: () {
                                    scrap.updateScrapTrans('picked',
                                        scrap: scrapModel,
                                        comments: transac.comment);
                                    if (inHistory(
                                        'picked', scrapModel.scrapId)) {
                                      ++transac.picked;
                                      history['picked']
                                          .remove(scrapModel.scrapId);
                                    } else {
                                      --transac.picked;
                                      history['picked'].add(scrapModel.scrapId);
                                    }
                                    setTrans(() {});
                                  },
                                ),
                                GestureDetector(
                                  child: iconfrommilla(
                                      'assets/comment-icon.svg',
                                      transac.comment.abs().toString(),
                                      iconColor: Colors.black,
                                      backgroundColor: Colors.white),
                                  onTap: () {
                                    Scaffold.of(context).showBottomSheet(
                                      (BuildContext context) => CommentSheet(
                                          scrapSnapshot: scrapModel),
                                      backgroundColor: Colors.transparent,
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          scrapModel.position != null
                              ? Container(
                                  padding: EdgeInsets.only(
                                      right: screenWidthDp / 25),
                                  child: GestureDetector(
                                    child: iconfrommilla(
                                        'assets/location-icon.svg', '',
                                        iconColor: Colors.red,
                                        backgroundColor: Colors.white),
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          MapSheet(
                                              position: scrapModel.position),
                                    )
                                    // counter.count += 1;
                                    // allScrap.remove(data);
                                    // markers.remove(MarkerId(
                                    //     data.documentID));
                                    // if (allScrap.isNotEmpty &&
                                    //     allScrap.length > 0) {
                                    //   setDialog(() =>
                                    //       data = allScrap.first);
                                    //   streamLimit.add(
                                    //       16 - allScrap.length);
                                    // } else {
                                    //   toast.toast(
                                    //       'คุณตามทันสแครปทั้งหมดแล้ว');
                                    // }
                                    ,
                                  ),
                                )
                              : SizedBox()
                        ],
                      );
                    })),
              ]));
    });
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
        ]);
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
          //child: SvgPicture.asset('assetName'),
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
