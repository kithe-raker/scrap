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
  String idCode;

  Future<void> resend() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String id) {
      print(id);
    };
    final PhoneCodeSent smsCode = (String id, [int resendCode]) {
      print(id.toString() + " sent and " + resendCode.toString());

    };
    final PhoneVerificationCompleted success = (AuthCredential credent) async {
      print('yes sure');
      // FirebaseUser user = await FirebaseAuth.instance.currentUser();
      // user.linkWithCredential(credent);
    };
    PhoneVerificationFailed failed = (AuthException error) {
      print(error);
    };
    await FirebaseAuth.instance
        .verifyPhoneNumber(
            phoneNumber: '+66' + widget.phone,
            timeout: Duration(seconds: 120),
            verificationCompleted: success,
            verificationFailed: failed,
            codeSent: smsCode,
            codeAutoRetrievalTimeout: autoRetrieval)
        .catchError((e) {
      print(e.toString());
    });
  }

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
      switch (e.toString()) {
        case 'PlatformException(ERROR_INVALID_VERIFICATION_CODE, The SMS verification code used to create the phone auth credential is invalid. Please resend the verification code SMS and be sure to use the verification code provided by the user., null)':
          warning(context, 'กรุณาเช็ครหัสOTPของท่าน');
          break;
        case 'PlatformException(ERROR_INVALID_VERIFICATION_CODE, The SMS verification code used to create the phone auth credential is invalid. Please resend the verification code SMS and be sure to use the verification code provided by the user., null)':
          warning(context, 'รหัสOTPหมดเวลาแล้ว กรุณากรอกรหัสOTPใหม่');
          break;
        default:
          warning(
              context, 'เกิดข้อผิดพลาดไม่ทราบสาเหตุกรุณาเช็คการเชื่อต่อของคุณ');
      }
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
        child: ListView(
          children: <Widget>[
            Form(
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
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.white),
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
                                    return val.trim() == "" ||
                                            val.trim().length < 6
                                        ? 'กรุณากรอกเลข 6 หลัก'
                                        : null;
                                  },
                                  onSaved: (val) => veriCode = val,
                                ),
                              ),
                              RaisedButton( 
                                color: Colors.white,
                                child: Text('data'),
                                onPressed: null),
                              InkWell(
                                child: Container(
                                  margin: EdgeInsets.only(top: a.width / 10),
                                  width: a.width / 3,
                                  height: a.width / 6,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(a.width)),
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
          ],
        ),
      ),
    );
  }

  warning(BuildContext context, String sub) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            "ขออภัยการเข้าสู่ระบบผิดพลาด",
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
