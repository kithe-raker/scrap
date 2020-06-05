import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrap/function/aboutUser/ReportUser.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';

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
              final report = Provider.of<Report>(context, listen: false);
              report.topic = newValue;
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

void showDialogReport(BuildContext context) {
  Size a = MediaQuery.of(context).size;
  final report = Provider.of<Report>(context, listen: false);
  String describe;
  bool loading = false;

  showDialog(
      context: context,
      builder: (BuildContext context) {
        screenutilInit(context);
        return Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomPadding: false,
          body: StatefulBuilder(builder: (context, StateSetter setDialog) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: appBarHeight),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                right: appBarHeight / 4,
                                bottom: appBarHeight / 5),
                            child: GestureDetector(
                                child: Container(
                                  height: appBarHeight / 2.8,
                                  width: appBarHeight / 2.8,
                                  decoration: BoxDecoration(
                                      color:
                                          Color(0xfffFFFFFF).withOpacity(0.24),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(appBarHeight))),
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                    size: s42,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                }),
                          ),
                        ],
                      ),
                      Container(
                        width: screenWidthDp / 1.1,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Stack(
                          children: [
                            Container(
                                padding: EdgeInsets.only(top: a.width / 100),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xfff282828),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7.0))),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color:
                                                            Color(0xff383838),
                                                        width: 2))),
                                            child: Report_DropDownButton(),
                                          ),
                                          Container(
                                            height: screenHeightDp / 2.1,
                                            padding: EdgeInsets.only(
                                                top: a.width / 100,
                                                left: a.width / 50),
                                            child: TextField(
                                              keyboardType: TextInputType.text,
                                              textInputAction: TextInputAction.done,
                                              maxLines: null,
                                              onChanged: (str) =>
                                                  describe = str.trim(),
                                              style: TextStyle(
                                                  fontSize: s52,
                                                  color: Colors.white),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    'รายงานเจ้าของสแครปรายนี้',
                                                hintStyle: TextStyle(
                                                  fontSize: s54,
                                                  height: 0.08,
                                                  color: Colors.white30,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            appBarHeight / 15),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      horizontal: a.width / 40,
                                                      vertical: a.width / 40,
                                                    ),
                                                    width: a.width / 8,
                                                    height: a.width / 8,
                                                    child: Icon(Icons.send,
                                                        color:
                                                            Color(0xff26A4FF),
                                                        size: s60 * 0.8),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    a.width)),
                                                  ),
                                                  onTap: () async {
                                                    setDialog(
                                                        () => loading = true);
                                                    report.reportText =
                                                        describe;
                                                    await reportUser
                                                        .updateData(context);
                                                    setDialog(
                                                        () => loading = false);
                                                    nav.pop(context);
                                                    toast.toast(
                                                        'รายงานผู้ใช้รายนี้แล้ว');
                                                  }),
                                            ],
                                          )
                                        ]))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  loading ? Loading() : SizedBox()
                ],
              ),
            );
          }),
        );
      });
}
