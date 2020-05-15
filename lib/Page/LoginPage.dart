import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:scrap/Page/LoginID.dart';
import 'package:scrap/Page/mainstream.dart';

import 'package:scrap/Page/signup/SignUpMail.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/function/cacheManage/friendManager.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/Toast.dart';

import 'package:scrap/widget/warning.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password, token;
  bool loading = false;
  var _key = GlobalKey<FormState>();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FriendManager friendManager = FriendManager();

  login() async {
    try {
      var account = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      cacheHistory.initHistory();
      updateToken(account.user.uid);
      await friendManager.initFriend(account.user.uid);
      var doc = await Firestore.instance
          .collection('Users/${account.user.uid}/info')
          .document(account.user.uid)
          .get();
      await userinfo.writeContent(doc: doc);
       Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainStream()));
    } catch (e) {
      setState(() {
        loading = false;
      });
      switch (e.toString()) {
        case 'PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)':
          Dg().warning(
            context,
            'กรุณาตรวจสอบ"อีเมล"ของท่าน',
            "ขออภัยการเข้าสู่ระบบผิดพลาด",
          );
          break;
        case 'PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)':
          Dg().warning(
            context,
            'ไม่พบบัญชีผู้ใช้กรุณาตรวจสอบใหม่',
            "ขออภัยการเข้าสู่ระบบผิดพลาด",
          );
          break;
        case 'PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null)':
          Dg().warning(
            context,
            'กรุณาตรวจสอบรหัสผ่านของท่าน',
            "ขออภัยการเข้าสู่ระบบผิดพลาด",
          );
          break;
        case "'package:firebase_auth/src/firebase_auth.dart': Failed assertion: line 224 pos 12: 'email != null': is not true.":
          Dg().warning(
            context,
            'กรุณากรอกอีเมลและรหัสผ่าน',
            "ขออภัยการเข้าสู่ระบบผิดพลาด",
          );
          break;
        default:
          Dg().warning(
            context,
            'เกิดข้อผิดพลาด ไม่ทราบสาเหตุกรุณาตรวจสอบการเชื่อต่ออินเทอร์เน็ต',
            "ขออภัยการเข้าสู่ระบบผิดพลาด",
          );
          break;
      }
      print(e.toString());
    }
  }

  updateToken(String uid) async {
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('token')
        .getDocuments()
        .then((docs) async {
      List data = docs.documents;
      if (data[0].documentID != token) {
        await Firestore.instance
            .collection('Users')
            .document(uid)
            .collection('token')
            .document(data[0].documentID)
            .delete();
        await Firestore.instance
            .collection('Users')
            .document(uid)
            .collection('token')
            .document(token)
            .setData({'token': token});
      }
    });
  }

  void getToken() {
    firebaseMessaging.getToken().then((String tken) {
      assert(tken != null);
      token = tken;
    });
  }

  @override
  void initState() {
    getToken();
    super.initState();
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
                                      Icons.mail,
                                      color: Colors.white,
                                      size: a.width / 22,
                                    ),
                                    SizedBox(width: 5.0),
                                    Text(
                                      'อีเมล',
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
                                  hintText: 'example@mail.com',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w900,
                                    fontSize: a.width / 15,
                                  ),
                                ),
                                validator: (val) {
                                  return val.trim() == ""
                                      ? Taoast()
                                          .toast("โปรดใส่อีเมลและรหัสผ่าน")
                                      : val.contains('@') &&
                                              val.contains(
                                                  '.com', val.length - 4)
                                          ? null
                                          : Taoast().toast(
                                              "โปรดเขียนอีเมลให้ถูกต้อง");
                                },
                                onSaved: (val) {
                                  _email = val.trim();
                                },
                              ),
                            ),
                            Container(
                              width: a.width,
                              padding: EdgeInsets.only(
                                  top: a.width / 20,
                                  left: a.width / 20,
                                  bottom: a.width / 80),
                              child:
                                  /*Text(
                                      "Password",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: a.width / 20 , fontWeight: FontWeight.w600),
                                    )*/
                                  Row(
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
                                    setState(() {
                                      loading = true;
                                    });
                                    await login();
                                  }
                                }),
                            InkWell(
                                child: FlatButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: a.width / 20,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          'เข้าสู่ระบบด้วยไอดี',
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
                                              builder: (context) => LoginID()));
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
                                  builder: (context) => SignUpMail()));
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
