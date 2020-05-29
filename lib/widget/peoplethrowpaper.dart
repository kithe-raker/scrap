import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/widget/CountDownText.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Ads.dart';
import 'package:scrap/widget/beforeburn.dart';
import 'package:scrap/widget/showdialogreport.dart';

class Paperstranger extends StatefulWidget {
  final DocumentSnapshot scrap;
  Paperstranger({@required this.scrap});
  @override
  _PaperstrangerState createState() => _PaperstrangerState();
}

class _PaperstrangerState extends State<Paperstranger> {
  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
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
                        Positioned(
                            child: Container(
                          height: screenWidthDp / 1.05 * 1.21,
                          width: screenWidthDp / 1.05,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                  image: AssetImage('assets/paper-readed.png'),
                                  fit: BoxFit.cover)),
                          child: Center(
                              child: Text(
                            scrap['text'],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: s52),
                          )),
                          /*  height: 407 * appBarHeight / 75,
                          width: 365 * appBarHeight / 75,*/
                        )),
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
                SizedBox(
                  height: appBarHeight / 10,
                ),
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
                      Positioned(
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
                          )),
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
                SizedBox(
                  height: appBarHeight / 10,
                ),
                Container(
                  width: screenWidthDp,
                  height: appBarHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: appBarHeight / 5,
                      ),
                      Container(
                          padding: EdgeInsets.all(appBarHeight / 8),
                          /* child: IconButton(
                              icon: Icon(
                                Icons.move_to_inbox,
                                size: s60 * 1.2,
                                color: Color(0xfff0099FF),
                              ),
                              onPressed: () {}),*/
                          child: Icon(
                            Icons.move_to_inbox,
                            color: Color(0xfff0099FF),
                          ),
                          /*  height: appBarHeight / 1.8,
                          width: appBarHeight / 1.8,*/

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(22)),
                          )),
                      SizedBox(
                        width: appBarHeight / 5,
                      ),
                      GestureDetector(
                        onTap: () {},
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
                            /*  height: appBarHeight / 1.8,
                            //width: appBarHeight / 1.8,
                            width: appBarHeight * 1.5,*/
                            decoration: BoxDecoration(
                              color: Color(0xfff26A4FF),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            )),
                      ),
                    ],
                  ),
                ),
                /* Container(
                  height: appBarHeight,
                  width: screenWidthDp,
                  child: Stack(children: <Widget>[
                    Positioned(
                        left: appBarHeight / 5,
                        child: Container(
                            child: IconButton(
                                icon: Icon(
                                  Icons.move_to_inbox,
                                  size: s60 * 1.2,
                                  color: Color(0xfff0099FF),
                                ),
                                onPressed: () {}),
                            height: appBarHeight / 1.5,
                            width: appBarHeight / 1.5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ))),
                    Positioned(
                        left: appBarHeight * 1.05,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.reply,
                                    size: s60 * 1.2,
                                    color: Colors.white,
                                  ),
                                  Text('ปากลับ',
                                      style: TextStyle(
                                        fontSize: s52,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                              height: appBarHeight / 1.5,
                              width: appBarHeight * 1.5,
                              decoration: BoxDecoration(
                                color: Color(0xfff26A4FF),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              )),
                        )),
                    Positioned(
                        left: appBarHeight * 4,
                        child: Column(
                          children: <Widget>[
                            Container(
                                child: IconButton(
                                    icon: Icon(
                                      Icons.forward,
                                      size: s60 * 1.2,
                                    ),
                                    onPressed: () {}),
                                height: appBarHeight / 1.5,
                                width: appBarHeight / 1.5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                )),
                            SizedBox(
                              height: appBarHeight / 10,
                            ),
                            Text(
                              'ต่อไป',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: s40,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )),
                  ]),
                ),*/
              ]),
              Positioned(
                  bottom: 0,
                  child: Container(
                    child: Ads(),
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
                                  child: Icon(Icons.whatshot,
                                      color: Color(0xffFF8F3A),
                                      size: appBarHeight / 3)),
                              onTap: () {
                                final report =
                                    Provider.of<Report>(context, listen: false);
                                report.scrapId = scrap.documentID;
                                report.scrapRef = scrap.reference.parent().path;
                                report.targetId = scrap['uid'];
                                showdialogBurn(context, thrown: true);
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
                Positioned(
                    bottom: 0,
                    child: Container(
                      child: Ads(),
                    )),
              ],
            ),
          );
        });
  }
}
