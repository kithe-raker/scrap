import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/bottomBarItem/WriteScrap.dart';
import 'package:scrap/assets/PaperTexture.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/function/others/ShareFunction.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/stream/UserStream.dart';
import 'package:scrap/widget/CountDownText.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/beforeburn.dart';
import 'package:scrap/widget/showcontract.dart';
import 'package:scrap/widget/showdialogreport.dart';
import 'dart:math' as math;

import 'package:scrap/widget/streamWidget/StreamLoading.dart';

class Paperstranger extends StatefulWidget {
  final DocumentSnapshot scrap;
  final List currentList;
  final bool self;
  final bool isHistory;
  final bool picked;

  Paperstranger(
      {@required this.scrap,
      this.self = false,
      this.currentList,
      this.isHistory = false,
      this.picked = false});
  @override
  _PaperstrangerState createState() => _PaperstrangerState();
}

class _PaperstrangerState extends State<Paperstranger> {
  bool pick;
  Map<String, List> history = {};

  @override
  void initState() {
    pick = widget.scrap['pick'] ?? false;
    super.initState();
  }

  bool inHistory(String field, String id) {
    return history[field].contains(id);
  }

  @override
  void didUpdateWidget(Paperstranger oldWidget) {
    if (widget.scrap != oldWidget.scrap) pick = widget.scrap['pick'] ?? false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    final user = Provider.of<UserData>(context, listen: false);
    var scrap = widget.scrap['scrap'];
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: appBarHeight / 5),
                  child: Center(
                    child: Container(
                      height: screenWidthDp / 1.04 * 1.115,
                      width: screenWidthDp / 1.04,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: screenWidthDp / 1.04 * 1.115,
                            width: screenWidthDp / 1.04,
                            child: SvgPicture.asset(
                                'assets/${texture.textures[scrap['texture'] ?? 0] ?? 'paperscrap.svg'}'),
                          ),
                          Center(
                              child: Text(
                            scrap['text'],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: s52),
                          )),
                          Positioned(
                              right: screenWidthDp / 42,
                              child: Container(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Color(0xfff707070),
                                    size: s70,
                                  ),
                                  onPressed: () {
                                    nav.pop(context);
                                  },
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: appBarHeight / 10),
                Container(
                  height: appBarHeight * 1,
                  width: screenWidthDp,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          left: appBarHeight / 7,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidthDp / 36),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: appBarHeight / 8,
                                ),
                                Text(
                                  scrap['writer'] == 'ไม่ระบุตัวตน'
                                      ? 'ใครบางคน'
                                      : '@${scrap['writer']}',
                                  style: TextStyle(
                                      fontSize: s48,
                                      height: 1.1,
                                      color: scrap['writer'] == 'ไม่ระบุตัวตน'
                                          ? Colors.white
                                          : Color(0xff26A4FF)),
                                ),
                                CountDownText(
                                    startTime: scrap['timeStamp'].toDate())
                              ],
                            ),
                          )),
                      widget.self
                          ? Positioned(
                              top: appBarHeight / 8,
                              right: appBarHeight / 7,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidthDp / 36),
                                child: GestureDetector(
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(math.pi),
                                    child: Icon(
                                      Icons.reply,
                                      color: Colors.white,
                                      size: s65,
                                    ),
                                  ),
                                  onTap: () {
                                    showMore(context, scrap: widget.scrap);
                                  },
                                ),
                              ))
                          : SizedBox()
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: Color(0xff5D5D5D)),
                    ),
                  ),
                ),
                /* Divider(
                  color: Colors.grey,
                ),*/
                SizedBox(height: appBarHeight / 10),
                widget.isHistory
                    ? SizedBox()
                    : Container(
                        width: screenWidthDp,
                        height: appBarHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: appBarHeight / 5,
                            ),
                            GestureDetector(
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: pick
                                          ? Color(0xfff0099FF)
                                          : Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(screenWidthDp)),
                                  padding: EdgeInsets.all(screenWidthDp / 40),
                                  child: SvgPicture.asset(
                                    'assets/keep-icon.svg',
                                    height: screenWidthDp / 15,
                                    width: screenWidthDp / 15,
                                    color: pick
                                        ? Colors.white
                                        : Color(0xfff0099FF),
                                  )),
                              // child: Container(
                              //     padding: EdgeInsets.all(appBarHeight / 8),
                              //     child: Icon(
                              //       Icons.move_to_inbox,
                              //       color: pick
                              //           ? Colors.white
                              //           : Color(0xfff0099FF),
                              //     ),
                              //     decoration: BoxDecoration(
                              //       color: pick
                              //           ? Color(0xfff0099FF)
                              //           : Colors.white,
                              //       borderRadius:
                              //           BorderRadius.all(Radius.circular(22)),
                              //     )),
                              onTap: () {
                                pick ? unPick() : pickScrap();
                              },
                            ),
                            SizedBox(
                              width: appBarHeight / 5,
                            ),
                            GestureDetector(
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenWidthDp / 54,
                                      horizontal: screenWidthDp / 21),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      // Icon(
                                      //   Icons.reply,
                                      //   //  size: s60 * 1.2,
                                      //   color: Colors.white,
                                      // ),
                                      Text('ปากลับ',
                                          style: TextStyle(
                                            fontSize: s42,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ))
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xfff26A4FF),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  )),
                              onTap: () {
                                userStream.papers > 0
                                    ? user.promise
                                        ? nav.push(
                                            context,
                                            WriteScrap(
                                                isThrowBack: true,
                                                region: widget.scrap['region'],
                                                thrownUid: widget.scrap['uid']))
                                        : dialogcontract(context,
                                            onPromise: () async {
                                            await userinfo.promiseUser();
                                            user.promise = true;
                                            nav.pushReplacement(
                                                context,
                                                WriteScrap(
                                                    isThrowBack: true,
                                                    region:
                                                        widget.scrap['region'],
                                                    thrownUid:
                                                        widget.scrap['uid']));
                                          })
                                    : toast.toast('กระดาษของคุณหมดแล้ว');
                              },
                            ),
                          ],
                        ),
                      ),
              ]),
              // Positioned(
              //     bottom: 0,
              //     child: Container(
              //       child: AdmobBanner(
              //           adUnitId: AdmobService().getBannerAdId(),
              //           adSize: AdmobBannerSize.FULL_BANNER),
              //     )),
            ],
          ),
        ));
  }

  void showMore(context, {@required DocumentSnapshot scrap}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
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
                                  borderRadius: BorderRadius.circular(
                                      screenHeightDp / 42),
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
                                    padding: EdgeInsets.only(
                                        top: screenWidthDp / 25),
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
                                                    var scrapData =
                                                        scrap['scrap'];
                                                    share.shareInstagram(
                                                        text: scrapData['text'],
                                                        writer:
                                                            scrapData['writer'],
                                                        paperIndex: scrapData[
                                                            'texture'],
                                                        time: scrapData[
                                                                'timeStamp']
                                                            .toDate());
                                                  },
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
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
                                                    var scrapData =
                                                        scrap['scrap'];
                                                    share.shareFacebook(
                                                        text: scrapData['text'],
                                                        writer:
                                                            scrapData['writer'],
                                                        paperIndex: scrapData[
                                                            'texture'],
                                                        time: scrapData[
                                                                'timeStamp']
                                                            .toDate());
                                                  },
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
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
                                    padding: EdgeInsets.only(
                                        top: screenWidthDp / 25),
                                    width: screenWidthDp,
                                    height: screenWidthDp / 4,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      //mainAxisAlignment: MainAxisAlignment.start,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      children: <Widget>[
                                        //------- เผา

                                        Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                screenHeightDp)),
                                                    child: Icon(Icons.whatshot,
                                                        color:
                                                            Color(0xffFF8F3A),
                                                        size:
                                                            appBarHeight / 3)),
                                                onTap: () {
                                                  final report =
                                                      Provider.of<Report>(
                                                          context,
                                                          listen: false);
                                                  report.scrapId =
                                                      scrap.documentID;
                                                  report.scrapRef = scrap
                                                      .reference
                                                      .parent()
                                                      .path;
                                                  report.targetId =
                                                      scrap['uid'];
                                                  report.region =
                                                      scrap['region'];
                                                  showdialogBurn(context,
                                                      thrown: true);
                                                },
                                              ),
                                              Text(
                                                'เผา',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: s42,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // blockuser
                                        widget.picked
                                            ? Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      child: Container(
                                                          width: 50,
                                                          height: 50,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                            horizontal: 15,
                                                          ),
                                                          child: Icon(
                                                              Icons
                                                                  .delete_outline,
                                                              size:
                                                                  appBarHeight /
                                                                      3),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        screenWidthDp)),
                                                          )),
                                                      onTap: () {
                                                        unPick();
                                                        toast.toast(
                                                            'นำสแครปออกแล้ว');
                                                        nav.pop(context);
                                                        nav.pop(context);
                                                      },
                                                    ),
                                                    Text(
                                                      'นำออก',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: s42,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SizedBox(),
                                        Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                screenHeightDp)),
                                                    child: Icon(
                                                        Icons.report_problem,
                                                        size:
                                                            appBarHeight / 3)),
                                                onTap: () {
                                                  final report =
                                                      Provider.of<Report>(
                                                          context,
                                                          listen: false);
                                                  report.targetId =
                                                      scrap['uid'];
                                                  showDialogReport(context);
                                                },
                                              ),
                                              Text('รายงาน',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: s42,
                                                      fontWeight:
                                                          FontWeight.bold))
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
                                          child: Text('ยกเลิก',
                                              style: TextStyle(
                                                  fontSize: s48,
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.bold)))))
                            ],
                          ),
                        ],
                      ))),
              Center(child: StreamLoading(stream: share.loadStatus))
            ],
          );
        });
  }

  pickScrap() {
    widget.scrap.reference
        .updateData({'pick': true, 'timeStamp': FieldValue.serverTimestamp()});
    widget.currentList.add(widget.scrap);
    setState(() => pick = true);
    toast.toast('เก็บสแครปก้อนนี้แล้ว');
  }

  unPick() {
    widget.scrap.reference
        .updateData({'pick': false, 'timeStamp': FieldValue.delete()});
    widget.currentList
        .removeWhere((scrap) => scrap.documentID == widget.scrap.documentID);
    setState(() => pick = false);
  }
}
