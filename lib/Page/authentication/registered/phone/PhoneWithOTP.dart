import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrap/Page/authentication/SocialLogin.dart';
import 'package:scrap/theme/ScreenUtil.dart';
import 'package:scrap/theme/AppColors.dart';
import 'package:scrap/widget/AppBar.dart';
import 'package:scrap/method/Navigator.dart';

class PhoneWithOTP extends StatefulWidget {
  @override
  _PhoneWithOTPState createState() => _PhoneWithOTPState();
}

class _PhoneWithOTPState extends State<PhoneWithOTP> {
  final nav = Nav();
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
    ScreenUtil.init(
      context,
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: fontScaling,
    );
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            AppBarWithTitle('ลงชื่อเข้าใช้'),
            Container(
              margin: EdgeInsets.only(
                top: appBarHeight,
              ),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: screenWidthDp,
                    minHeight: screenHeightDp - statusBarHeight - appBarHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 50,
                          child: Container(
                            width: screenWidthDp,
                            margin: EdgeInsets.only(
                              left: 70.w,
                              right: 70.w,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: screenWidthDp,
                                  height: textFieldHeight,
                                  margin: EdgeInsets.only(
                                    // top: ScreenUtil().setHeight(30),
                                    bottom: 30.h,
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                    50.w,
                                    20.h,
                                    20.w,
                                    20.h,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(screenWidthDp),
                                    color: AppColors.textField,
                                  ),
                                  child: Container(
                                    //color: AppColors.red,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  '+66',
                                                  style: TextStyle(
                                                    color: AppColors.white,
                                                    fontSize: s40,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    left: 10.w,
                                                    right: 10.w,
                                                  ),
                                                  child: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: AppColors.white,
                                                    size: s40,
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  color: AppColors.white30,
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
                                                  left: 30.w,
                                                  // right: 50.w,
                                                ),
                                                child: Text(
                                                  'หมายเลขโทรศัพท์',
                                                  style: TextStyle(
                                                    color: AppColors.white30,
                                                    fontSize: s40,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                              loginMode == 'otp'
                                                  ? GestureDetector(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 10.w,
                                                          left: 20.w,
                                                          right: 20.w,
                                                          bottom: 10.w,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  screenWidthDp),
                                                          border: Border.all(
                                                            color: requestOTP
                                                                ? AppColors
                                                                    .scrapblue
                                                                : AppColors
                                                                    .white38,
                                                            width: 0.2,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          requestOTP
                                                              ? 'ส่งรหัส'
                                                              : 'ส่งใหม่ ($_start)',
                                                          style: TextStyle(
                                                            color: requestOTP
                                                                ? AppColors
                                                                    .scrapblue
                                                                : AppColors
                                                                    .white38,
                                                            fontSize: s38,
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        requestOTP
                                                            ? getOTP()
                                                            : null;
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
                                  width: screenWidthDp,
                                  height: textFieldHeight,
                                  margin: EdgeInsets.only(
                                    // top: 15.h,
                                    bottom: 15.h,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(screenWidthDp),
                                    color: AppColors.textField,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: loginMode == 'otp'
                                        ? Container(
                                            margin: EdgeInsets.only(
                                              left: 50.w,
                                              right: 50.w,
                                            ),
                                            child: Text(
                                              'OTP',
                                              style: TextStyle(
                                                color: AppColors.white30,
                                                fontSize: s40,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(
                                              left: 50.w,
                                              right: 50.w,
                                            ),
                                            child: Text(
                                              'Password',
                                              style: TextStyle(
                                                color: AppColors.white30,
                                                fontSize: s40,
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
                                            height: 40.h,
                                            child: Text(
                                              'ลืมรหัสผ่าน?',
                                              style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                height: 1.0,
                                                color: AppColors.white70,
                                                fontSize: s38,
                                              ),
                                            ),
                                          ),
                                          onTap: () {},
                                        ),
                                      )
                                    : Container(
                                        height: 40.h,
                                      ),
                                Container(
                                  width: screenWidthDp,
                                  height: textFieldHeight,
                                  margin: EdgeInsets.only(
                                    top: 50.h,
                                    bottom: 25.h,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(screenWidthDp),
                                    color: AppColors.blueButton,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'เข้าสู่ระบบ',
                                      style: TextStyle(
                                        color: AppColors.blueButtonText,
                                        fontSize: s45,
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
                                      color: AppColors.white70,
                                      fontSize: s38,
                                    ),
                                  ),
                                  onTap: () {
                                    changeLogin(loginMode == 'otp'
                                        ? 'password'
                                        : 'otp');
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
                                  left: 70.w,
                                  right: 70.w,
                                  bottom: 70.h,
                                ),
                                width: screenWidthDp,
                                child: SocialLogin(),
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
