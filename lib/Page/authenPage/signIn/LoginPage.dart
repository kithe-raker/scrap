import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scrap/Page/authenPage/signIn/LoginOtherMethod.dart';
import 'package:scrap/Page/authenPage/signup/SelectSignUp.dart';

import 'package:scrap/function/authServices/authService.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/Toast.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String pName, _password;
  bool loading = false;
  var _key = GlobalKey<FormState>();
  StreamSubscription loadStatus;

  @override
  void initState() {
    loadStatus =
        authService.load.listen((value) => setState(() => loading = value));
    super.initState();
  }

  @override
  void dispose() {
    loadStatus.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: a.width / 8,
                    ),
                    Container(
                      child: Text(
                        "ยินดีต้อนรับ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: a.width / 9,
                            fontFamily: 'ThaiSans',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      child: Text(
                        "\"สู่โลกที่เต็มไปด้วยเศษกระดาษ\"",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: a.width / 18,
                          fontFamily: 'ThaiSans',
                        ),
                      ),
                    ),
                    Form(
                      key: _key,
                      child: Container(
                        margin: EdgeInsets.only(top: a.width / 15),
                        width: a.width / 1.15,
                        padding: EdgeInsets.only(bottom: a.width / 20),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xff595959),
                                Color(0xff292929),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(a.width / 20)),
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: a.width,
                                padding: EdgeInsets.only(
                                    top: a.width / 20,
                                    left: a.width / 20,
                                    bottom: a.width / 80),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: a.width / 22,
                                    ),
                                    SizedBox(width: 5.0),
                                    Text(
                                      'นามปากกา',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                )),
                            Container(
                              width: a.width / 1.3,
                              height: a.width / 6.5,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(a.width)),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: a.width / 15,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'นามปากกา',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w900,
                                    fontSize: a.width / 15,
                                  ),
                                ),
                                validator: (val) {
                                  return val.trim() == ""
                                      ? Taoast().toast("กรุณาใส่นามปากกาของคุณ")
                                      : null;
                                },
                                onSaved: (val) {
                                  pName = val.trim();
                                },
                              ),
                            ),
                            Container(
                              width: a.width,
                              padding: EdgeInsets.only(
                                  top: a.width / 20,
                                  left: a.width / 20,
                                  bottom: a.width / 80),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                    size: a.width / 22,
                                  ),
                                  SizedBox(width: 5.0),
                                  Text(
                                    'รหัสผ่าน',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: a.width / 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: a.width / 1.3,
                              height: a.width / 6.5,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(a.width)),
                              child: TextFormField(
                                obscureText: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 10,
                                  fontWeight: FontWeight.w900,
                                  fontSize: a.width / 15,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '••••••••',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w900,
                                    fontSize: a.width / 15,
                                  ),
                                ),
                                validator: (val) {
                                  return val.trim() == ""
                                      ? Taoast().toast("กรุณากรอกรหัสผ่าน")
                                      : val.trim().length < 6
                                          ? Taoast().toast(
                                              "รหัสต้องมีอย่างน้อย 6 ตัว")
                                          : null;
                                },
                                onSaved: (val) {
                                  _password = val.trim();
                                },
                              ),
                            ),
                            InkWell(
                                child: Container(
                                    width: a.width / 1.3,
                                    height: a.width / 6.5,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                        top: a.width / 15,
                                        bottom: a.width / 35),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            a.width / 40)),
                                    child: Text("เข้าสู่ระบบ",
                                        style: TextStyle(
                                          fontSize: a.width / 16,
                                          fontWeight: FontWeight.bold,
                                        ))),
                                onTap: () async {
                                  if (_key.currentState.validate()) {
                                    _key.currentState.save();
                                    authService.signInWithPassword(context,
                                        password: _password);
                                  }
                                }),
                            InkWell(
                                child: FlatButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.devices_other,
                                          color: Colors.white,
                                          size: a.width / 20,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          'เข้าสู่ระบบด้วยวิธีอื่น',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.white,
                                              fontSize: a.width / 17,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginOtherMethod()));
                                    })),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: a.width / 30),
                      child: InkWell(
                        child: Container(
                            width: a.width / 1.3,
                            height: a.width / 6.5,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                                top: a.width / 22, bottom: a.width / 35),
                            decoration: BoxDecoration(
                                color: Color(0xff26A4FF),
                                borderRadius:
                                    BorderRadius.circular(a.width / 2)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.account_circle,
                                  color: Colors.white,
                                  size: a.width / 20,
                                ),
                                SizedBox(width: 5.0),
                                Text("สร้างบัญชี SCRAP",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: a.width / 18,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectSignUp()));
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          loading ? Loading() : SizedBox()
        ],
      ),
    );
  }
}
