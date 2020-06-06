import 'dart:ui';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/function/aboutUser/BlockingFunction.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/widget/CountDownText.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/beforeburn.dart';
import 'package:scrap/widget/showdialogreport.dart';
import 'package:scrap/widget/thrown.dart';

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

  @override
  void initState() {
    pick = widget.scrap['pick'] ?? false;
    super.initState();
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
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: screenWidthDp / 1.04 * 1.115,
                          width: screenWidthDp / 1.04,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/paperscrap.jpg'),
                                  fit: BoxFit.cover)),
                          child: Center(
                              child: Text(
                            scrap['text'],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: s52),
                          )),
                        ),
                        Positioned(
                            right: 0,
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
                SizedBox(height: appBarHeight / 10),
                Container(
                  height: appBarHeight * 1,
                  width: screenWidthDp,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          left: appBarHeight / 7,
                          child: Container(
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
                                child: GestureDetector(
                                  child: Icon(
                                    Icons.more_horiz,
                                    color: Colors.white,
                                    size: s70 * 1.2,
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
                widget.picked
                    ? Center(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                  padding: EdgeInsets.all(appBarHeight / 8),
                                  child: Icon(Icons.delete_outline),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22)),
                                  )),
                              onTap: () {
                                unPick();
                                widget.currentList.remove(widget.scrap);
                                toast.toast('นำสแครปออกแล้ว');
                                nav.pop(context);
                              },
                            ),
                            Text(
                              'นำออก',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: s42,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
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
                                  padding: EdgeInsets.all(appBarHeight / 8),
                                  child: Icon(
                                    Icons.move_to_inbox,
                                    color: pick
                                        ? Colors.white
                                        : Color(0xfff0099FF),
                                  ),
                                  decoration: BoxDecoration(
                                    color: pick
                                        ? Color(0xfff0099FF)
                                        : Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22)),
                                  )),
                              onTap: () {
                                pick ? unPick() : pickScrap();
                              },
                            ),
                            SizedBox(
                              width: appBarHeight / 5,
                            ),
                            GestureDetector(
                              child: Container(
                                  padding: EdgeInsets.only(
                                      left: appBarHeight / 5,
                                      right: appBarHeight / 5,
                                      top: appBarHeight / 8,
                                      bottom: appBarHeight / 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.reply,
                                        //  size: s60 * 1.2,
                                        color: Colors.white,
                                      ),
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
                                user.papers > 0
                                    ? writerScrap(context,
                                        isThrowBack: true,
                                        region: widget.scrap['region'],
                                        thrownUID: widget.scrap['uid'])
                                    : toast.toast('กระดาษของคุณหมดแล้ว');
                              },
                            ),
                          ],
                        ),
                      ),
              ]),
              Positioned(
                  bottom: 0,
                  child: Container(
                    child: AdmobBanner(
                        adUnitId: AdmobService().getBannerAdId(),
                        adSize: AdmobBannerSize.FULL_BANNER),
                  )),
            ],
          ),
        ));
  }

  void showMore(context, {@required DocumentSnapshot scrap}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            height: appBarHeight * 2.2,
            //  height: appBarHeight * 3.4,
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
                  /*  margin: EdgeInsets.only(
                    bottom: appBarHeight - 20,
                  ),*/
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
                                final report =
                                    Provider.of<Report>(context, listen: false);
                                report.scrapId = scrap.documentID;
                                report.scrapRef = scrap.reference.parent().path;
                                report.targetId = scrap['uid'];
                                report.region = scrap['region'];
                                showdialogBurn(context, thrown: true);
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
                                    otherUid: widget.scrap['uid'],
                                    public: widget.scrap['scrap']['writer'] !=
                                        'ไม่ระบุตัวตน',
                                    scrap: widget.scrap);
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
                                report.targetId = scrap['uid'];
                                showDialogReport(context);
                              },
                            ),
                            Text('รายงาน',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: s42,
                                    fontWeight: FontWeight.bold))
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

  pickScrap() async {
    widget.scrap.reference
        .updateData({'pick': true, 'timeStamp': FieldValue.serverTimestamp()});
    setState(() => pick = true);
    toast.toast('เก็บสแครปก้อนนี้แล้ว');
  }

  unPick() async {
    widget.scrap.reference
        .updateData({'pick': false, 'timeStamp': FieldValue.delete()});
    setState(() => pick = false);
  }
}
