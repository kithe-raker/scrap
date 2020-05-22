import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:scrap/Page/authentication/LoginPage.dart';
import 'package:scrap/Page/mainstream.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/function/cacheManage/friendManager.dart';
import 'package:scrap/services/jsonConverter.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';

class LoginID extends StatefulWidget {
  @override
  _LoginIDState createState() => _LoginIDState();
}

class _LoginIDState extends State<LoginID> {
  String id, _password, token;
  bool loading = false;
  var _key = GlobalKey<FormState>();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  List acc = [];
  FriendManager friendManager = FriendManager();
  JsonConverter jsonConverter = JsonConverter();

  // Future<bool> hasAccount(String user) async {
  //   final QuerySnapshot users = await Firestore.instance
  //       .collection('Users')
  //       .where('id', isEqualTo: user)
  //       .limit(1)
  //       .getDocuments();
  //   final List<DocumentSnapshot> doc = users.documents;
  //   if (doc.length == 1) {
  //     acc = doc;
  //   }
  //   return doc.length == 1;
  // }

  // continueSignIn() async {
  //   DocumentSnapshot doc = acc[0];
  //   doc.data['password'] == _password
  //       ? await signIn(doc.data['email'])
  //       : warning(context, 'กรุณาตรวจสอบรหัสผ่านของท่าน');
  // }

  // signIn(String email) async {
  //   var auth = await FirebaseAuth.instance
  //       .signInWithEmailAndPassword(email: email, password: _password);
  //   cacheHistory.initHistory();
  //   updateToken(auth.user.uid);
  //   await friendManager.initFriend(auth.user.uid);
  //   var doc = await Firestore.instance
  //       .collection('Users/${auth.user.uid}/info')
  //       .document(auth.user.uid)
  //       .get();
  //   await userinfo.writeContent(doc: doc);
  //   setState(() {
  //     loading = false;
  //   });
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => MainStream()));
  // }

  // updateToken(String uid) async {
  //   await Firestore.instance
  //       .collection('Users')
  //       .document(uid)
  //       .collection('token')
  //       .getDocuments()
  //       .then((docs) async {
  //     List data = docs.documents;
  //     if (data[0].documentID != token) {
  //       Firestore.instance
  //           .collection('Users')
  //           .document(uid)
  //           .collection('token')
  //           .document(data[0].documentID)
  //           .delete();
  //       Firestore.instance
  //           .collection('Users')
  //           .document(uid)
  //           .collection('token')
  //           .document(token)
  //           .setData({'token': token});
  //     }
  //   });
  // }

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
    screenutilInit(context);
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: <Widget>[
          ListView(
            children: <Widget>[
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: screenWidthDp / 4.2),
                      child: Text(
                        "เข้าสู่ระบบด้วยไอดี",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: s70,
                            fontFamily: 'ThaiSans',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Form(
                      key: _key,
                      child: Container(
                        margin: EdgeInsets.only(top: screenWidthDp / 15),
                        width: screenWidthDp / 1.15,
                        padding: EdgeInsets.only(bottom: screenWidthDp / 20),
                        decoration: BoxDecoration(
                            color: Color(0xff2B2B2B),
                            borderRadius:
                                BorderRadius.circular(screenWidthDp / 20)),
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: screenWidthDp,
                                padding: EdgeInsets.only(
                                    top: screenWidthDp / 20,
                                    left: screenWidthDp / 20,
                                    bottom: screenWidthDp / 80),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: screenWidthDp / 22,
                                    ),
                                    SizedBox(width: 5.0),
                                    Text(
                                      'ไอดี',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidthDp / 20,
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                              width: screenWidthDp / 1.3,
                              height: screenWidthDp / 6.5,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.circular(screenWidthDp)),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidthDp / 15,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '@someone',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: screenWidthDp / 15,
                                  ),
                                ),
                                validator: (val) {
                                  return val.trim() == ""
                                      ? Taoast().toast("ใส่ไอดีของคุณ")
                                      : val.trim()[0] == '@'
                                          ? null
                                          : Taoast()
                                              .toast("ใส่@ด้านหน้สไอดีคุณ");
                                },
                                onSaved: (val) {
                                  id = val.trim().substring(1);
                                },
                              ),
                            ),
                            Container(
                              width: screenWidthDp,
                              padding: EdgeInsets.only(
                                  top: screenWidthDp / 20,
                                  left: screenWidthDp / 20,
                                  bottom: screenWidthDp / 80),
                              child:
                                  /*Text(
                              "Password",
                              style: TextStyle(
                                  color: Colors.white, fontSize: a.width / 20 , fontWeight: FontWeight.w600),
                            )*/
                                  Row(
                                children: <Widget>[
                                  Icon(Icons.lock,
                                      color: Colors.white,
                                      size: screenWidthDp / 22),
                                  SizedBox(width: 5.0),
                                  Text(
                                    'รหัสผ่าน',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidthDp / 20),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: screenWidthDp / 1.3,
                              height: screenWidthDp / 6.5,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.circular(screenWidthDp)),
                              child: TextFormField(
                                obscureText: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 10,
                                  fontSize: screenWidthDp / 15,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '••••••••',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: screenWidthDp / 15,
                                  ),
                                ),
                                validator: (val) {
                                  return val.trim() == ""
                                      ? Taoast().toast("กรุณากรอกข้อมูลให้ครบ")
                                      : null;
                                },
                                onSaved: (val) {
                                  _password = val.trim();
                                },
                              ),
                            ),
                            InkWell(
                                child: Container(
                                    width: screenWidthDp / 1.3,
                                    height: screenWidthDp / 6.5,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                        top: screenWidthDp / 15,
                                        bottom: screenWidthDp / 35),
                                    decoration: BoxDecoration(
                                        color: Color(0xff26A4FF),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xff000000)
                                                .withOpacity(0.16),
                                            blurRadius: 10.0,
                                            spreadRadius: 2.1,
                                            offset: Offset(0.0, 3.2),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(
                                            screenWidthDp / 40)),
                                    child: Text("เข้าสู่ระบบ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenWidthDp / 16,
                                          fontWeight: FontWeight.bold,
                                        ))),
                                onTap: () async {
                                  // if (_key.currentState.validate()) {
                                  //   _key.currentState.save();
                                  //   setState(() {
                                  //     loading = true;
                                  //   });
                                  // }
                                }),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeightDp / 27),
                    GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.phone, color: Colors.white, size: s52),
                            Text(
                              ' เข้าสู่ระบบด้วยเบอร์โทรศัพท์',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: s54,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        }),
                  ],
                ),
              ),
            ],
          ),
          loading ? Loading() : SizedBox()
        ]));
  }

  warning(BuildContext context, String sub) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            "เกิดข้อผิดพลาด",
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            sub,
            style: TextStyle(fontSize: 16),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'ตกลง',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
