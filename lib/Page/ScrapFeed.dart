import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:scrap/Page/CommentBox.dart';

class ScrapFeed extends StatefulWidget {
  @override
  _ScrapFeedState createState() => _ScrapFeedState();
}

class _ScrapFeedState extends State<ScrapFeed>
    with AutomaticKeepAliveClientMixin {
  List<String> url = [];
  int horizontalIndex = 1;
  int itemCount = 5;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print('initState');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: ScreenUtil.screenHeightDp -
              ((ScreenUtil.screenWidthDp / 6.5) + ScreenUtil.statusBarHeight),
          width: ScreenUtil.screenWidthDp,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
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
                                right: ScreenUtil.screenWidthDp / 35),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil.screenWidthDp),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 0.75,
                                )),
                            width: ScreenUtil.screenWidthDp / 11,
                            height: ScreenUtil.screenWidthDp / 11,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil.screenWidthDp),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://scontent.fbkk5-7.fna.fbcdn.net/v/t1.0-9/58460842_2234641039954910_7316182265648644096_n.png?_nc_cat=107&_nc_sid=85a577&_nc_eui2=AeH0sqsZke-sI0BsX_F_IkHut4uK1iYycuwzHCrob3xFsshgs4QsHy9JF4P-fLnsqU6Ex2Jq_7cR_8vK0KzvO47jiXhfz2c4UBLIrrxGIX3TGA&_nc_ohc=BqfqeZTcbbAAX_5oUdF&_nc_ht=scontent.fbkk5-7.fna&oh=b6ac5a610979978876fcd129bef5e26e&oe=5EA863B2',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '@ichoemtravel',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(35),
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'Pulau Penang, Malaysia',
                                style: TextStyle(
                                  height: 0.9,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'เมื่อสักครู่',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: ScreenUtil().setSp(29),
                            ),
                          ),
                          Icon(
                            Icons.info,
                            color: Colors.white,
                            size: ScreenUtil().setSp(36),
                          ),
                        ],
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
                  physics: BouncingScrollPhysics(),
                  onPageChanged: (int index) {
                    setState(() {
                      horizontalIndex = index + 1;
                    });
                  },
                  controller: PreloadPageController(viewportFraction: 1.0),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    paperPage('text', 'ichaoem', '09.37',
                        'Pulau Penang : ปูลัว ปีนัง เมืองแห่งความหลากหลายทางวัฒนธรรม ถ้าพูดถึงปีนัง..คงจะไม่พูดถึงความงดงามของบ้านเมืองที่มีเสน่ห์และความสวยงามก็คงไม่ได้'),
                    paperPage('photo', 'ichaoem', '09.37',
                        'https://scontent.fbkk5-5.fna.fbcdn.net/v/t1.0-9/61513189_2290580201027660_1752653313137967104_o.jpg?_nc_cat=100&_nc_sid=e007fa&_nc_eui2=AeEWaDzrDzBgI1w_S26igG7oo34EoX9ggMoWkVD2oKjaQ9LCh519OgB4VT2AE3auW9wqrFNmiB0CxDm9MLvsFVmOwp1-vClh8ibvs0peZSxJ9Q&_nc_ohc=Fsw_UH84T6YAX_pXDHV&_nc_ht=scontent.fbkk5-5.fna&oh=e6fbcc38f08b1993d9f4e2a02f5abea9&oe=5EA203CD'),
                    paperPage('photo', 'ichaoem', '09.37',
                        'https://scontent.fbkk5-3.fna.fbcdn.net/v/t1.0-9/74593551_2562981090454235_2223796240368271360_o.jpg?_nc_cat=111&_nc_sid=e007fa&_nc_eui2=AeEubHfrXvoAsrs5YRL2VniWbRyzdo1YZyuUcpHWtXrYUztSgS6oPtzSJ4ZgZvouj_gYWQBzLfEvUCxstghBu1VVJySG-wxIw9jgcG4-ut7PBA&_nc_ohc=_aQYX1TXJAMAX-IdIAc&_nc_ht=scontent.fbkk5-3.fna&oh=e0e0d0d63122766122a6aca91bafc329&oe=5EA41B42'),
                    paperPage('photo', 'ichaoem', '09.37',
                        'https://scontent.fbkk5-5.fna.fbcdn.net/v/t1.0-9/75210127_2562982303787447_86539678299193344_o.jpg?_nc_cat=104&_nc_sid=e007fa&_nc_eui2=AeFAMfxb6K74WwUqvVsQo5EmHBMZUDsTp9P8ntl4WODChf_7c9R98Gjp8P5A-eokr18HNGSWcFvJQi29V2hI53CNTlV5GgGJgScSmr_lCoILiA&_nc_ohc=NpPQfCDIiTEAX9EB0am&_nc_ht=scontent.fbkk5-5.fna&oh=74151fbb7fff93aaecdfc705ed510ca7&oe=5EA20060'),
                    paperPage('text', 'ichaoem', '09.37',
                        'โบ้ยสะเด่าบัสสเก็ตช์โอเปร่า แผดเผาสมาพันธ์แจ๊กเก็ตวอล์คสคริปต์ เซ็กส์ชัวร์ แกงค์สตีลมาร์ช อินดอร์ตุ๊ด แก๊สโซฮอล์พาสต้าไพลิน คันยิติวแทกติค จิ๊กซอว์แคมป์ สันทนาการ ท็อปบูตคอร์รัปชันหลวงปู่ละตินมาร์ค ทัวร์นาเมนท์เวณิกาซิตีเวอร์ เยอร์บีรา โปรเจ็กต์โง่เขลา สคริปต์โปรเจคท์ม้ง ภควัมบดีอัลตรา แชมเปญแอปเปิ้ล'),
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
                              InkWell(
                                child: Icon(
                                  Icons.mode_comment,
                                  color: Colors.white,
                                  size: ScreenUtil().setSp(36),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CommentBox(),
                                      ));
                                },
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
    );
  }

  Widget paperPage(
      String paperType, String owner, String time, String content) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      // height: ScreenUtil().setHeight(840),
      decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(
            ScreenUtil().setHeight(12),
            // border: Border.all(
            //   color: Colors.white,
            //   width: 8,
            // ),
          )),
      child: Stack(
        children: <Widget>[
          paperType == 'text'
              ? Container(
                  height: ScreenUtil.screenHeightDp,
                  width: ScreenUtil.screenWidthDp,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setHeight(12)),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setHeight(12)),
                    child: Image.asset(
                      'assets/paper-readed.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(
                  height: ScreenUtil.screenHeightDp,
                  width: ScreenUtil.screenWidthDp,
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setHeight(12)),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setHeight(12)),
                    child: Image.network(
                      content,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          // paperType == 'text'
          //     ? Positioned(
          //         top: ScreenUtil().setHeight(30),
          //         left: ScreenUtil().setHeight(30),
          //         child: Container(
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: <Widget>[
          //               Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: <Widget>[
          //                   Text(
          //                     'เขียนโดย : @$owner',
          //                     style: TextStyle(
          //                       color: Colors.grey,
          //                       fontSize: ScreenUtil().setSp(32),
          //                     ),
          //                   ),
          //                   Text(
          //                     'เวลา : $time',
          //                     style: TextStyle(
          //                       height: 1,
          //                       color: Colors.grey,
          //                       fontSize: ScreenUtil().setSp(32),
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ))
          //     : SizedBox(),
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
                        borderRadius:
                            BorderRadius.circular(ScreenUtil.screenWidth)),
                    child: Text(
                      '$horizontalIndex/$itemCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(32),
                      ),
                    ),
                  ))
              : SizedBox(),
          paperType == 'text'
              ? Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(25),
                      right: ScreenUtil().setWidth(25)),
                  height: ScreenUtil().setHeight(840),
                  child: Text(
                    content,
                    style: TextStyle(
                      height: 1.35,
                      fontSize: ScreenUtil().setSp(48),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
