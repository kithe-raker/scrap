import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/Toast.dart';

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

  Future<bool> hasAccount(String user) async {
    final QuerySnapshot users = await Firestore.instance
        .collection('Users')
        .where('id', isEqualTo: user)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> doc = users.documents;
    if (doc.length == 1) {
      acc = doc;
    }
    return doc.length == 1;
  }

  continueSignUp() async {
    DocumentSnapshot doc = acc[0];
    doc.data['password'] == _password
        ? await signIn(doc.data['email'])
        : warning(context, 'กรุณาตรวจสอบรหัสผ่านของท่าน');
  }

  signIn(String email) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: _password)
        .then((auth) async {
      await updateToken(auth.user.uid);
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    });
  }

  updateToken(String uid) async {
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('token')
        .document(uid)
        .get()
        .then((value) async {
      if (value.documentID != token) {
        await Firestore.instance
            .collection('Users')
            .document(uid)
            .collection('token')
            .document(value.documentID)
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
        body: Stack(children: <Widget>[
          ListView(
            children: <Widget>[
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: a.width / 20),
                      child: InkWell(
                        child: Container(
                          width: a.width / 7,
                          height: a.width / 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(a.width),
                              color: Colors.white),
                          child: Icon(Icons.arrow_back,
                              color: Colors.black, size: a.width / 15),
                        ),
                        onTap: () {
                          Navigator.pop(
                            context,
                          );
                        },
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: a.width / 6),
                          child: Text(
                            "เข้าสู่ระบบ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: a.width / 9,
                                fontFamily: 'ThaiSans',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(
                            "\"ผู้คนกำลังรออ่านกระดาษของคุณ\"",
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
                                borderRadius:
                                    BorderRadius.circular(a.width / 20)),
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
                                          'ไอดี',
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
                                      borderRadius:
                                          BorderRadius.circular(a.width)),
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: a.width / 15,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '@someone',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.w900,
                                        fontSize: a.width / 15,
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
                                      borderRadius:
                                          BorderRadius.circular(a.width)),
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
                                          ? Taoast()
                                              .toast("กรุณากรอกข้อมูลให้ครบ")
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
                                        await hasAccount(id)
                                            ? continueSignUp()
                                            : warning(
                                                context, 'ไม่พบบัญชีดังกล่าว');
                                      }
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          loading ? Loading() : SizedBox()
        ]));
  }

  warning(BuildContext context, String sub) {
    setState(() {
      loading = false;
    });
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
