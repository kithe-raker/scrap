import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scrap/function/world/worldFunction.dart';
import 'package:scrap/provider/createWorldProvider.dart';
import 'package:scrap/theme/AppColors.dart';
import 'package:scrap/theme/ScreenUtil.dart';
import 'package:scrap/widget/Loading.dart';

class ConfigWorld extends StatefulWidget {
  @override
  _ConfigWorldState createState() => _ConfigWorldState();
}

class _ConfigWorldState extends State<ConfigWorld> {
  String mapSelect = 'ทมิฬ';
  int writePermission = 0;
  bool loading = false;
  StreamSubscription loadStatus;

  _mapSelect(String texture) {
    setState(() {
      mapSelect = texture;
    });
  }

  _writePermission(int permission) {
    setState(() {
      writePermission = permission;
    });
  }

  Widget mapTexture(String name, String img) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(right: screen.setWidth(30)),
        color: AppColors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: screen.setWidth(250),
                  height: screen.setHeight(365),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screen.setWidth(30)),
                    color: AppColors.imagePlaceholder,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(screen.setWidth(30)),
                    child: Image.network(
                      img,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                mapSelect == name
                    ? Container(
                        width: screen.setWidth(250),
                        height: screen.setHeight(365),
                        child: Center(
                          child: Container(
                            width: screen.setWidth(74),
                            height: screen.setWidth(74),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(screenWidthDp),
                              color: AppColors.scrapblue,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color: AppColors.white,
                                size: screen.setSp(42),
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: screenWidthDp / 30),
              child: Text(
                name,
                style: TextStyle(
                    color: mapSelect == name
                        ? AppColors.scrapblue
                        : AppColors.white,
                    fontSize: screen.setSp(40)),
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
  void initState() {
    loadStatus =
        worldFunction.load.listen((value) => setState(() => loading = value));
    super.initState();
  }

  @override
  void dispose() {
    loadStatus.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final worldInfo = Provider.of<CreateWorldProvider>(context, listen: false);
    ScreenUtil.init(context,
        width: defaultScreenWidth,
        height: defaultScreenHeight,
        allowFontScaling: fontScaling);
    return Scaffold(
        backgroundColor: AppColors.black,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: AppColors.black,
                    width: screenWidthDp,
                    height: screen.setHeight(130),
                    padding: EdgeInsets.only(
                      top: screen.setHeight(15),
                      right: screen.setWidth(20),
                      left: screen.setWidth(20),
                      bottom: screen.setHeight(15),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            child: Container(
                              width: screen.setWidth(100),
                              height: screen.setHeight(75),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(screenWidthDp),
                                  color: AppColors.arrowBackBg),
                              child: Icon(
                                Icons.arrow_back,
                                color: AppColors.arrowBackIcon,
                                size: screen.setSp(48),
                              ),
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
              Container(
                margin: EdgeInsets.only(
                  top: screen.setHeight(130),
                ),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: screenWidthDp,
                      minHeight: screenHeightDp -
                          statusBarHeight -
                          screen.setHeight(130),
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 12,
                            child: Container(
                              margin: EdgeInsets.only(
                                left: screen.setWidth(70),
                                right: screen.setWidth(70),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'โลกนี้มีแต่เสียงเพลง',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: screen.setSp(65),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'ตั้งค่าสำหรับโลกของคุณ',
                                    style: TextStyle(
                                      height: 0.8,
                                      color: AppColors.white,
                                      fontSize: screen.setSp(40),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: screenHeightDp / 45,
                                    ),
                                    child: Divider(color: AppColors.divider),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 30,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: screen.setWidth(70),
                                      right: screen.setWidth(70),
                                    ),
                                    child: Text(
                                      'เลือกธีม',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: screen.setSp(45),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: screenHeightDp / 40),
                                    width: screenWidthDp,
                                    height: screen.setHeight(450),
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      physics: BouncingScrollPhysics(),
                                      children: <Widget>[
                                        SizedBox(
                                          width: screen.setWidth(70),
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
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 50,
                            child: Container(
                              margin: EdgeInsets.only(
                                top: screenHeightDp / 45,
                                left: screen.setWidth(70),
                                right: screen.setWidth(70),
                              ),
                              width: screenWidthDp,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Divider(
                                    color: AppColors.divider,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: screenHeightDp / 45,
                                    ),
                                    child: Text(
                                      'กำหนดสิทธิ์',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: screen.setSp(45),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: screenHeightDp / 40,
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                bottom: screenHeightDp / 20),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: screen.setWidth(34),
                                                  height: screen.setWidth(34),
                                                  margin: EdgeInsets.only(
                                                    right: screen.setWidth(20),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            ScreenUtil
                                                                .screenWidthDp),
                                                    border: Border.all(
                                                      color: AppColors.white60,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: writePermission == 0
                                                      ? Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                            screen.setWidth(4),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xff26A4FF),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    ScreenUtil
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        'คุณเท่านั้นที่สามารถเขียนได้',
                                                        style: TextStyle(
                                                          height: 0.8,
                                                          color:
                                                              AppColors.white,
                                                          fontSize:
                                                              screen.setSp(40),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        'มีเพียงคุณเท่านั้นที่สามารถเขียนกระดาษและโยนทิ้งไว้ในโลกนี้ได้\nผู้คนที่เข้าร่วมจะมีสิทธิ์อ่านกระดาษของคุณเขียนเพียงอย่างเดียว',
                                                        style: TextStyle(
                                                          color:
                                                              AppColors.white,
                                                          fontSize:
                                                              screen.setSp(32),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        child: Text(
                                                          "เหมาะกับใคร",
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .white60,
                                                            fontSize: screen
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
                                            _writePermission(0);
                                          },
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                bottom: screenHeightDp / 20),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: screen.setWidth(34),
                                                  height: screen.setWidth(34),
                                                  margin: EdgeInsets.only(
                                                    right: screen.setWidth(20),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            ScreenUtil
                                                                .screenWidthDp),
                                                    border: Border.all(
                                                      color: AppColors.white60,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: writePermission == 1
                                                      ? Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                            screen.setWidth(4),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xff26A4FF),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    ScreenUtil
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        'ทุกคนสามารถเขียนได้',
                                                        style: TextStyle(
                                                          height: 0.8,
                                                          color:
                                                              AppColors.white,
                                                          fontSize:
                                                              screen.setSp(40),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        'คุณและผู้คนที่เข้าร่วมในโลกของคุณจะมีสิทธิ์เขียนกระดาษ',
                                                        style: TextStyle(
                                                          color:
                                                              AppColors.white,
                                                          fontSize:
                                                              screen.setSp(32),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        child: Text(
                                                          "เหมาะกับใคร",
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .white60,
                                                            fontSize: screen
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
                                            _writePermission(1);
                                          },
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                bottom: screenHeightDp / 20),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: screen.setWidth(34),
                                                  height: screen.setWidth(34),
                                                  margin: EdgeInsets.only(
                                                    right: screen.setWidth(20),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            ScreenUtil
                                                                .screenWidthDp),
                                                    border: Border.all(
                                                      color: AppColors.white60,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: writePermission == 2
                                                      ? Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                            screen.setWidth(4),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xff26A4FF),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    ScreenUtil
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        'คุณและสหายผู้ได้รับสิทธิ์สามารถเขียนได้',
                                                        style: TextStyle(
                                                          height: 0.8,
                                                          color:
                                                              AppColors.white,
                                                          fontSize:
                                                              screen.setSp(40),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        'สหายที่คุณให้สิทธิ์จะสามารถช่วยกันเขียนกระดาษได้',
                                                        style: TextStyle(
                                                          color:
                                                              AppColors.white,
                                                          fontSize:
                                                              screen.setSp(32),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        child: Text(
                                                          "เหมาะกับใคร",
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .white60,
                                                            fontSize: screen
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
                                            _writePermission(2);
                                          },
                                        ),
                                        Container(
                                          width: screenWidthDp,
                                          height: screen.setHeight(110),
                                          margin: EdgeInsets.only(
                                              bottom: screenHeightDp / 40),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                screenWidthDp),
                                            color: AppColors.blueButton,
                                          ),
                                          child: InkWell(
                                            child: Center(
                                              child: Text(
                                                'สร้างโลก',
                                                style: TextStyle(
                                                  color:
                                                      AppColors.blueButtonText,
                                                  fontSize: screen.setSp(45),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              worldFunction.createWorld(context,
                                                  permission: writePermission,
                                                  theme: mapSelect,
                                                  writer: []);
                                            },
                                          ),
                                        )
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
                  ),
                ),
              ),
              loading ? Loading() : SizedBox()
            ],
          ),
        ));
  }
}
