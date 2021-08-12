import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/authentication/LoginID.dart';
import 'package:scrap/Page/profile/OptionSetting_My_Profile.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  var focus = FocusNode();
  var _key = GlobalKey<FormState>();
  StreamSubscription loadStatus;

  @override
  void initState() {
    loadStatus =
        authService.loading.listen((value) => setState(() => loading = value));
    super.initState();
  }

  @override
  void dispose() {
    focus.dispose();
    loadStatus.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context, listen: false);
    screenutilInit(context);
    return WillPopScope(
      onWillPop: () => null,
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: screenHeightDp / 4.8),
                      Text('เข้าสู่ระบบด้วยเบอร์โทรศัพท์',
                          style: TextStyle(
                              fontSize: s60,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(height: screenHeightDp / 27),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: screenWidthDp / 11.2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                  height: screenHeightDp / 12,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.8, color: Colors.white),
                                      borderRadius: BorderRadius.circular(
                                          screenWidthDp / 42)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/thailand-flag-icon.jpg',
                                        width: screenWidthDp / 18,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(width: 6.4),
                                      Text('+66',
                                          style: TextStyle(
                                              fontSize: s65,
                                              color: Colors.white))
                                    ],
                                  )),
                            ),
                            SizedBox(width: screenWidthDp / 26),
                            Expanded(
                              flex: 2,
                              child: Form(
                                key: _key,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidthDp / 32),
                                  height: screenHeightDp / 12,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.8, color: Colors.white),
                                      borderRadius: BorderRadius.circular(
                                          screenWidthDp / 42)),
                                  child: Container(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextFormField(
                                        focusNode: focus,
                                        cursorColor: Colors.transparent,
                                        maxLength: 10,
                                        textAlign: TextAlign.start,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.done,
                                        validator: (val) {
                                          var trim = val.trim();
                                          return trim == ''
                                              ? toast.validateToast(
                                                  'ใส่เบอร์โทรของคุณ')
                                              : trim.length != 10
                                                  ? toast.validateToast(
                                                      'ใส่เบอร์โทร10หลัก')
                                                  : null;
                                        },
                                        style: TextStyle(
                                            fontSize: s65,
                                            height: 0.1,
                                            color: Colors.white),
                                        decoration: InputDecoration(
                                            counterText: '',
                                            errorStyle: TextStyle(height: 0.0),
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                fontSize: s65,
                                                color: Colors.white
                                                    .withOpacity(0.24)),
                                            hintText: 'เบอร์โทร 10 หลัก'),
                                        onSaved: (val) {
                                          user.phone = val.trim();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeightDp / 27),
                      Text(
                        'เราจะส่งเลข 6 หลัก เพื่อยืนยันเบอร์คุณ',
                        style: TextStyle(color: Colors.white, fontSize: s46),
                      ),
                      SizedBox(height: screenHeightDp / 21),
                      GestureDetector(
                        child: Container(
                            width: screenWidthDp / 1.2,
                            height: screenWidthDp / 6.8,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                                top: screenWidthDp / 22,
                                bottom: screenWidthDp / 35),
                            decoration: BoxDecoration(
                                color: Color(0xff26A4FF),
                                borderRadius:
                                    BorderRadius.circular(screenWidthDp / 40)),
                            child: Text('ต่อไป',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: s58,
                                ))),
                        onTap: () {
                          focus.unfocus();
                          var curState = _key.currentState;
                          if (curState.validate()) {
                            curState.save();
                            authService.phoneAuthentication(context);
                          }
                        },
                      ),
                      SizedBox(height: screenHeightDp / 54),
                      GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.account_circle,
                                  size: s48, color: Colors.white),
                              SizedBox(width: 3.2),
                              Text(
                                'เข้าสู่ระบบด้วยไอดี',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: s52,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          onTap: () {
                            // authService.signOut(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginID()));
                          }),
                      SizedBox(height: screenHeightDp / 6.4),
                      GestureDetector(
                        child: Text(
                          'นโยบายและข้อกำหนด',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Color(0xfff26A4FF),
                              fontSize: s42,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              //ฟังก์ชั่นส่งไปยัง MyWebView ซึ่งเป็น stl less มาจาก plugin webview
                              builder: (BuildContext context) => MyWebView(
                                    title: "นโยบายและข้อกำหนด",
                                    selectedUrl:
                                        'https://scrap.bualoitech.com/termsofservice-and-policy.html',
                                  )));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            loading ? Loading() : SizedBox()
          ],
        ),
      ),
    );
  }
}
