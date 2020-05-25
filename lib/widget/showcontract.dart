import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scrap/widget/ScreenUtil.dart';

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
          screenutilInit(context);
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
                      height: a.height / 1.5,
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
                                        fontSize: a.width / 20),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: appBarHeight / 2,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                    appBarHeight / 2,
                                    appBarHeight / 22,
                                    appBarHeight / 2,
                                    appBarHeight / 22),
                                decoration: BoxDecoration(
                                    color: Color(0xfff27A4FF),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(23))),
                                child: GestureDetector(
                                  child: Text(
                                    'สัญญา',
                                    style: TextStyle(
                                        color: Color(0xfffFFFFFF),
                                        fontSize: s52,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ))),
                ],
              ),
            ),
          );
        });
      });
}
