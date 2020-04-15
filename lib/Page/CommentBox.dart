import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrap/Page/Comment.dart';

class CommentBox extends StatefulWidget {
  @override
  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: ScreenUtil.screenWidthDp / 7,
                                height: ScreenUtil.screenWidthDp / 10,
                                margin: EdgeInsets.only(
                                    right: ScreenUtil.screenWidthDp / 15),
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
                          ]),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil.screenWidthDp / 5.5,
                ),
                width: ScreenUtil.screenWidthDp,
                padding: EdgeInsets.all(ScreenUtil.screenWidthDp / 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      // padding:
                      //     EdgeInsets.only(left: ScreenUtil.screenWidthDp / 35),
                      child: Text(
                        'ความคิดเห็นแบบแบ่งฝั่ง',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(65),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: ScreenUtil.screenHeightDp / 15),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          commentBox(
                              'https://tarit.in.th/scrap/assets/img/paper.png',
                              'กล่องความเห็น 1',
                              '12405'),
                          commentBox(
                              'https://tarit.in.th/scrap/assets/img/paper.png',
                              'กล่องความเห็น 2',
                              '3068'),
                          commentBox(
                              'https://tarit.in.th/scrap/assets/img/paper.png',
                              'กล่องความเห็น 3',
                              '258'),
                          commentBox(
                              'https://tarit.in.th/scrap/assets/img/paper.png',
                              'กล่องความเห็น 4',
                              '689'),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget commentBox(String icon, String boxName, String commentCount) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.all(ScreenUtil.screenWidthDp / 35),
        padding: EdgeInsets.all(ScreenUtil.screenWidthDp / 35),
        decoration: BoxDecoration(
          color: Color(0xff161616),
          borderRadius: BorderRadius.circular(ScreenUtil.screenWidthDp / 13.5),
        ),
        width: ScreenUtil.screenWidthDp / 3,
        height: ScreenUtil.screenWidthDp / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.network(
              icon,
              width: ScreenUtil.screenWidthDp / 5.5,
            ),
            Text(
              boxName,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(32),
                  fontWeight: FontWeight.bold),
            ),
            Text(
              commentCount,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: ScreenUtil().setSp(30),
                  height: 0.85),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Comment(),
            ));
      },
    );
  }
}
