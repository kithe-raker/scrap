import 'dart:ui';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/Gridfavorite.dart';
import 'package:scrap/Page/Gridsubscripe.dart';
import 'package:scrap/Page/MapScraps.dart';
import 'package:scrap/Page/friendList.dart';
import 'package:scrap/Page/profile/Profile.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/services/jsonConverter.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/showdialogfinishpaper.dart';
import 'package:scrap/widget/warning.dart';
import 'package:scrap/widget/showdialogreport.dart';

class Showreport extends StatefulWidget {
  @override
  _ShowreportState createState() => _ShowreportState();
}

class _ShowreportState extends State<Showreport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          child: Text('Report'),
          onTap: () {
            _showdialogreport(context);
          },
        ),
      ),
    );
  }
}

void _showdialogreport(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        String txt = "กล่าวอ้างถึงบุคคลที่สามในทางเสียหาย";
        int drop = 0;
        Size a = MediaQuery.of(context).size;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          Size a = MediaQuery.of(context).size;
          return Scaffold(
            body: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                    margin: EdgeInsets.only(
                        top: a.width / 15,
                        right: a.width / 20,
                        left: a.width / 20,
                        bottom: a.width / 2),
                    child: ListView(children: <Widget>[
                      Container(
                        // color: Colors.grey,
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          child: Container(
                            margin: EdgeInsets.only(
                              top: a.width / 40,
                              bottom: a.width / 20,
                            ),
                            width: a.width / 12,
                            height: a.width / 12,
                            child: Center(
                              child: Icon(
                                Icons.cancel,
                                color: Color(0xfffFFFFFF),
                                size: a.width / 13,
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(a.width)),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Container(
                        //height: a.height,
                        decoration: BoxDecoration(
                            color: Color(0xffff282828),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: a.width,
                                height: a.height,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      width: a.width,
                                      child: Column(
                                        children: <Widget>[
                                          InkWell(
                                              child: Container(
                                                height: a.width / 9,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width:
                                                                a.width / 1000,
                                                            color:
                                                                Colors.grey))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    Text(
                                                      txt,
                                                      style: TextStyle(
                                                          fontSize:
                                                              a.width / 18,
                                                          color: Colors.white),
                                                    ),
                                                    Icon(Icons.arrow_drop_down,
                                                        color: Colors.white)
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  drop = 1;
                                                });
                                              }),
                                          drop == 1
                                              ? InkWell(
                                                  child: SizedBox(
                                                    width: a.width,
                                                    child: Container(
                                                      color: Colors.white,
                                                      child: Column(
                                                        children: <Widget>[
                                                          InkWell(
                                                            child: Container(
                                                              height:
                                                                  a.width / 10,
                                                              decoration: BoxDecoration(
                                                                  color: Color(
                                                                      0xffff282828),
                                                                  border: Border(
                                                                      bottom: BorderSide(
                                                                          width: a.width /
                                                                              1000,
                                                                          color:
                                                                              Colors.grey))),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "\t\t\tกล่าวอ้างถึงบุคคลที่สามในทางเสียหาย",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            a.width /
                                                                                18,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              setState(() {
                                                                txt =
                                                                    "กล่าวอ้างถึงบุคคลที่สามในทางเสียหาย";
                                                                drop = 0;
                                                              });
                                                            },
                                                          ),
                                                          InkWell(
                                                            child: Container(
                                                              height:
                                                                  a.width / 10,
                                                              decoration: BoxDecoration(
                                                                  color: Color(
                                                                      0xffff282828),
                                                                  border: Border(
                                                                      bottom: BorderSide(
                                                                          width: a.width /
                                                                              1000,
                                                                          color:
                                                                              Colors.grey))),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "\t\tส่งข้อความสแปมไปยังผู้ใช้รายอื่น",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            a.width /
                                                                                18,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              setState(() {
                                                                txt =
                                                                    "ส่งข้อความสแปมไปยังผู้ใช้รายอื่น";
                                                                drop = 0;
                                                              });
                                                            },
                                                          ),
                                                          InkWell(
                                                            child: Container(
                                                              height:
                                                                  a.width / 10,
                                                              decoration: BoxDecoration(
                                                                  color: Color(
                                                                      0xffff282828),
                                                                  border: Border(
                                                                      bottom: BorderSide(
                                                                          width: a.width /
                                                                              1000,
                                                                          color:
                                                                              Colors.grey))),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "\t\tเขียนเนื้อหาที่ส่งเสริมความรุนแรง",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            a.width /
                                                                                18,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              setState(() {
                                                                txt =
                                                                    "เขียนเนื้อหาที่ส่งเสริมความรุนแรง";
                                                                drop = 0;
                                                              });
                                                            },
                                                          ),
                                                          InkWell(
                                                            child: Container(
                                                              height:
                                                                  a.width / 10,
                                                              decoration: BoxDecoration(
                                                                  color: Color(
                                                                      0xffff282828),
                                                                  border: Border(
                                                                      bottom: BorderSide(
                                                                          width: a.width /
                                                                              1000,
                                                                          color:
                                                                              Colors.grey))),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "\t\tเขียนเนื้อหาที่มีการคุกคามทางเพศ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            a.width /
                                                                                18,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              setState(() {
                                                                txt =
                                                                    "เขียนเนื้อหาที่มีการคุกคามทางเพศ";
                                                                drop = 0;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      drop = 0;
                                                    });
                                                  },
                                                )
                                              : SizedBox(),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: a.width / 50),
                                            child: TextField(
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  color: Colors.white),
                                              minLines: 10,
                                              maxLines: 10,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintStyle: TextStyle(
                                                      color:
                                                          Color(0xfff656565)),
                                                  hintText:
                                                      '\tรายงานเจ้าของสแครปรายนี้'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: a.width / 0.95,
                                      right: 0,
                                      //bottom: a.height / 10,
                                      // right: 0,
                                      child: Container(
                                        margin: EdgeInsets.all(a.width / 40),
                                        width: a.width / 8,
                                        height: a.width / 8,
                                        alignment: Alignment.center,
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.send,
                                              color: Color(0xff26A4FF),
                                            ),
                                            onPressed: () {}),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(a.width)),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ]))),
          );
        });
      });
}
