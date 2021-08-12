import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/widget/ScreenUtil.dart';

void dialogcontract(context, {@required Function onPromise}) {
  showDialog(
      context: context,
      builder: (builder) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: StatefulBuilder(builder: (context, StateSetter setState) {
            screenutilInit(context);
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                margin: EdgeInsets.all(screenWidthDp / 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: screenWidthDp,
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: screenWidthDp / 18),
                            width: screenWidthDp / 12,
                            height: screenWidthDp / 12,
                            child: Center(
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius:
                                    BorderRadius.circular(screenWidthDp)),
                          ),
                          onTap: () => nav.pop(context)),
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: Color(0xff282828),
                            borderRadius:
                                BorderRadius.circular(screenWidthDp / 50)),
                        width: screenWidthDp,
                        height: screenHeightDp / 1.54,
                        padding: EdgeInsets.all(screenWidthDp / 50),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: screenWidthDp / 1000,
                                            color: Colors.grey))),
                                child: Text(
                                  "สัญญากับเรา",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: s46,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: Container(
                                padding: EdgeInsets.all(screenWidthDp / 25),
                                child: AutoSizeText(
                                  "เพื่อสร้างชุมชนที่ดีขึ้นของสแครป คุณสัญญาว่าจะไม่ทำสิ่งเหล่านี้\n\n1.กล่าวอ้างถึงบุคคลที่สามในทางเสียหาย\n2.ส่งข้อความสแปมไปยังผู้ใช้รายอื่น\n3.เขียนเนื้อหาที่ส่งเสริมความรุนแรง\n4.เขียนเนื้อหาที่มีการคุกคามทางเพศ\n\n* หากคณไม่ทำตามสัญญาดังกล่าวสแครปขออนุญาติให้ความร่วมมือกับหบ่วยงานทางกฎหมายมากเท่าที่เราจะทำได้",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: s42),
                                ),
                              ),
                            ),
                            // SizedBox(height: screenHeightDp / 64),
                            GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      bottom: screenHeightDp / 42),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: appBarHeight / 2,
                                      vertical: appBarHeight / 22),
                                  decoration: BoxDecoration(
                                      color: Color(0xfff27A4FF),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(23))),
                                  child: Text(
                                    'สัญญา',
                                    style: TextStyle(
                                        color: Color(0xfffFFFFFF),
                                        fontSize: s52,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                onTap: onPromise),
                          ],
                        )),
                  ],
                ),
              ),
            );
          }),
        );
      });
}

void dialogAboutSwitch(context) async {
  await userinfo.updateFirstStatus();
  showDialog(
      context: context,
      builder: (builder) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          Size a = MediaQuery.of(context).size;
          bool isOn = false;
          screenutilInit(context);
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                margin: EdgeInsets.only(
                  top: a.width / 20,
                  right: a.width / 20,
                  left: a.width / 20,
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
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
                            onTap: () => nav.pop(context)),
                      ),
                    ),
                    Center(
                      child: Container(
                          height: screenHeightDp / 2.4,
                          decoration: BoxDecoration(
                              color: Color(0xff282828),
                              borderRadius:
                                  BorderRadius.circular(a.width / 50)),
                          width: a.width,
                          padding: EdgeInsets.all(a.width / 50),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(a.width / 25),
                                child: SizedBox(
                                  width: a.width,
                                  child: Text(
                                    'คุณสามารถเปิดหรือปิดรับการปาได้โดยการเปิดปิดสวิตซ์ คุณสามารถร้องเรียนได้ทุกเมื่อหากสแครปเหล่านั้นผิดต่อข้อกำหนดของเรา',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: s46),
                                  ),
                                ),
                              ),
                              StatefulBuilder(
                                  builder: (context, StateSetter setSwitch) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'ปิดการปา',
                                      style: TextStyle(
                                          color: isOn
                                              ? Colors.white
                                              : Color(0xfff27A4FF),
                                          fontWeight: FontWeight.bold,
                                          fontSize: s42),
                                    ),
                                    SizedBox(width: 7.2),
                                    Transform.scale(
                                        scale: 1.3,
                                        child: Switch(
                                            value: isOn,
                                            onChanged: (value) =>
                                                setSwitch(() => isOn = value),
                                            inactiveTrackColor: Colors.grey,
                                            activeTrackColor: Colors.blue,
                                            activeColor: Colors.white)),
                                    SizedBox(width: 7.2),
                                    Text(
                                      'เปิดการปา',
                                      style: TextStyle(
                                          color: isOn
                                              ? Color(0xfff27A4FF)
                                              : Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: s42),
                                    ),
                                  ],
                                );
                              }),
                              SizedBox(height: appBarHeight / 3.2),
                              GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        appBarHeight / 2,
                                        appBarHeight / 22,
                                        appBarHeight / 2,
                                        appBarHeight / 22),
                                    decoration: BoxDecoration(
                                        color: Color(0xfff27A4FF),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(23))),
                                    child: Text(
                                      'เข้าใจแล้ว',
                                      style: TextStyle(
                                          color: Color(0xfffFFFFFF),
                                          fontSize: s52,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  onTap: () async {
                                    nav.pop(context);
                                  }),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      });
}
