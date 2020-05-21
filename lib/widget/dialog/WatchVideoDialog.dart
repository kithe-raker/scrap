import 'dart:ui';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/showdialogfinishpaper.dart';

void dialogvideo(BuildContext context, String uid) {
  bool loading = false;
  showDialog(
      context: context,
      builder: (builder) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          Size a = MediaQuery.of(context).size;
          return Stack(
            children: <Widget>[
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  margin: EdgeInsets.only(
                      top: a.width / 20,
                      right: a.width / 20,
                      left: a.width / 20,
                      bottom: a.width / 5),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: a.width,
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
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
                          onTap: () {
                            Navigator.pop(context);
                          },
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
                          body: Center(
                            child: Container(
                              width: a.width,
                              height: a.width,

                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        height: a.width / 3.5,
                                        width: a.width / 3.5,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(a.width),
                                            color: Color(0xff26A4FF)),
                                        child: Icon(
                                          Icons.play_arrow,
                                          size: a.width / 4.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: a.width / 100,
                                      ),
                                      Text(
                                        "เติมกระดาษในคลัง",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: a.width / 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        "ดูวิดีโอเพื่อเติมกระดาษของคุณให้",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: a.width / 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "เต็มคลัง สำหรับเขียนสแครป",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: a.width / 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  RaisedButton(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(a.width),
                                      ),
                                      child: Container(
                                        width: a.width / 4.5,
                                        height: a.width / 8,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "ดูเลย",
                                          style: TextStyle(
                                              color: Color(0xff26A4FF),
                                              fontSize: a.width / 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() => loading = true);
                                        InterstitialAd(
                                            adUnitId:
                                                AdmobService().getVideoAdId(),
                                            listener: (event) async {
                                              if (event ==
                                                  MobileAdEvent.impression) {
                                                await scrap.resetScrap(context,
                                                    uid: uid);
                                                setState(() => loading = false);
                                                Navigator.pop(context);
                                                dialogfinishpaper(context);
                                              } else if (event ==
                                                      MobileAdEvent
                                                          .failedToLoad ||
                                                  event ==
                                                      MobileAdEvent
                                                          .leftApplication) {
                                                scrap.toast(
                                                    'เกิดข้อผิดพลาดกรุณาลองอีกครั้ง');
                                                setState(() => loading = false);
                                                Navigator.pop(context);
                                              }
                                            })
                                          ..load()
                                          ..show();
                                      }),
                                ],
                              ), //ss
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              loading ? Loading() : SizedBox()
            ],
          );
        });
      });
}