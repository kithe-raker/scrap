import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhoneWithOTP extends StatefulWidget {
  @override
  _PhoneWithOTPState createState() => _PhoneWithOTPState();
}

class _PhoneWithOTPState extends State<PhoneWithOTP> {
  String loginMode = 'otp';
  bool requestOTP = true;

  @override
  void initState() {
    super.initState();
    getOTP();
  }

  Timer _timer;
  int _start = 60;

  void getOTP() {
    setState(() {
      requestOTP = false;
    });
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            setState(() {
              _start = 60;
              requestOTP = true;
            });
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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
                        mainAxisAlignment: MainAxisAlignment.start,
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
                          Container(
                            margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(60),
                            ),
                            child: Text(
                              'ลงชื่อเข้าใช้',
                              style: TextStyle(
                                height: 1.0,
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(45),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
              Expanded(
                flex: 5,
                child: Container(),
              ),
              Expanded(
                flex: 50,
                child: Container(
                  width: ScreenUtil.screenWidthDp,
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(70),
                    right: ScreenUtil().setWidth(70),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil.screenWidthDp,
                        height: ScreenUtil().setHeight(110),
                        margin: EdgeInsets.only(
                          // top: ScreenUtil().setHeight(30),
                          bottom: ScreenUtil().setHeight(30),
                        ),
                        padding: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(50),
                            ScreenUtil().setHeight(20),
                            ScreenUtil().setWidth(20),
                            ScreenUtil().setHeight(20)),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(ScreenUtil.screenWidthDp),
                          color: Color(0xff101010),
                        ),
                        child: Container(
                          //color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
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
                                      ),
                                      VerticalDivider(
                                        color: Colors.white30,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(30),
                                        // right: ScreenUtil().setWidth(50),
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
                                    loginMode == 'otp'
                                        ? GestureDetector(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                top: ScreenUtil().setWidth(10),
                                                left: ScreenUtil().setWidth(20),
                                                right:
                                                    ScreenUtil().setWidth(20),
                                                bottom:
                                                    ScreenUtil().setWidth(10),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        ScreenUtil
                                                            .screenWidthDp),
                                                border: Border.all(
                                                  color: requestOTP
                                                      ? Color(0xff26A4FF)
                                                      : Colors.white38,
                                                  width: 0.2,
                                                ),
                                              ),
                                              child: Text(
                                                requestOTP
                                                    ? 'ส่งใหม่'
                                                    : 'ส่งใหม่ ($_start)',
                                                style: TextStyle(
                                                  color: requestOTP
                                                      ? Color(0xff26A4FF)
                                                      : Colors.white38,
                                                  fontSize:
                                                      ScreenUtil().setSp(38),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              requestOTP ? getOTP() : null;
                                            },
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: ScreenUtil.screenWidthDp,
                        height: ScreenUtil().setHeight(110),
                        margin: EdgeInsets.only(
                          // top: ScreenUtil().setHeight(15),
                          bottom: ScreenUtil().setHeight(15),
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(ScreenUtil.screenWidthDp),
                          color: Color(0xff101010),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: loginMode == 'otp'
                              ? Container(
                                  margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(50),
                                    right: ScreenUtil().setWidth(50),
                                  ),
                                  child: Text(
                                    'OTP',
                                    style: TextStyle(
                                      color: Colors.white30,
                                      fontSize: ScreenUtil().setSp(40),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(50),
                                    right: ScreenUtil().setWidth(50),
                                  ),
                                  child: Text(
                                    'Password',
                                    style: TextStyle(
                                      color: Colors.white30,
                                      fontSize: ScreenUtil().setSp(40),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      loginMode == 'password'
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                child: Container(
                                  height: ScreenUtil().setHeight(40),
                                  child: Text(
                                    'ลืมรหัสผ่าน?',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      height: 1.0,
                                      color: Colors.white70,
                                      fontSize: ScreenUtil().setSp(38),
                                    ),
                                  ),
                                ),
                                onTap: () {},
                              ),
                            )
                          : Container(
                              height: ScreenUtil().setHeight(40),
                            ),
                      Container(
                        width: ScreenUtil.screenWidthDp,
                        height: ScreenUtil().setHeight(110),
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setHeight(50),
                          bottom: ScreenUtil().setHeight(25),
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(ScreenUtil.screenWidthDp),
                          color: Color(0xff26A4FF),
                        ),
                        child: Center(
                          child: Text(
                            'เข้าสู่ระบบ',
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
                          loginMode == 'otp'
                              ? 'ลงชื่อเข้าใช้ด้วยรหัสผ่าน'
                              : 'ลงชื่อเข้าใช้ด้วย OTP',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            height: 1.0,
                            color: Colors.white70,
                            fontSize: ScreenUtil().setSp(38),
                          ),
                        ),
                        onTap: () {
                          changeLogin(loginMode == 'otp' ? 'password' : 'otp');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(70),
                        right: ScreenUtil().setWidth(70),
                        bottom: ScreenUtil().setHeight(70),
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
            ],
          ),
        ),
      ),
    );
  }
}
