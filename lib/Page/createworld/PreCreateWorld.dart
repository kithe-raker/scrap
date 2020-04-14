import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrap/Page/createworld/CreateWorld.dart';

class PreCreateWorld extends StatefulWidget {
  @override
  _PreCreateWorldState createState() => _PreCreateWorldState();
}

class _PreCreateWorldState extends State<PreCreateWorld> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
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
            Container(
              margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(130),
              ),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: ScreenUtil.screenWidthDp,
                    minHeight: ScreenUtil.screenHeightDp -
                        ScreenUtil.statusBarHeight -
                        ScreenUtil().setHeight(130),
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          flex: 12,
                          child: Container(
                            width: ScreenUtil.screenWidthDp,
                            margin: EdgeInsets.only(
                              right: ScreenUtil().setWidth(70),
                              left: ScreenUtil().setWidth(70),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'สร้างโลก',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(65),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'สร้างโลกในแบบที่คุณต้องการ',
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
                            width: ScreenUtil.screenWidthDp,
                            margin: EdgeInsets.only(
                              right: ScreenUtil().setWidth(70),
                              left: ScreenUtil().setWidth(70),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil.screenWidthDp),
                                    color: Colors.black,
                                  ),
                                  width: ScreenUtil.screenWidthDp / 1.4,
                                  height: ScreenUtil.screenWidthDp / 1.4,
                                  child: ClipRRect(
                                    child: Image.network(
                                      'https://tarit.in.th/scrap/app_assets/Group144.png',
                                      fit: BoxFit.contain,
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
                                  height: ScreenUtil().setWidth(100),
                                  margin: EdgeInsets.only(
                                    right: ScreenUtil().setWidth(70),
                                    left: ScreenUtil().setWidth(70),
                                  ),
                                  // margin:
                                  //     EdgeInsets.only(bottom: ScreenUtil.screenHeightDp / 40),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil.screenWidthDp),
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
                                      builder: (context) => CreateWorld(),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
