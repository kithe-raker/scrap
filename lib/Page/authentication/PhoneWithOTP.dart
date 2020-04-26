import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/authentication/SocialLogin.dart';
import 'package:scrap/function/authServices/authService.dart';
import 'package:scrap/provider/authen_provider.dart';
import 'package:scrap/theme/ScreenUtil.dart';
import 'package:scrap/theme/AppColors.dart';
import 'package:scrap/widget/AppBar.dart';
import 'package:scrap/method/Navigator.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/warning.dart';

class PhoneWithOTP extends StatefulWidget {
  final bool register;
  PhoneWithOTP({this.register = false});
  @override
  _PhoneWithOTPState createState() => _PhoneWithOTPState();
}

class _PhoneWithOTPState extends State<PhoneWithOTP> {
  final nav = Nav();
  var _key = GlobalKey<FormState>();
  String loginMode = 'otp', value;
  bool requestOTP = true, loading = false;
  StreamSubscription loadStatus;
  var _otpField = TextEditingController();
  var _passwordField = TextEditingController();

  Timer _timer;
  int _start = 60;

  void getOTP() {
    setState(() {
      requestOTP = false;
    });
    authService.load.add(true);
    authService.phoneVerified(context);
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            _start = 60;
            requestOTP = true;
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    getOTP();
    loadStatus =
        authService.load.listen((value) => setState(() => loading = value));
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    loadStatus.cancel();
    _otpField.dispose();
    _passwordField.dispose();
    super.dispose();
  }

  changeLogin(String mode) {
    setState(() {
      loginMode = mode;
      _otpField.clear();
      _passwordField.clear();
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
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            AppBarWithTitle(widget.register ? 'สร้างบัญชี' : 'ลงชื่อเข้าใช้'),
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
                                                  authenInfo.phone ?? '',
                                                  style: TextStyle(
                                                    color: AppColors.white,
                                                    fontSize: s40,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                              widget.register ||
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
                                                        if (requestOTP)
                                                          getOTP();
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
                                    child: Form(
                                      key: _key,
                                      child: widget.register ||
                                              loginMode == 'otp'
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                left: 50.w,
                                                right: 50.w,
                                              ),
                                              child: TextFormField(
                                                controller: _otpField,
                                                obscureText: true,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  WhitelistingTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                maxLength: 6,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  counterText: '',
                                                  counterStyle:
                                                      TextStyle(fontSize: 0),
                                                  errorStyle: TextStyle(
                                                      fontSize: 0, height: 0),
                                                  hintText: 'OTP',
                                                  hintStyle: TextStyle(
                                                    color: AppColors.white30,
                                                    fontSize: s40,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                                style: TextStyle(
                                                    color: AppColors.white,
                                                    fontSize: s40,
                                                    fontWeight:
                                                        FontWeight.normal),
                                                validator: (val) {
                                                  return val.trim() == ''
                                                      ? alert(
                                                          infoTitle,
                                                          "กรุณากรอกรหัส OTP ที่ได้รับจากโทรศัพท์ของคุณ",
                                                          context)
                                                      : null;
                                                },
                                                onSaved: (val) {
                                                  value = val.trim();
                                                },
                                              ),
                                            )
                                          : Container(
                                              margin: EdgeInsets.only(
                                                left: 50.w,
                                                right: 50.w,
                                              ),
                                              child: TextFormField(
                                                controller: _passwordField,
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    errorStyle: TextStyle(
                                                        fontSize: 0, height: 0),
                                                    hintStyle: TextStyle(
                                                      color: AppColors.white30,
                                                      fontSize: s40,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                    hintText: 'Password'),
                                                style: TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: s40,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                validator: (val) {
                                                  return val.trim() == ''
                                                      ? alert(
                                                          infoTitle,
                                                          "กรุณากรอกรหัสผ่านของคุณ",
                                                          context)
                                                      : null;
                                                },
                                                onSaved: (val) {
                                                  value = val.trim();
                                                },
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                Container(height: 40.h),
                                GestureDetector(
                                  child: Container(
                                    width: screenWidthDp,
                                    height: textFieldHeight,
                                    margin: EdgeInsets.only(
                                        top: 50.h, bottom: 25.h),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            screenWidthDp),
                                        color: AppColors.blueButton),
                                    child: Center(
                                      child: Text(
                                        widget.register
                                            ? 'สร้างบัญชี'
                                            : 'เข้าสู่ระบบ',
                                        style: TextStyle(
                                          color: AppColors.blueButtonText,
                                          fontSize: s45,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    authenInfo.region = 'th';
                                    if (_key.currentState.validate()) {
                                      _key.currentState.save();
                                      widget.register
                                          ? authService.signUpWithPhone(context,
                                              smsCode: value)
                                          : loginMode == 'otp'
                                              ? authService.signInWithPhone(
                                                  context,
                                                  smsCode: value)
                                              : authService.signInWithPassword(
                                                  context,
                                                  password: value);
                                    }
                                  },
                                ),
                                widget.register
                                    ? SizedBox()
                                    : GestureDetector(
                                        child: Text(
                                          loginMode == 'otp'
                                              ? 'ลงชื่อเข้าใช้ด้วยรหัสผ่าน'
                                              : 'ลงชื่อเข้าใช้ด้วย OTP',
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
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
            loading ? Loading() : SizedBox()
          ],
        ),
      ),
    );
  }
}
