import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/widget/personcard.dart';

class Subpeople extends StatefulWidget {
  @override
  _SubpeopleState createState() => _SubpeopleState();
}

class _SubpeopleState extends State<Subpeople> {
  int page = 0;
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: a.width,
        height: a.height,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: a.width / 1.7,
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xff262626)))),
                  padding: EdgeInsets.only(
                      top: a.width / 50,
                      left: a.width / 50,
                      right: a.width / 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: a.width,
                        height: a.width / 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.arrow_back,
                                color: Colors.white, size: a.width / 15),
                            Row(
                              children: <Widget>[
                                Text(
                                  "31" + " ผู้ติดตาม",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: a.width / 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.white,
                                  size: a.width / 15,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Text(
                        page == 0 ? "ค้นหาผู้คน" : "ติดตามผู้คน",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: a.width / 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "ค้นหาผู้คนเพื่ออ่านสแครปหรือปากระดาษหาพวกเขา",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: a.width / 23,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: a.width / 20,
                      ),
                      page == 0
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  page = 1;
                                });
                              },
                              child: Container(
                                width: a.width,
                                height: a.width / 8,
                                decoration: BoxDecoration(
                                    color: Color(0xff262626),
                                    borderRadius:
                                        BorderRadius.circular(a.width)),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: a.width / 1.3,
                                  height: a.width / 8,
                                  decoration: BoxDecoration(
                                      color: Color(0xff262626),
                                      borderRadius:
                                          BorderRadius.circular(a.width)),
                                ),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        page = 0;
                                      });
                                    },
                                    child: Text(
                                      "ยกเลิก",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: a.width / 20),
                                    ))
                              ],
                            ),
                    ],
                  ),
                ),
                page == 0
                    ? Container(
                        width: a.width,
                        height: a.height / 1.5,
                        child: ListView(
                          children: <Widget>[
                            Container(
                              width: a.width,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xff292929)))),
                              padding: EdgeInsets.only(
                                  left: a.width / 50,),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    
                                    child: Text(
                                      "ล่าสุดที่ปาใส่",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: a.width / 20,
                                  ),
                                  Wrap(
                                    children: <Widget>[
                                      Personcard(),
                                      Personcard(),
                                      Personcard(),
                                    ],
                                  ),
                                  SizedBox(
                                    height: a.width / 40,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: a.width,
                              padding: EdgeInsets.only(
                                  top: a.width / 20,
                                  left: a.width / 50,
                                  right: a.width / 50),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: a.width,
                                    height: a.width / 10,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "กำลังติดตาม " + "125",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: a.width / 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              "ทั้งหมด",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: a.width / 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_right,
                                              color: Colors.white,
                                              size: a.width / 15,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: a.width / 20,
                                  ),
                                  Wrap(
                                    children: <Widget>[
                                      Personcard1(),
                                      Personcard1(),
                                      Personcard1(),
                                    ],
                                  ),
                                  SizedBox(
                                    height: a.width / 10,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(
                        width: a.width,
                        height: a.height / 1.5,
                        child: ListView(
                          children: <Widget>[
                            Container(
                              width: a.width,
                              padding: EdgeInsets.only(
                                  left: a.width / 50, right: a.width / 50),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: a.width,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "ผู้คน",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: a.width / 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: a.width / 20,
                                  ),
                                  Wrap(
                                    children: <Widget>[
                                      Personcard1(),
                                      Personcard1(),
                                      Personcard1(),
                                      Personcard1(),
                                      Personcard1(),
                                      Personcard1(),
                                    ],
                                  ),
                                  SizedBox(
                                    height: a.width / 10,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
              ],
            ),
            Positioned(
              bottom: 0,
              child: AdmobBanner(
                  adUnitId: AdmobService().getBannerAdId(),
                  adSize: AdmobBannerSize.FULL_BANNER),
            ),
          ],
        ),
      ),
    );
  }
}
