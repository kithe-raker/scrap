import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrap/Page/authentication/SocialLogin.dart';
import 'package:scrap/Page/authentication/not_registered/phone/PhoneWithOTP.dart';
import 'package:scrap/Page/authentication/registered/penname/PennameWithPassword.dart';
import 'package:scrap/theme/ScreenUtil.dart';
import 'package:scrap/theme/AppColors.dart';
import 'package:scrap/widget/AppBar.dart';
import 'package:scrap/method/Navigator.dart';

class MainLogin extends StatefulWidget {
  @override
  _MainLoginState createState() => _MainLoginState();
}

class _MainLoginState extends State<MainLogin> {
  final nav = Nav();
  String loginMode = 'phone';

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
            AppBarMainLogin(),
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
                          flex: 15,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 40,
                          child: Container(
                            width: screenWidthDp,
                            margin: EdgeInsets.only(
                              left: 70.w,
                              right: 70.w,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                        fontFamily: 'ThaiSans',
                                        height: 1.0,
                                        color: AppColors.white,
                                        fontSize: s40,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'สวัสดี!',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text:
                                              ' เหล่านักเขียน นักอ่าน ทุกท่าน \nโลกของงานเขียนรอท่านอยู่หลังจากนี้ไป',
                                        )
                                      ]),
                                ),
                                loginMode == 'phone'
                                    ? Container(
                                        width: screenWidthDp,
                                        height: textFieldHeight,
                                        margin: EdgeInsets.only(
                                          top: 30.h,
                                          bottom: 30.h,
                                        ),
                                        padding: EdgeInsets.fromLTRB(
                                          50.w,
                                          20.h,
                                          50.w,
                                          20.h,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              screenWidthDp),
                                          color: AppColors.textField,
                                        ),
                                        child: Container(
                                          child: Row(
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
                                                  )
                                                ],
                                              ),
                                              VerticalDivider(
                                                color: AppColors.white30,
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                        left: 30.w,
                                                      ),
                                                      child: Text(
                                                        'หมายเลขโทรศัพท์',
                                                        style: TextStyle(
                                                          color:
                                                              AppColors.white30,
                                                          fontSize: s40,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: screenWidthDp,
                                        height: textFieldHeight,
                                        margin: EdgeInsets.only(
                                          top: 30.h,
                                          bottom: 30.h,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              screenWidthDp),
                                          color: AppColors.textField,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '@penname',
                                            style: TextStyle(
                                              color: AppColors.white30,
                                              fontSize: s40,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                GestureDetector(
                                  child: Container(
                                    width: screenWidthDp,
                                    height: textFieldHeight,
                                    margin: EdgeInsets.only(
                                      bottom: 25.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(screenWidthDp),
                                      color: AppColors.blueButton,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'ดำเนินการต่อ',
                                        style: TextStyle(
                                          color: AppColors.blueButtonText,
                                          fontSize: s45,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    loginMode == 'phone'
                                        ? nav.push(context, PhoneWithOTP())
                                        : nav.push(context, PennameLogin());
                                  },
                                ),
                                GestureDetector(
                                  child: Text(
                                    loginMode == 'phone'
                                        ? 'ลงชื่อเข้าใช้ด้วยนามปากกา'
                                        : 'ลงชื่อเข้าใช้ด้วยเบอร์โทรศัพท์',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      height: 1.0,
                                      color: AppColors.white70,
                                      fontSize: s38,
                                    ),
                                  ),
                                  onTap: () {
                                    changeLogin(loginMode == 'phone'
                                        ? 'penname'
                                        : 'phone');
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
                                  left: 70.w,
                                  right: 70.w,
                                ),
                                width: screenWidthDp,
                                child: SocialLogin(),
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
                                width: screenWidthDp,
                                margin: EdgeInsets.only(bottom: 10.h),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                          fontFamily: 'ThaiSans',
                                          height: 1.0,
                                          color: AppColors.white,
                                          fontSize: s34,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'created by Bualoi',
                                          ),
                                          TextSpan(
                                            text: 'Tech ',
                                            style: TextStyle(
                                              color: AppColors.scrapblue,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Co.,Ltd.',
                                          )
                                        ]),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
