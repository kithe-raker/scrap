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

class Showcontract extends StatefulWidget {
  @override
  _ShowcontractState createState() => _ShowcontractState();
}

class _ShowcontractState extends State<Showcontract> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
            child: InkWell(
          child: Text('Contract'),
          onTap: () {
            dialogcontract(context);
          },
        )),
      ),
    );
  }
}

void dialogcontract(context) {
  int ass = 0;
  showDialog(
      context: context,
      builder: (builder) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          Size a = MediaQuery.of(context).size;
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              margin: EdgeInsets.only(
                top: a.width / 20,
                right: a.width / 20,
                left: a.width / 20,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    width: a.width,
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: a.width / 20, bottom: a.width / 15),
                      width: a.width / 12,
                      height: a.width / 12,
                      child: Center(
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(a.width)),
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: Color(0xff282828),
                          borderRadius: BorderRadius.circular(a.width / 50)),
                      width: a.width,
                      padding: EdgeInsets.all(a.width / 50),
                      height: a.height / 1.4,
                      child: Scaffold(
                          backgroundColor: Color(0xff282828),
                          body: Column(
                            children: <Widget>[
                              Container(
                                width: a.width,
                                height: a.width / 8,
                                alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: a.width / 1000,
                                            color: Colors.grey))),
                                child: Text(
                                  "สัญญากับเรา",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: a.width / 15,
                                      color: Colors.white),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(a.width / 25),
                                child: SizedBox(
                                  width: a.width,
                                  child: Text(
                                    "เพื่อสร้างชุมชนที่ดีขึ้นของสแครป คุณสัญญาว่าจะไม่ทำสิ่งเหล่านี้\n\n1.กล่าวอ้างถึงบุคคลที่สามในทางเสียหาย\n2.ส่งข้อความสแปมไปยังผู้ใช้รายอื่น\n3.เขียนเนื้อหาที่ส่งเสริมความรุนแรง\n4.เขียนเนื้อหาที่มีการคุกคามทางเพศ\n\n* หากคณไม่ทำตามสัญญาดังกล่าวสแครปขอ อนุญาติให้ความร่วมมือกับหบ่วยงานทางกฎหมายมากเท่าที่เราจะทำได้",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: a.width / 18),
                                  ),
                                ),
                              ),
                              Container(
                                width: a.width,
                                padding: EdgeInsets.all(a.width / 20),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: a.width / 15,
                                      height: a.width / 15,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              a.width / 50),
                                          border:
                                              Border.all(color: Colors.white)),
                                      padding: EdgeInsets.all(a.width / 100),
                                      child: ass == 0
                                          ? InkWell(
                                              onTap: () {
                                                setState(() {
                                                  ass = 1;
                                                });
                                              },
                                              child: Container(
                                                width: a.width / 25,
                                                height: a.width / 25,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            a.width),
                                                    color: Colors.transparent),
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                setState(() {
                                                  ass = 0;
                                                });
                                              },
                                              child: Container(
                                                width: a.width / 25,
                                                height: a.width / 25,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            a.width),
                                                    color: Color(0xff26A4FF)),
                                              ),
                                            ),
                                    ),
                                    Text(
                                      "  ฉันได้อ่านและยอมรับ ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: a.width / 22),
                                    ),
                                    Text(
                                      "นโยบายและข้อกำหนด",
                                      style: TextStyle(
                                          color: Color(0xff26A4FF),
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                          fontSize: a.width / 22),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                // padding: EdgeInsets.only(bottom: 0),
                                width: a.width,
                                height: a.width / 15,
                                child: Text(
                                  '“ สำเนียงส่อภาษา กริยาส่อสกุล 🙂”',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: a.width / 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ))),
                  Container(
                    width: a.width,
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: a.width / 20, bottom: a.width / 15),
                      width: a.width / 5,
                      height: a.width / 8,
                      child: ass == 1
                          ? RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(a.width),
                              ),
                              color: Color(0xff26A4FF),
                              child: Container(
                                  child: Text(
                                "ตกลง",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                              onPressed: () {
                                Navigator.pop(context);
                                // dialogvideo();
                                dialogfinishpaper(context);
                              })
                          : RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(a.width),
                              ),
                              color: Colors.grey,
                              child: Container(
                                  child: Text(
                                "ตกลง",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                              onPressed: () {}),
                      decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(a.width)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      });
}
