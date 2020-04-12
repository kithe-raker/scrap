import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainLogin extends StatefulWidget {
  @override
  _MainLoginState createState() => _MainLoginState();
}

class _MainLoginState extends State<MainLogin> {
  String loginMode = 'phone';

  changeLogin(String mode) {
    setState(() {
      loginMode = mode;
    });
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: ScreenUtil.screenWidthDp,
                    height: ScreenUtil().setHeight(130),
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(15),
                      right: ScreenUtil().setWidth(70),
                      left: ScreenUtil().setWidth(70),
                      bottom: ScreenUtil().setHeight(15),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            child: Container(
                              height: ScreenUtil().setHeight(80),
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/SCRAP.png',
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
              Expanded(
                flex: 15,
                child: Container(),
              ),
              Expanded(
                flex: 40,
                child: Container(
                  width: ScreenUtil.screenWidthDp,
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(70),
                    right: ScreenUtil().setWidth(70),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'ThaiSans',
                              height: 1.0,
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(40),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'สวัสดี!',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    ' เหล่านักเขียน นักอ่าน ทุกท่าน \nโลกของงานเขียนรอท่านอยู่หลังจากนี้ไป',
                              )
                            ]),
                      ),
                      loginMode == 'phone'
                          ? Container(
                              width: ScreenUtil.screenWidthDp,
                              height: ScreenUtil().setHeight(110),
                              margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(30),
                                bottom: ScreenUtil().setHeight(30),
                              ),
                              padding: EdgeInsets.fromLTRB(
                                  ScreenUtil().setWidth(50),
                                  ScreenUtil().setHeight(20),
                                  ScreenUtil().setWidth(50),
                                  ScreenUtil().setHeight(20)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil.screenWidthDp),
                                color: Color(0xff101010),
                              ),
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          '+66',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(40),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(10),
                                            right: ScreenUtil().setWidth(10),
                                          ),
                                          child: Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white,
                                            size: ScreenUtil().setSp(40),
                                          ),
                                        )
                                      ],
                                    ),
                                    VerticalDivider(
                                      color: Colors.white30,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(50),
                                        right: ScreenUtil().setWidth(50),
                                      ),
                                      child: Text(
                                        'หมายเลขโทรศัพท์',
                                        style: TextStyle(
                                          color: Colors.white30,
                                          fontSize: ScreenUtil().setSp(40),
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              width: ScreenUtil.screenWidthDp,
                              height: ScreenUtil().setHeight(110),
                              margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(30),
                                bottom: ScreenUtil().setHeight(30),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil.screenWidthDp),
                                color: Color(0xff101010),
                              ),
                              child: Center(
                                child: Text(
                                  '@penname',
                                  style: TextStyle(
                                    color: Colors.white30,
                                    fontSize: ScreenUtil().setSp(40),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                      Container(
                        width: ScreenUtil.screenWidthDp,
                        height: ScreenUtil().setHeight(110),
                        margin: EdgeInsets.only(
                            bottom: ScreenUtil.screenHeightDp / 40),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(ScreenUtil.screenWidthDp),
                          color: Color(0xff26A4FF),
                        ),
                        child: Center(
                          child: Text(
                            'ดำเนินการต่อ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(45),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          loginMode == 'phone'
                              ? 'ลงชื่อเข้าใช้ด้วยนามปากกา'
                              : 'ลงชื่อเข้าใช้ด้วยเบอร์โทรศัพท์',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            height: 1.0,
                            color: Colors.white70,
                            fontSize: ScreenUtil().setSp(38),
                          ),
                        ),
                        onTap: () {
                          changeLogin(
                              loginMode == 'phone' ? 'penname' : 'phone');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(70),
                        right: ScreenUtil().setWidth(70),
                      ),
                      width: ScreenUtil.screenWidthDp,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Divider(
                                  color: Colors.white24,
                                  thickness: 0.4,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(15),
                                  right: ScreenUtil().setWidth(15),
                                ),
                                child: Text(
                                  'หรือ',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: ScreenUtil().setSp(34),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.white24,
                                  thickness: 0.4,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(15),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                width: ScreenUtil().setWidth(80),
                                height: ScreenUtil().setWidth(80),
                                decoration: BoxDecoration(
                                  color: Color(0xff0D0D0D),
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil.screenWidthDp),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 0.2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'f',
                                    style: TextStyle(
                                      height: 1.2,
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(70),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                width: ScreenUtil().setWidth(80),
                                height: ScreenUtil().setWidth(80),
                                decoration: BoxDecoration(
                                  color: Color(0xff0D0D0D),
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil.screenWidthDp),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 0.2,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                width: ScreenUtil().setWidth(80),
                                height: ScreenUtil().setWidth(80),
                                decoration: BoxDecoration(
                                  color: Color(0xff0D0D0D),
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil.screenWidthDp),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 0.2,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: ScreenUtil.screenWidthDp,
                      margin:
                          EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
                      child: Center(
                        child: Text(
                          'created by BualoiTech Co.,Ltd.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(34),
                          ),
                        ),
                      ),
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
}
