import 'dart:ui';

import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:preload_page_view/preload_page_view.dart';

class PaperFeeds extends StatefulWidget {
  @override
  _PaperFeedsState createState() => _PaperFeedsState();
}

class _PaperFeedsState extends State<PaperFeeds> {
  List<String> url = [
    'https://instagram.fbkk5-7.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/s640x640/74496193_180550716432751_4368497480342609476_n.jpg?_nc_ht=instagram.fbkk5-7.fna.fbcdn.net&_nc_cat=107&_nc_ohc=ythxD97R8hcAX98QrMY&oh=b54c0122d77d33984438981f60bf97c7&oe=5EA551B3',
    'https://instagram.fbkk5-4.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/s750x750/71948004_259494461681979_146094019828017351_n.jpg?_nc_ht=instagram.fbkk5-4.fna.fbcdn.net&_nc_cat=103&_nc_ohc=54-yMyfuI2EAX-hx7r-&oh=3eb28e4912c39d9bd7247a88e652c955&oe=5EA1D8D5'
  ];
  String backUrl;
  bool blurBg = false;
  int horizontalIndex = 1;
  int itemCount = 3;

  void _blurBg(int number) {
    setState(() {
      if (number > 0) {
        backUrl = url[number - 1];
        blurBg = true;
      } else {
        blurBg = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.black, //or set color with: Color(0xFF0000FF)
    // ));
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Container(
          //   width: ScreenUtil.screenWidthDp,
          //   height: ScreenUtil.screenHeightDp,
          //   color: Colors.black,
          //   child: blurBg
          //       ? CachedNetworkImage(
          //           fadeInDuration: Duration(milliseconds: 300),
          //           imageUrl: backUrl,
          //           fit: BoxFit.cover,
          //         )
          //       : SizedBox(),
          // ),
          // horizontalIndex != 1
          //     ? BackdropFilter(
          //         child: Container(
          //           color: Colors.black12.withOpacity(0.55),
          //         ),
          //         filter: ImageFilter.blur(sigmaY: 20, sigmaX: 20),
          //       )
          //     : SizedBox(),
          Container(
            width: ScreenUtil.screenWidthDp,
            height: ScreenUtil.screenHeightDp,
            color: Colors.black,
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil.statusBarHeight),
            height: ScreenUtil.screenHeightDp,
            width: ScreenUtil.screenWidthDp,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Container(
                //   // color: Colors.blue,
                //   child: Icon(
                //     Icons.expand_more,
                //     color: Colors.grey.withOpacity(0.5),
                //     size: ScreenUtil().setSp(48),
                //   ),
                // ),
                Container(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(28),
                    right: ScreenUtil().setWidth(28),
                  ),
                  // color: Colors.amberAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'ID : 2810925607',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(36),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil.screenHeightDp / 100),
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(28),
                    right: ScreenUtil().setWidth(28),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        // color: Colors.amber,
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  right: ScreenUtil().setWidth(15)),
                              child: Icon(
                                Icons.place,
                                color: Colors.blue,
                                size: ScreenUtil().setSp(48),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'ห่างจากคุณประมาณ 200 เมตร',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(32),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'หาดใหญ่ สงขลา ประเทศไทย',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(32),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Icon(
                          Icons.info,
                          color: Colors.white,
                          size: ScreenUtil().setSp(48),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: ScreenUtil().setHeight(840),
                  margin: EdgeInsets.only(top: ScreenUtil.screenHeightDp / 60),
                  child: PreloadPageView(
                    // pageSnapping: false,
                    onPageChanged: (int index) {
                      setState(() {
                        horizontalIndex = index + 1;
                      });
                      _blurBg(index);
                    },
                    controller: PreloadPageController(viewportFraction: 1.0),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        // height: ScreenUtil().setHeight(840),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setHeight(12))),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: ScreenUtil.screenHeightDp,
                              width: ScreenUtil.screenWidthDp,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setHeight(12)),
                                child: Image.asset(
                                  'assets/paper-readed.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                                top: ScreenUtil().setHeight(30),
                                left: ScreenUtil().setHeight(30),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'เขียนโดย : @lalalalisa_m',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: ScreenUtil().setSp(32),
                                            ),
                                          ),
                                          Text(
                                            'เวลา : 09.37',
                                            style: TextStyle(
                                              height: 1,
                                              color: Colors.grey,
                                              fontSize: ScreenUtil().setSp(32),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                            itemCount > 1
                                ? Positioned(
                                    bottom: ScreenUtil().setHeight(30),
                                    right: ScreenUtil().setHeight(30),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(20),
                                          right: ScreenUtil().setWidth(20)),
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.35),
                                          borderRadius: BorderRadius.circular(
                                              ScreenUtil.screenWidth)),
                                      child: Text(
                                        '$horizontalIndex/$itemCount',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(32),
                                        ),
                                      ),
                                    ))
                                : SizedBox(),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(25),
                                  right: ScreenUtil().setWidth(25)),
                              height: ScreenUtil().setHeight(840),
                              child: Text(
                                'โบ้ยสะเด่าบัสสเก็ตช์โอเปร่า แผดเผาสมาพันธ์แจ๊กเก็ตวอล์คสคริปต์ เซ็กส์ชัวร์ แกงค์สตีลมาร์ช อินดอร์ตุ๊ด แก๊สโซฮอล์พาสต้าไพลิน คันยิติวแทกติค จิ๊กซอว์แคมป์ สันทนาการ ท็อปบูตคอร์รัปชันหลวงปู่ละตินมาร์ค ทัวร์นาเมนท์เวณิกาซิตีเวอร์ เยอร์บีรา โปรเจ็กต์โง่เขลา สคริปต์โปรเจคท์ม้ง ภควัมบดีอัลตรา แชมเปญแอปเปิ้ล',
                                //'อร่อยมากเลยค่ะ',
                                style: TextStyle(
                                  height: 1.35,
                                  fontSize: ScreenUtil().setSp(48),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setHeight(12))),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: ScreenUtil.screenHeightDp,
                              width: ScreenUtil.screenWidthDp,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setHeight(12)),
                                child: CachedNetworkImage(
                                  fadeInDuration: Duration(milliseconds: 300),
                                  imageUrl: url[0],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            itemCount > 1
                                ? Positioned(
                                    bottom: ScreenUtil().setHeight(30),
                                    right: ScreenUtil().setHeight(30),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(20),
                                          right: ScreenUtil().setWidth(20)),
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.35),
                                          borderRadius: BorderRadius.circular(
                                              ScreenUtil.screenWidth)),
                                      child: Text(
                                        '$horizontalIndex/$itemCount',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(32),
                                        ),
                                      ),
                                    ))
                                : SizedBox(),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setHeight(12))),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: ScreenUtil.screenHeightDp,
                              width: ScreenUtil.screenWidthDp,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setHeight(12)),
                                child: CachedNetworkImage(
                                  fadeInDuration: Duration(milliseconds: 300),
                                  imageUrl: url[1],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            itemCount > 1
                                ? Positioned(
                                    bottom: ScreenUtil().setHeight(30),
                                    right: ScreenUtil().setHeight(30),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(20),
                                          right: ScreenUtil().setWidth(20)),
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.35),
                                          borderRadius: BorderRadius.circular(
                                              ScreenUtil.screenWidth)),
                                      child: Text(
                                        '$horizontalIndex/$itemCount',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(32),
                                        ),
                                      ),
                                    ))
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil.screenHeightDp / 30),
                  width: ScreenUtil().setWidth(500),
                  height: ScreenUtil().setHeight(110),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius:
                          BorderRadius.circular(ScreenUtil.screenWidth)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          // color: Colors.lightGreen,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '120K',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(26),
                                  ),
                                ),
                                Icon(
                                  Icons.share,
                                  color: Colors.white,
                                  size: ScreenUtil().setSp(36),
                                ),
                              ]),
                        ),
                      ),
                      InkWell(
                        child: Container(
                          // color: Colors.lightGreen,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '360K',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(26),
                                  ),
                                ),
                                Icon(
                                  Icons.mode_comment,
                                  color: Colors.white,
                                  size: ScreenUtil().setSp(36),
                                ),
                              ]),
                        ),
                      ),
                      InkWell(
                        child: Container(
                          // color: Colors.lightGreen,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '10K',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(26),
                                  ),
                                ),
                                Icon(
                                  Icons.turned_in,
                                  color: Colors.white,
                                  size: ScreenUtil().setSp(36),
                                ),
                              ]),
                        ),
                      ),
                      InkWell(
                        child: Container(
                          // color: Colors.lightGreen,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '1.12M',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(26),
                                  ),
                                ),
                                Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: ScreenUtil().setSp(36),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
