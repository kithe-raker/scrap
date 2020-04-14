import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Comment extends StatefulWidget {
  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  var tx = TextEditingController();

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
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: ScreenUtil.screenWidthDp / 5.5),
                width: ScreenUtil.screenWidthDp,
                height: ScreenUtil.screenHeightDp -
                    ((ScreenUtil.screenWidthDp / 5.5) * 2),
                color: Colors.black,
                padding: EdgeInsets.only(
                  // top: ScreenUtil.screenHeightDp / 50,
                  right: ScreenUtil.screenWidthDp / 20,
                  left: ScreenUtil.screenWidthDp / 20,
                  bottom: ScreenUtil.screenHeightDp / 50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil.screenHeightDp / 55,
                                  bottom: ScreenUtil.screenHeightDp / 55),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.replay,
                                    color: Colors.white60,
                                    size: ScreenUtil().setSp(40),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'ดูความคิดเห็นก่อนหน้า',
                                    style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: ScreenUtil().setSp(40),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          commentChip(
                              'ไอแดงลูกพ่อ',
                              'https://storage.thaipost.net/main/uploads/photos/big/20191011/image_big_5da028c93088d.jpg',
                              'สู้ไปด้วยกัน',
                              '10:58 18 มีนาคม 2020'),
                          commentChip(
                              'ลุงพรชัย',
                              'https://www.thairath.co.th/media/dFQROr7oWzulq5FZYkSMwXE9A1XvNQQeX9o5eqVV9bVBdBnFOJuCUoo7rtfwrfCvDJi.jpg',
                              'ขอให้ประเทศไทยผ่านวิกฤตนี้ไปได้ค่ะ',
                              '15 ชั่วโมงที่แล้ว'),
                          commentChip(
                              'ตู่มาแว้ว',
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRUBheK-Lvo4EQG5V7gWFgOaQBN9DlQX8ZhMiop3Vkh9jIW0CMr',
                              'ผมจะดูแลประชาชนให้ดีที่สุดครับ',
                              '2 นาทีที่แล้ว'),
                          commentChip(
                              'บิ้กป้อม',
                              'https://siamrath.co.th/files/styles/1140/public/img/20190811/1bebd9268892945e74b2ba669a881b7071250b816cb97cc053111463718ccb5c.jpg?itok=kRopIDa0',
                              'สู้ ๆ ตู่น้องพี่',
                              'เมื่อสักครู่'),
                          SizedBox(height: ScreenUtil.screenHeightDp / 55)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      color: Colors.black,
                      width: ScreenUtil.screenWidthDp,
                      height: ScreenUtil.screenWidthDp / 5.5,
                      padding: EdgeInsets.only(
                        top: ScreenUtil.screenHeightDp / 80,
                        right: ScreenUtil.screenWidthDp / 20,
                        left: ScreenUtil.screenWidthDp / 20,
                        bottom: ScreenUtil.screenHeightDp / 80,
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            //Logo
                            InkWell(
                              child: Container(
                                width: ScreenUtil.screenWidthDp / 7,
                                height: ScreenUtil.screenWidthDp / 10,
                                margin: EdgeInsets.only(
                                    right: ScreenUtil.screenWidthDp / 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil.screenWidthDp),
                                    color: Colors.white),
                                child: Icon(Icons.arrow_back,
                                    color: Colors.black,
                                    size: ScreenUtil.screenWidthDp / 15),
                              ),
                              onTap: () {
                                Navigator.pop(
                                  context,
                                );
                              },
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'กล่องความเห็น 1',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(46),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '12,405 ความคิดเห็น',
                                  style: TextStyle(
                                      height: 0.6,
                                      color: Color(0xff757575),
                                      fontSize: ScreenUtil().setSp(35),
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: ScreenUtil.screenWidthDp,
                      height: ScreenUtil.screenWidthDp / 6.5,
                      padding: EdgeInsets.only(
                        top: ScreenUtil.screenWidthDp / 50,
                        right: ScreenUtil.screenWidthDp / 20,
                        left: ScreenUtil.screenWidthDp / 20,
                        bottom: ScreenUtil.screenWidthDp / 50,
                      ),
                      decoration: BoxDecoration(
                          color: Color(0xff272727),
                          borderRadius: BorderRadius.only(
                            topLeft:
                                Radius.circular(ScreenUtil.screenWidthDp / 40),
                            topRight:
                                Radius.circular(ScreenUtil.screenWidthDp / 40),
                          )),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: ScreenUtil.screenHeightDp / 15,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(
                                  right: ScreenUtil.screenWidthDp / 20,
                                  left: ScreenUtil.screenWidthDp / 20,
                                ),
                                decoration: BoxDecoration(
                                    color: Color(0xff313131),
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil.screenWidthDp / 15),
                                    border: Border.all(
                                      color: Colors.white38,
                                      width: 0.2,
                                    )),
                                child: TextField(
                                  cursorColor: Colors.grey,
                                  controller: tx,
                                  maxLines: null,
                                  // textInputAction: TextInputAction.newline,
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(36),
                                    color: Colors.grey[350],
                                  ),
                                  decoration: InputDecoration(
                                    border:
                                        InputBorder.none, //สำหรับใหเส้นใต้หาย
                                    hintText: 'เขียนความคิดเห็น',
                                    hintStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(36),
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                  margin: EdgeInsets.only(
                                      left: ScreenUtil.screenWidthDp / 30),
                                  child: Center(
                                    child: Icon(
                                      Icons.send,
                                      color: Colors.white70,
                                      size: ScreenUtil().setSp(45),
                                    ),
                                  )),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget commentChip(String name, String img, String text, String time) {
    return Container(
      margin: EdgeInsets.only(bottom: ScreenUtil.screenHeightDp / 55),
      padding: EdgeInsets.only(
        top: ScreenUtil.screenWidthDp / 20,
        right: ScreenUtil.screenWidthDp / 20,
        left: ScreenUtil.screenWidthDp / 20,
        bottom: ScreenUtil.screenWidthDp / 20,
      ),
      decoration: BoxDecoration(
          color: Color(0xff161616),
          borderRadius: BorderRadius.circular(ScreenUtil.screenWidthDp / 30)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(ScreenUtil.screenWidthDp),
                    border: Border.all(
                      color: Colors.white,
                      width: 0.75,
                    )),
                width: ScreenUtil.screenWidthDp / 9,
                height: ScreenUtil.screenWidthDp / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ScreenUtil.screenWidthDp),
                  child: CachedNetworkImage(
                    fadeInDuration: Duration(milliseconds: 100),
                    imageUrl: img,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: ScreenUtil.screenWidthDp / 40,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '@$name',
                    style: TextStyle(
                        height: 0.95,
                        color: Color(0xff26A4FF),
                        fontSize: ScreenUtil().setSp(42)),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                        height: 0.95,
                        color: Colors.white54,
                        fontSize: ScreenUtil().setSp(35)),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: ScreenUtil.screenHeightDp / 70,
          ),
          Text(
            text,
            style: TextStyle(
                color: Colors.white, fontSize: ScreenUtil().setSp(42)),
          )
        ],
      ),
    );
  }
}
