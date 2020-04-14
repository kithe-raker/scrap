import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfigWorld extends StatefulWidget {
  @override
  _ConfigWorldState createState() => _ConfigWorldState();
}

class _ConfigWorldState extends State<ConfigWorld> {
  String mapSelect = 'ทมิฬ';
  String writePermission = 'onlyme';

  _mapSelect(String texture) {
    setState(() {
      mapSelect = texture;
    });
  }

  _writePermission(String permission) {
    setState(() {
      writePermission = permission;
    });
  }

  Widget mapTexture(String name, String img) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(250),
                  height: ScreenUtil().setHeight(365),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(30)),
                    color: Colors.grey[900],
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(30)),
                    child: Image.network(
                      img,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                mapSelect == name
                    ? Container(
                        width: ScreenUtil().setWidth(250),
                        height: ScreenUtil().setHeight(365),
                        child: Center(
                          child: Container(
                            width: ScreenUtil().setWidth(74),
                            height: ScreenUtil().setWidth(74),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil.screenWidthDp),
                              color: Color(0xff26A4FF),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: ScreenUtil().setSp(42),
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: ScreenUtil.screenWidthDp / 30),
              child: Text(
                name,
                style: TextStyle(
                    color: mapSelect == name ? Color(0xff26A4FF) : Colors.white,
                    fontSize: ScreenUtil().setSp(40)),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        _mapSelect(name);
      },
    );
  }

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
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              top: ScreenUtil.screenHeightDp / 40),
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(40),
                            right: ScreenUtil().setWidth(40),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'โลกนี้มีแต่เสียงเพลง',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(65),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'ตั้งค่าสำหรับโลกของคุณ',
                                style: TextStyle(
                                  height: 0.8,
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(40),
                                ),
                              ),
                              SizedBox(height: ScreenUtil.screenHeightDp / 45),
                              Divider(color: Colors.white60),
                              SizedBox(height: ScreenUtil.screenHeightDp / 45),
                              Text(
                                'เลือกธีม',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(45),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: ScreenUtil.screenHeightDp / 40),
                          width: ScreenUtil.screenWidthDp,
                          height: ScreenUtil().setHeight(450),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            children: <Widget>[
                              SizedBox(
                                width: ScreenUtil().setWidth(40),
                              ),
                              mapTexture('ทมิฬ',
                                  'https://tarit.in.th/scrap/app_assets/dark.png'),
                              mapTexture('ค่ำคืน',
                                  'https://tarit.in.th/scrap/app_assets/night.png'),
                              mapTexture('กลางวัน',
                                  'https://tarit.in.th/scrap/app_assets/day.png'),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: ScreenUtil.screenHeightDp / 45),
                          width: ScreenUtil.screenWidthDp,
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(40),
                            right: ScreenUtil().setWidth(40),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Divider(
                                color: Colors.white60,
                              ),
                              SizedBox(height: ScreenUtil.screenHeightDp / 45),
                              Text(
                                'กำหนดสิทธิ์',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(45),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: ScreenUtil.screenHeightDp / 40,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            bottom:
                                                ScreenUtil.screenHeightDp / 20),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: ScreenUtil().setWidth(34),
                                              height: ScreenUtil().setWidth(34),
                                              margin: EdgeInsets.only(
                                                right:
                                                    ScreenUtil().setWidth(20),
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        ScreenUtil
                                                            .screenWidthDp),
                                                border: Border.all(
                                                  color: Colors.white60,
                                                  width: 1,
                                                ),
                                              ),
                                              child: writePermission == 'onlyme'
                                                  ? Container(
                                                      margin: EdgeInsets.all(
                                                        ScreenUtil()
                                                            .setWidth(4),
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff26A4FF),
                                                        borderRadius: BorderRadius
                                                            .circular(ScreenUtil
                                                                .screenWidthDp),
                                                      ),
                                                    )
                                                  : SizedBox(),
                                            ),
                                            Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'คุณเท่านั้นที่สามารถเขียนได้',
                                                    style: TextStyle(
                                                      height: 0.8,
                                                      color: Colors.white,
                                                      fontSize: ScreenUtil()
                                                          .setSp(40),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    'มีเพียงคุณเท่านั้นที่สามารถเขียนกระดาษและโยนทิ้งไว้ในโลกนี้ได้\nผู้คนที่เข้าร่วมจะมีสิทธิ์อ่านกระดาษของคุณเขียนเพียงอย่างเดียว',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: ScreenUtil()
                                                          .setSp(32),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    child: Text(
                                                      "เหมาะกับใคร",
                                                      style: TextStyle(
                                                        color: Colors.white60,
                                                        fontSize: ScreenUtil()
                                                            .setSp(32),
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                    ),
                                                    onTap: () {},
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        _writePermission('onlyme');
                                      },
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            bottom:
                                                ScreenUtil.screenHeightDp / 20),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: ScreenUtil().setWidth(34),
                                              height: ScreenUtil().setWidth(34),
                                              margin: EdgeInsets.only(
                                                right:
                                                    ScreenUtil().setWidth(20),
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        ScreenUtil
                                                            .screenWidthDp),
                                                border: Border.all(
                                                  color: Colors.white60,
                                                  width: 1,
                                                ),
                                              ),
                                              child: writePermission ==
                                                      'everyone'
                                                  ? Container(
                                                      margin: EdgeInsets.all(
                                                        ScreenUtil()
                                                            .setWidth(4),
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff26A4FF),
                                                        borderRadius: BorderRadius
                                                            .circular(ScreenUtil
                                                                .screenWidthDp),
                                                      ),
                                                    )
                                                  : SizedBox(),
                                            ),
                                            Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'ทุกคนสามารถเขียนได้',
                                                    style: TextStyle(
                                                      height: 0.8,
                                                      color: Colors.white,
                                                      fontSize: ScreenUtil()
                                                          .setSp(40),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    'คุณและผู้คนที่เข้าร่วมในโลกของคุณจะมีสิทธิ์เขียนกระดาษ',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: ScreenUtil()
                                                          .setSp(32),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    child: Text(
                                                      "เหมาะกับใคร",
                                                      style: TextStyle(
                                                        color: Colors.white60,
                                                        fontSize: ScreenUtil()
                                                            .setSp(32),
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                    ),
                                                    onTap: () {},
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        _writePermission('everyone');
                                      },
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            bottom:
                                                ScreenUtil.screenHeightDp / 20),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: ScreenUtil().setWidth(34),
                                              height: ScreenUtil().setWidth(34),
                                              margin: EdgeInsets.only(
                                                right:
                                                    ScreenUtil().setWidth(20),
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        ScreenUtil
                                                            .screenWidthDp),
                                                border: Border.all(
                                                  color: Colors.white60,
                                                  width: 1,
                                                ),
                                              ),
                                              child: writePermission ==
                                                      'allowed'
                                                  ? Container(
                                                      margin: EdgeInsets.all(
                                                        ScreenUtil()
                                                            .setWidth(4),
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff26A4FF),
                                                        borderRadius: BorderRadius
                                                            .circular(ScreenUtil
                                                                .screenWidthDp),
                                                      ),
                                                    )
                                                  : SizedBox(),
                                            ),
                                            Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'คุณและสหายผู้ได้รับสิทธิ์สามารถเขียนได้',
                                                    style: TextStyle(
                                                      height: 0.8,
                                                      color: Colors.white,
                                                      fontSize: ScreenUtil()
                                                          .setSp(40),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    'สหายที่คุณให้สิทธิ์จะสามารถช่วยกันเขียนกระดาษได้',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: ScreenUtil()
                                                          .setSp(32),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    child: Text(
                                                      "เหมาะกับใคร",
                                                      style: TextStyle(
                                                        color: Colors.white60,
                                                        fontSize: ScreenUtil()
                                                            .setSp(32),
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                    ),
                                                    onTap: () {},
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        _writePermission('allowed');
                                      },
                                    ),
                                    Container(
                                      width: ScreenUtil.screenWidthDp,
                                      height: ScreenUtil().setHeight(110),
                                      margin: EdgeInsets.only(
                                          bottom:
                                              ScreenUtil.screenHeightDp / 40),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil.screenWidthDp),
                                        color: Color(0xff26A4FF),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'สร้างโลก',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(45),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
