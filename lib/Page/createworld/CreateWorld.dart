import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrap/Page/createworld/ConfigWorld.dart';

class CreateWorld extends StatefulWidget {
  @override
  _CreateWorldState createState() => _CreateWorldState();
}

class _CreateWorldState extends State<CreateWorld> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Container(
            height: ScreenUtil.screenHeightDp,
            width: ScreenUtil.screenWidthDp,
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      color: Colors.black,
                      width: ScreenUtil.screenWidthDp,
                      height: ScreenUtil().setHeight(130),
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(15),
                        right: ScreenUtil().setWidth(20),
                        left: ScreenUtil().setWidth(20),
                        bottom: ScreenUtil().setHeight(15),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                width: ScreenUtil().setWidth(100),
                                height: ScreenUtil().setHeight(75),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil.screenWidthDp),
                                    color: Colors.white),
                                child: Icon(Icons.arrow_back,
                                    color: Colors.black,
                                    size: ScreenUtil().setSp(48)),
                              ),
                              onTap: () {
                                Navigator.pop(
                                  context,
                                );
                              },
                            ),
                          ]),
                    ),
                  ],
                ),
                Expanded(
                  flex: 12,
                  child: Container(
                    margin: EdgeInsets.only(
                      right: ScreenUtil().setWidth(40),
                      left: ScreenUtil().setWidth(40),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'เริ่มกันเลย!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(65),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'เพิ่มข้อมูลเพื่อให้ผู้คนรู้จักโลกของคุณ',
                          style: TextStyle(
                            height: 0.8,
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(40),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 70,
                  child: Container(
                    margin: EdgeInsets.only(
                      right: ScreenUtil().setWidth(40),
                      left: ScreenUtil().setWidth(40),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              top: ScreenUtil.screenHeightDp / 40,
                              bottom: ScreenUtil.screenHeightDp / 60),
                          child: Center(
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: ScreenUtil().setWidth(300),
                                  width: ScreenUtil().setWidth(300),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil.screenWidthDp),
                                    border: Border.all(
                                      color: Color(0xff8E8E8E),
                                      width: 1.5,
                                    ),
                                  ),
                                  // child: ClipRRect(
                                  //   borderRadius:
                                  //       BorderRadius.circular(300),
                                  //   child: Image.network(
                                  //     'https://tarit.in.th/scrap/app_assets/globe-01-512.png',
                                  //     fit: BoxFit.cover,
                                  //   ),
                                  // ),
                                ),
                                Positioned(
                                  right: ScreenUtil().setWidth(20),
                                  bottom: ScreenUtil().setWidth(0),
                                  child: Container(
                                    height: ScreenUtil().setWidth(56),
                                    width: ScreenUtil().setWidth(56),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil.screenWidthDp),
                                    ),
                                    child: Icon(
                                      Icons.create,
                                      color: Color(0xff4A4A4A),
                                      size: ScreenUtil().setSp(34),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Text(
                          'ชื่อโลก',
                          style: TextStyle(
                            // height: 0.8,
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(40),
                          ),
                        ),
                        Container(
                          width: ScreenUtil.screenWidthDp,
                          height: ScreenUtil().setHeight(110),
                          margin: EdgeInsets.only(
                              bottom: ScreenUtil.screenHeightDp / 60,
                              top: ScreenUtil.screenHeightDp / 80),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(ScreenUtil.screenWidthDp),
                            color: Color(0xff101010),
                          ),
                          child: Center(
                            child: Text(
                              'ชื่อโลกของคุณ',
                              style: TextStyle(
                                color: Colors.white30,
                                fontSize: ScreenUtil().setSp(40),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'คำอธิบายสั้น ๆ',
                          style: TextStyle(
                            // height: 0.8,
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(40),
                          ),
                        ),
                        Container(
                          width: ScreenUtil.screenWidthDp,
                          height: ScreenUtil().setHeight(110),
                          margin: EdgeInsets.only(
                              bottom: ScreenUtil.screenHeightDp / 60,
                              top: ScreenUtil.screenHeightDp / 80),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(ScreenUtil.screenWidthDp),
                            color: Color(0xff101010),
                          ),
                          child: Center(
                            child: Text(
                              'เกี่ยวกับโลกของคุณ',
                              style: TextStyle(
                                color: Colors.white30,
                                fontSize: ScreenUtil().setSp(40),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 18,
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          width: ScreenUtil.screenWidthDp,
                          height: ScreenUtil().setHeight(110),
                          margin: EdgeInsets.only(
                            right: ScreenUtil().setWidth(40),
                            left: ScreenUtil().setWidth(40),
                          ),
                          // margin:
                          //     EdgeInsets.only(bottom: ScreenUtil.screenHeightDp / 40),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(ScreenUtil.screenWidthDp),
                            color: Color(0xffffffff),
                          ),
                          child: Center(
                            child: Text(
                              'ต่อไป',
                              style: TextStyle(
                                color: Colors.grey[850],
                                fontSize: ScreenUtil().setSp(45),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfigWorld(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
