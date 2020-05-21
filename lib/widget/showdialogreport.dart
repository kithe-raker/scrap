import 'dart:ui';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/showdialogfinishpaper.dart';
import 'package:scrap/widget/warning.dart';
import 'package:scrap/widget/showdialogreport.dart';

class Report_DropDownButton extends StatefulWidget {
  @override
  _Report_DropDownButtonState createState() => _Report_DropDownButtonState();
}

class _Report_DropDownButtonState extends State<Report_DropDownButton> {
  dynamic dropdownValue = 'กล่าวอ้างถึงบุคคลที่สามในทางเสียหาย  ';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<dynamic>(
        value: dropdownValue,
        dropdownColor: Color(0xfff282828),
        icon: Icon(Icons.arrow_drop_down),
        iconSize: s60,
        onChanged: (dynamic newValue) {
          setState(
            () {
              dropdownValue = newValue;
            },
          );
        },
        items: <dynamic>[
          'กล่าวอ้างถึงบุคคลที่สามในทางเสียหาย  ',
          'ส่งข้อความสแปมไปยังผู้ใช้รายอื่น  ',
          'เขียนเนื้อหาที่ส่งเสริมความรุนแรง  ',
          'เขียนเนื้อหาที่มีการคุกคามทางเพศ  ',
        ].map<DropdownMenuItem<dynamic>>((dynamic value) {
          if (value == 'กล่าวอ้างถึงบุคคลที่สามในทางเสียหาย  ') {
            return DropdownMenuItem<dynamic>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: s54,
                  color: Colors.white,
                ),
              ),
            );
          } else if (value == 'ส่งข้อความสแปมไปยังผู้ใช้รายอื่น  ') {
            return DropdownMenuItem<dynamic>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: s54,
                  color: Colors.white,
                ),
              ),
            );
          } else if (value == 'เขียนเนื้อหาที่ส่งเสริมความรุนแรง  ') {
            return DropdownMenuItem<dynamic>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: s54,
                  color: Colors.white,
                ),
              ),
            );
          } else if (value == 'เขียนเนื้อหาที่มีการคุกคามทางเพศ  ') {
            return DropdownMenuItem<dynamic>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: s54,
                  color: Colors.white,
                ),
              ),
            );
          } else {}
        }).toList(),
      ),
    );
  }
}

class Showreport extends StatefulWidget {
  @override
  _ShowreportState createState() => _ShowreportState();
}

class _ShowreportState extends State<Showreport> {
  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: InkWell(
          child: Text('Report'),
          onTap: () {
            showDialogReport(context);
          },
        ),
      ),
    );
  }
}

void showDialogReport(BuildContext context) {
  Size a = MediaQuery.of(context).size;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 32,
                    width: 32,
                    margin: EdgeInsets.symmetric(
                      horizontal: (screenWidthDp - (screenWidthDp / 1.1)) / 2,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(500),
                        color: Color(0xffffffff)),
                    child: Icon(
                      Icons.close,
                      color: Colors.blue,
                      size: s48,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: screenHeightDp / 1.7,
              width: screenWidthDp / 1.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              /* decoration: BoxDecoration(
                //  color: Color(0xff1a1a1a),
                borderRadius: BorderRadius.circular(5),
              ),*/
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: a.width / 100),
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      resizeToAvoidBottomPadding: false,
                      body: Container(
                        decoration: BoxDecoration(
                            color: Color(0xfff282828),
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: Report_DropDownButton(),
                            ),

                            Container(
                              /*  margin: EdgeInsets.symmetric(
                                horizontal: 8,
                              ),*/
                              padding: EdgeInsets.only(
                                  top: a.width / 100, left: a.width / 50),
                              child: TextField(
                                style: TextStyle(
                                    fontSize: s52, color: Colors.white),
                                minLines: 5,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  // fillColor: Colors.redAccent,
                                  // filled: true,
                                  border: InputBorder.none,
                                  hintText: 'รายงานเจ้าของสแครปรายนี้',
                                  hintStyle: TextStyle(
                                    fontSize: s54,
                                    height: 0.08,
                                    color: Colors.white30,
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              padding: EdgeInsets.only(
                                  left: a.width / 1.4, top: a.width / 2.8),
                              child: Container(
                                /* margin: EdgeInsets.symmetric(
                                horizontal: a.width / 25,
                                vertical: a.width / 40,
                              ),*/

                                width: a.width / 8,
                                height: a.width / 8,
                                // alignment: Alignment.center,
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

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [
                            //     Container(
                            //       height: 80,
                            //       width: 80,
                            //       margin: EdgeInsets.only(
                            //         right: 5,
                            //         bottom: 5,
                            //       ),
                            //       decoration: BoxDecoration(
                            //         color: Colors.white,
                            //         borderRadius:
                            //             BorderRadius.circular(screenHeightDp),
                            //       ),
                            //       child: IconButton(
                            //           icon: Icon(
                            //             Icons.send,
                            //             size: 50,
                            //             color: Colors.blue,
                            //           ),
                            //           onPressed: () {}),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: screenHeightDp / 18,
                    ),
                    child: Divider(
                      color: Color(0xff383838),
                      thickness: 2,
                      indent: 5,
                      endIndent: 5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      });
}

//Report_DropDownButton()

/*void showDialogReport(BuildContext context) {
  Size a = MediaQuery.of(context).size;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 32,
                    width: 32,
                    margin: EdgeInsets.symmetric(
                      horizontal: (screenWidthDp - (screenWidthDp / 1.1)) / 2,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(500),
                        color: Color(0xffffffff)),
                    child: Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: s48,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: screenHeightDp / 1.7,
              width: screenWidthDp / 1.1,
              decoration: BoxDecoration(
                color: Color(0xff1a1a1a),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: screenWidthDp / 50,
                    ),
                    child: Scaffold(
                      // backgroundColor: Color(0xff1a1a1a),
                      // backgroundColor: Colors.red,
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(
                              child: Report_DropDownButton(),
                            ),
                            // Row(
                            //   children: [
                            //     // Text(
                            //     //   'ถึงผู้พัฒนา',
                            //     //   style: TextStyle(
                            //     //     fontSize: s60,
                            //     //     color: Colors.white,
                            //     //   ),
                            //     // ),
                            //     //DropDownButton<<<<<<<<<<<<<<<<<<<<<<<
                            //     //Report_DropDownButton(),
                            //   ],
                            // ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: TextField(
                                style: TextStyle(
                                    fontSize: s25, color: Colors.white),
                                minLines: 17,
                                maxLines: 17,
                                decoration: InputDecoration(
                                  // fillColor: Colors.redAccent,
                                  // filled: true,
                                  border: InputBorder.none,
                                  hintText: 'รายงานเจ้าของสแครปรายนี้',
                                  hintStyle: TextStyle(
                                    fontSize: s54,
                                    height: 0.08,
                                    color: Colors.white30,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Positioned(
                                  top: a.width / 0.95,
                                  right: 0,
                                  //bottom: a.height / 10,
                                  // right: 0,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: a.width / 25,
                                      vertical: a.width / 40,
                                    ),
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: screenHeightDp / 18,
                    ),
                    child: Divider(
                      //color: Color(0xff383838),
                      color: Colors.black,
                      thickness: 2,
                      indent: 5,
                      endIndent: 5,
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      });
}*/
