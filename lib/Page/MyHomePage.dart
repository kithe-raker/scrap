import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:scrap/Page/ScrapFeed.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int page = 0;

  void _showModalSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black,
          height: ScreenUtil.screenHeightDp,
          width: ScreenUtil.screenWidthDp,
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: (ScreenUtil.screenWidthDp / 6.5) +
                        ScreenUtil.statusBarHeight),
                // color: Colors.white,
                width: ScreenUtil.screenWidthDp,
                height: ScreenUtil.screenHeightDp -
                    ((ScreenUtil.screenWidthDp / 6.5) +
                        ScreenUtil.statusBarHeight),
                child: PreloadPageView(
                  pageSnapping: false,
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    ScrapFeed(),
                    ScrapFeed(),
                    ScrapFeed(),
                    ScrapFeed(),
                    ScrapFeed(),
                    ScrapFeed(),
                  ],
                ),
              ),
              Container(
                color: Colors.black,
                height: ScreenUtil.statusBarHeight,
                width: ScreenUtil.screenWidthDp,
                child: Center(
                  child: Icon(
                    Icons.expand_more,
                    color: Colors.grey[500],
                    size: ScreenUtil().setSp(52),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: ScreenUtil.statusBarHeight),
                  height: ScreenUtil.screenWidthDp / 6.5,
                  width: ScreenUtil.screenWidthDp,
                  padding: EdgeInsets.only(
                    top: ScreenUtil.screenHeightDp / 80,
                    right: ScreenUtil.screenWidthDp / 20,
                    left: ScreenUtil.screenWidthDp / 20,
                    bottom: ScreenUtil.screenHeightDp / 80,
                  ),
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Icon(
                          Icons.notifications,
                          color: Colors.grey[500],
                          size: ScreenUtil.screenWidthDp / 14,
                        ),
                        onTap: () {},
                      ),
                      Row(
                        children: <Widget>[
                          InkWell(
                            child: Text(
                              'กำลังติดตาม',
                              style: TextStyle(
                                  color: Color(0xff757575),
                                  fontSize: ScreenUtil().setSp(40),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setSp(40),
                            child: VerticalDivider(
                              color: Colors.white60,
                            ),
                          ),
                          InkWell(
                            child: Text(
                              'สำหรับคุณ',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: ScreenUtil().setSp(40),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        child: Icon(
                          Icons.mail,
                          color: Colors.grey[500],
                          size: ScreenUtil.screenWidthDp / 14,
                        ),
                        onTap: () {},
                      ),
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget scrapWorld(String worldName, String worldIcon, String owner) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(right: ScreenUtil.screenHeightDp / 100),
        width: ScreenUtil().setWidth(280),
        height: ScreenUtil().setHeight(105),
        decoration: BoxDecoration(
            color: Color(0xff232323),
            //color: worldIndex == 0 ? Color(0xff101010) : Color(0xff232323),
            borderRadius: BorderRadius.circular(ScreenUtil.screenWidthDp / 50),
            border: Border.all(
              color: Color(0xff232323),
              width: 0.2,
            )),
        child: Row(children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: ScreenUtil.screenWidthDp / 30),
              width: ScreenUtil.screenWidthDp / 12,
              child: Image.network(
                worldIcon,
              )),
          SizedBox(width: ScreenUtil.screenHeightDp / 110),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  worldName,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(26), color: Colors.white),
                ),
                Text(
                  '{ $owner }',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(26), color: Colors.white),
                )
              ])
        ]),
      ),
      // onTap: () {
      //   setState(() {
      //     page = worldIndex;
      //   });
      // },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black, //or set color with: Color(0xFF0000FF)
    ));
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return new Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: ScreenUtil.screenHeightDp,
              width: ScreenUtil.screenWidthDp,
              color: Color(0xff333333),
              child: Column(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            // ส่วนของ แทบสีดำด้านบน
                            color: Colors.black,
                            width: ScreenUtil.screenWidthDp,
                            height: ScreenUtil.screenWidthDp / 6.5,
                            padding: EdgeInsets.only(
                              top: ScreenUtil.screenHeightDp / 80,
                              right: ScreenUtil.screenWidthDp / 20,
                              left: ScreenUtil.screenWidthDp / 20,
                              bottom: ScreenUtil.screenHeightDp / 80,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  child: Icon(
                                    Icons.notifications,
                                    color: Colors.grey[500],
                                    size: ScreenUtil.screenWidthDp / 14,
                                  ),
                                  onTap: () {},
                                ),
                                Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil.screenWidthDp / 90),
                                    height: ScreenUtil.screenWidthDp / 7,
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/SCRAP.png',
                                      width: ScreenUtil.screenWidthDp / 2.5,
                                    )),
                                InkWell(
                                  child: Icon(
                                    Icons.mail,
                                    color: Colors.grey[500],
                                    size: ScreenUtil.screenWidthDp / 14,
                                  ),
                                  onTap: () {},
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          top: ScreenUtil.screenHeightDp / 50,
                        ),
                        // padding: EdgeInsets.only(
                        //     left: ScreenUtil.screenHeightDp / 50),
                        child: SizedBox(
                          height: ScreenUtil().setHeight(105), // card height
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              SizedBox(width: ScreenUtil.screenHeightDp / 50),
                              scrapWorld(
                                  'โลกหลัก',
                                  'https://tarit.in.th/scrap/assets/img/paper.png',
                                  'SCRAP'),
                              scrapWorld(
                                  'COVID-19',
                                  'https://freesvg.org/img/virus4.png',
                                  'SCRAP'),
                              scrapWorld(
                                  'คนรักลุง',
                                  'https://cdn1.iconfinder.com/data/icons/military-51/512/helmet-soldier-Army-military-512.png',
                                  'ไอแดงลูกพ่อ'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Row(
                children: <Widget>[
                  Container(
                    color: Color(0xff171717),
                    width: ScreenUtil.screenWidthDp,
                    height: ScreenUtil.screenWidthDp / 4.5,
                    child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            child: Container(
                                width: ScreenUtil.screenWidthDp / 5,
                                child: Center(
                                  child: Image.asset(
                                    'assets/paper.png',
                                    width: ScreenUtil.screenWidthDp / 12,
                                  ),
                                )),
                            onTap: _showModalSheet,
                          ),
                          InkWell(
                            child: Container(
                                // color: Colors.orangeAccent,
                                width: ScreenUtil.screenWidthDp / 5,
                                child: Center(
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.grey[600],
                                    size: ScreenUtil.screenWidthDp / 12,
                                  ),
                                )),
                          ),
                          InkWell(
                            child: Container(
                                width: ScreenUtil.screenWidthDp / 5,
                                height: ScreenUtil.screenWidthDp / 5,
                                decoration: new BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black38,
                                      blurRadius:
                                          20, // has the effect of softening the shadow
                                      spreadRadius:
                                          1, // has the effect of extending the shadow
                                      offset: Offset(
                                        0, // horizontal, move right 0
                                        10, // vertical, move down 10
                                      ),
                                    )
                                  ],
                                  color: Color(0xff171717),
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil.screenWidthDp),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.create,
                                    color: Colors.white,
                                    size: ScreenUtil.screenWidthDp / 10.5,
                                  ),
                                )),
                          ),
                          InkWell(
                            child: Container(
                                // color: Colors.redAccent,
                                width: ScreenUtil.screenWidthDp / 5,
                                child: Center(
                                  child: Icon(
                                    Icons.language,
                                    color: Colors.grey[600],
                                    size: ScreenUtil.screenWidthDp / 12,
                                  ),
                                )),
                          ),
                          InkWell(
                            child: Container(
                              // color: Colors.teal,
                              width: ScreenUtil.screenWidthDp / 5,
                              child: Center(
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              ScreenUtil.screenWidthDp),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 0.75,
                                          )),
                                      width: ScreenUtil.screenWidthDp / 13.5,
                                      height: ScreenUtil.screenWidthDp / 13.5,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil.screenWidthDp),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://scontent.fbkk5-5.fna.fbcdn.net/v/t1.0-1/p960x960/66777281_1177291532477111_3471558186308206592_o.jpg?_nc_cat=104&_nc_sid=dbb9e7&_nc_eui2=AeHAbuIw7tZMnY7ZtXr7iFsEoRmpoiNy4xAywafQwN8bkyOawOgVHOQpGf7Weg9U6J-Odin7yj_iWimxyfYnytxil4U67EIjyEhAM0S5pO5mFg&_nc_ohc=6_RF5mMA4CwAX9CT48F&_nc_ht=scontent.fbkk5-5.fna&_nc_tp=6&oh=1aa114787db5b6a20d86343c47f1fe03&oe=5E9917E0',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: new Container(
                                        padding: EdgeInsets.all(1),
                                        decoration: new BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(
                                                ScreenUtil.screenWidthDp),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 0.55,
                                            )),
                                        constraints: BoxConstraints(
                                          minWidth: 10,
                                          minHeight: 10,
                                        ),
                                        // child: Center(
                                        //   child: new Text(
                                        //     '2',
                                        //     style: new TextStyle(
                                        //       color: Colors.white,
                                        //       fontSize: 8,
                                        //     ),
                                        //     textAlign: TextAlign.center,
                                        //   ),
                                        // ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
