import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrap/Page/MainPage.dart';

class OTPScreen extends StatefulWidget {
  final String verifiedID;
  final String email;
  final String password;
  final String phone;
  OTPScreen({
    @required this.verifiedID,
    @required this.phone,
    this.email,
    this.password,
  });
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  var _key = GlobalKey<FormState>();
  String veriCode;

  register() async {
    var authCredential = PhoneAuthProvider.getCredential(
        verificationId: widget.verifiedID, smsCode: veriCode);
    await FirebaseAuth.instance
        .signInWithCredential(authCredential)
        .then((AuthResult auth) async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      var credential = EmailAuthProvider.getCredential(
          email: widget.email, password: widget.password);
      await user.linkWithCredential(credential);
      await toDb(user.uid);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Authen()));
    }).catchError((e) {
      print(e.toString());
    });
  }

  login() async {
    var authCredential = PhoneAuthProvider.getCredential(
        verificationId: widget.verifiedID, smsCode: veriCode);
    await FirebaseAuth.instance.signInWithCredential(authCredential).then((_) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Authen()));
    }).catchError((e) {
      print(e.toString());
    });
  }

  toDb(String uid) async {
    await Firestore.instance.collection('Users').document(uid).setData({
      'email': widget.email,
      'password': widget.password,
      'phone': widget.phone,
      'uid': uid,
    });
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('scraps')
        .document('recently')
        .setData({});
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('scraps')
        .document('collection')
        .setData({});
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(a.width / 20),
        child: Form(
          key: _key,
          child: Container(
              width: a.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: a.width / 7,
                    height: a.width / 10,
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(a.width),
                            color: Colors.white),
                        child: Icon(Icons.arrow_back,
                            color: Colors.black, size: a.width / 15),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                      width: a.width,
                      height: a.height / 1.12,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "ใส่เลข 6 หลักจาก SMS",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: a.width / 15),
                          ),
                          Container(
                            width: a.width / 2,
                            margin: EdgeInsets.only(
                                top: a.width / 10, bottom: a.width / 10),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border(
                                bottom:
                                    BorderSide(width: 1.0, color: Colors.white),
                              ),
                            ),
                            child: TextFormField(
                               maxLength: 6,
                               
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: a.width / 10,
                                color: Colors.white,
                                letterSpacing: 10,
                              ),
                              decoration: InputDecoration(
                                hintText: 'OTP',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                              validator: (val) {
                                return val.trim() == ""
                                    ? 'กรุณากรอกเลข 6 หลัก'
                                    : null;
                              },
                              onSaved: (val) => veriCode = val,
                            ),
                          ),
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.only(top: a.width / 10),
                              width: a.width / 3,
                              height: a.width / 6,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(a.width)),
                              child: Text(
                                "ยืนยัน",
                                style: TextStyle(fontSize: a.width / 15),
                              ),
                            ),
                            onTap: () async {
                              if (_key.currentState.validate()) {
                                _key.currentState.save();
                                widget.email == null
                                    ? await login()
                                    : await register();
                              } else {
                                print('nope');
                              }
                            },
                          )
                        ],
                      ))
                ],
              )),
        ),
      ),
    );
  }
}
