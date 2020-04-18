import 'dart:async';

import 'package:flutter/material.dart';
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

class PennameLogin extends StatefulWidget {
  @override
  _PennameLoginState createState() => _PennameLoginState();
}

class _PennameLoginState extends State<PennameLogin> {
  final nav = Nav();
  var _key = GlobalKey<FormState>();
  String password;
  bool loading = false;
  StreamSubscription loadStatus;
  var _passwordField = TextEditingController();

  @override
  void initState() {
    loadStatus =
        authService.load.listen((value) => setState(() => loading = value));
    super.initState();
  }

  @override
  void dispose() {
    loadStatus.cancel();
    _passwordField.dispose();
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
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                          fontFamily: 'ThaiSans',
                                          height: 0.9,
                                          color: AppColors.white,
                                          fontSize: s40,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: authenInfo.pName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: s70,
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                                Form(
                                  key: _key,
                                  child: Container(
                                    width: screenWidthDp,
                                    height: textFieldHeight,
                                    margin: EdgeInsets.only(
                                      top: 15.h,
                                      bottom: 15.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(screenWidthDp),
                                      color: AppColors.textField,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
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
                                              hintText: 'Password',
                                              hintStyle: TextStyle(
                                                color: AppColors.white30,
                                                fontSize: s40,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: s40,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            validator: (val) {
                                              return val.trim() == ''
                                                  ? 'กรุณากรอกรหัสผ่าน'
                                                  : null;
                                            },
                                            onSaved: (val) {
                                              password = val.trim();
                                            }),
                                      ),
                                    ),
                                  ),
                                ),
                                // Align(
                                //   alignment: Alignment.centerRight,
                                //   child: GestureDetector(
                                //     child: Text(
                                //       'ลืมรหัสผ่าน?',
                                //       style: TextStyle(
                                //         decoration: TextDecoration.underline,
                                //         height: 1.0,
                                //         color: AppColors.white70,
                                //         fontSize: s38,
                                //       ),
                                //     ),
                                //     onTap: () {},
                                //   ),
                                // ),
                                GestureDetector(
                                  child: Container(
                                    width: screenWidthDp,
                                    height: textFieldHeight,
                                    margin: EdgeInsets.only(
                                      top: 50.h,
                                      bottom: 25.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(screenWidthDp),
                                      color: Color(0xff26A4FF),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'ดำเนินการต่อ',
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: s45,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (_key.currentState.validate()) {
                                      _key.currentState.save();
                                      authService.signInWithPassword(context,
                                          password: password);
                                    } else {
                                      if (_passwordField.text.trim() == '') {
                                        alert(infoTitle, "กรุณากรอกรหัสผ่าน",
                                            context);
                                      }
                                    }
                                  },
                                ),
                                // GestureDetector(
                                //   child: Text(
                                //     loginMode == 'phone'
                                //         ? 'ลงชื่อเข้าใช้ด้วยนามปากกา'
                                //         : 'ลงชื่อเข้าใช้ด้วยเบอร์โทรศัพท์',
                                //     style: TextStyle(
                                //       decoration: TextDecoration.underline,
                                //       height: 1.0,
                                //       color: AppColors.white70,
                                //       fontSize: s38,
                                //     ),
                                //   ),
                                //   onTap: () {
                                //     changeLogin(
                                //         loginMode == 'phone' ? 'penname' : 'phone');
                                //   },
                                // ),
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
