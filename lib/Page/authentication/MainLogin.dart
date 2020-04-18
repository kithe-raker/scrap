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

class MainLogin extends StatefulWidget {
  @override
  _MainLoginState createState() => _MainLoginState();
}

class _MainLoginState extends State<MainLogin> {
  var _key = GlobalKey<FormState>();
  final nav = Nav();
  String loginMode = 'phone', value;
  bool loading = false;
  StreamSubscription loadStatus;
  var _pNameField = TextEditingController();
  var _phoneField = TextEditingController();

  changeLogin(String mode) {
    setState(() {
      loginMode = mode;
    });
  }

  Widget validator(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.red,
        fontSize: s34,
      ),
    );
  }

  @override
  void initState() {
    loadStatus =
        authService.load.listen((value) => setState(() => loading = value));
    super.initState();
  }

  @override
  void dispose() {
    loadStatus.cancel();
    _pNameField.dispose();
    _phoneField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
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
                                Form(
                                  key: _key,
                                  child: loginMode == 'phone'
                                      ? Container(
                                          width: screenWidthDp,
                                          height: textFieldHeight,
                                          margin: EdgeInsets.only(
                                            top: 30.h,
                                            bottom: 30.h,
                                          ),
                                          // padding: EdgeInsets.fromLTRB(
                                          //   50.w,
                                          //   20.h,
                                          //   50.w,
                                          //   20.h,
                                          // ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                screenWidthDp),
                                            color: AppColors.textField,
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(
                                                  left: 50.w,
                                                  top: 20.h,
                                                  bottom: 20.h,
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          '+66',
                                                          style: TextStyle(
                                                            color:
                                                                AppColors.white,
                                                            fontSize: s40,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                            left: 10.w,
                                                            right: 10.w,
                                                          ),
                                                          child: Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color:
                                                                AppColors.white,
                                                            size: s40,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    VerticalDivider(
                                                      color: AppColors.white30,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  width: screenWidthDp,
                                                  height: textFieldHeight,
                                                  margin: EdgeInsets.only(
                                                    left: 30.w,
                                                  ),
                                                  // color: Colors.red,
                                                  child: TextFormField(
                                                    maxLength: 10,
                                                    // maxLines: 1,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: <
                                                        TextInputFormatter>[
                                                      WhitelistingTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    style: TextStyle(
                                                      color: AppColors.white,
                                                      fontSize: s40,
                                                    ),
                                                    decoration: InputDecoration(
                                                      errorStyle: TextStyle(
                                                          fontSize: 0,
                                                          height: 0),
                                                      counterText: '',
                                                      counterStyle: TextStyle(
                                                          fontSize: 0),
                                                      border: InputBorder.none,
                                                      hintText:
                                                          'หมายเลขโทรศัพท์',
                                                      hintStyle: TextStyle(
                                                          color:
                                                              AppColors.white30,
                                                          fontSize: s40,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    validator: (val) {
                                                      return val.trim() == ''
                                                          ? alert(
                                                              infoTitle,
                                                              "กรุณากรอกหมายเลขโทรศัพท์ให้ถูกต้อง",
                                                              context)
                                                          : null;
                                                    },
                                                    onSaved: (val) {
                                                      value = val.trim();
                                                      authenInfo.phone =
                                                          val.trim();
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
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
                                          child: TextFormField(
                                            controller: _pNameField,
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: s40,
                                            ),
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              errorStyle: TextStyle(
                                                  fontSize: 0, height: 0),
                                              border: InputBorder.none,
                                              hintText: '@penname',
                                              hintStyle: TextStyle(
                                                color: AppColors.white30,
                                                fontSize: s40,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            validator: (val) {
                                              return val.trim() == ''
                                                  ? alert(
                                                      infoTitle,
                                                      "กรุณากรอกนามปากกาให้ถูกต้อง",
                                                      context)
                                                  : null;
                                            },
                                            onSaved: (val) {
                                              value = val.trim();
                                              authenInfo.pName = val.trim();
                                            },
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
                                    if (_key.currentState.validate()) {
                                      _key.currentState.save();
                                      authService.validator(context, value,
                                          withPhone: loginMode == 'phone');
                                    }
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
            loading ? Loading() : SizedBox()
          ],
        ),
      ),
    );
  }
}
