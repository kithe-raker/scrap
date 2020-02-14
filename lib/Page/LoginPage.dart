import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrap/Page/CreateID.dart';
import 'package:scrap/Page/MainPage.dart';
import 'package:scrap/Page/OTPScreen.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  var _key = GlobalKey<FormState>();

  login() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Authen()));
    } catch (e) {
      switch (e.toString()) {
        case 'PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)':
          warning(context, 'กรุณาตรวจสอบ"อีเมล"ของท่าน');
          break;
        case 'PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)':
          warning(context, 'ไม่พบบัญชีผู้ใช้กรุณาตรวจสอบใหม่');
          break;
        case 'PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null)':
          warning(context, 'กรุณาตรวจสอบรหัสผ่านของท่าน');
          break;
        case "'package:firebase_auth/src/firebase_auth.dart': Failed assertion: line 224 pos 12: 'email != null': is not true.":
          warning(context, 'กรุณากรอกอีเมลและรหัสผ่าน');
          break;
        default:
          warning(context,
              'เกิดข้อผิดพลาด ไม่ทราบสาเหตุกรุณาตรวจสอบการเชื่อต่ออินเทอร์เน็ต');
      }
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                "SIGN IN",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: a.width / 8,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Form(
              key: _key,
              child: Container(
                margin: EdgeInsets.only(top: a.width / 10),
                width: a.width / 1.15,
                height: a.height / 1.5,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(a.width / 20)),
                child: Column(
                  children: <Widget>[
                    Container(
                        width: a.width,
                        padding: EdgeInsets.only(
                            top: a.width / 20,
                            left: a.width / 20,
                            bottom: a.width / 80),
                        child: Text(
                          "Email",
                          style: TextStyle(
                              color: Colors.white, fontSize: a.width / 25),
                        )),
                    Container(
                      width: a.width / 1.3,
                      height: a.width / 6,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(a.width)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'email',
                            labelStyle: TextStyle(color: Colors.white)),
                        validator: (val) {
                          return val.trim() == "" ? 'put isas' : null;
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
                        child: Text(
                          "password",
                          style: TextStyle(
                              color: Colors.white, fontSize: a.width / 25),
                        )),
                    Container(
                      width: a.width / 1.3,
                      height: a.width / 6,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(a.width)),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'password',
                        ),
                        validator: (val) {
                          return val.trim() == "" ? 'put isas' : null;
                        },
                        onSaved: (val) {
                          _password = val.trim();
                        },
                      ),
                    ),
                    InkWell(
                        child: Container(
                            width: a.width / 1.3,
                            height: a.width / 6,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: a.width / 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(a.width / 40)),
                            child: Text(
                              "เข้าสู่ระบบ",
                              style: TextStyle(fontSize: a.width / 20),
                            )),
                        onTap: () async {
                          if (_key.currentState.validate()) {
                            _key.currentState.save();
                            await login();
                          } else {
                            print('nope');
                          }
                        }),
                    InkWell(
                        child: FlatButton(
                            child: Text(
                              "เข้าสู่ระบบด้วยเบอร์โทร",
                              style: TextStyle(fontSize: a.width / 20),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPhone()));
                            })),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: a.width / 10),
              child: InkWell(
                child: Text(
                  "สร้างบัญชี SCRAP.",
                  style: TextStyle(color: Colors.white, fontSize: a.width / 20),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateID()));
                },
              ),
            )
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
            "ขออภัยค่ะ",
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

class LoginPhone extends StatefulWidget {
  @override
  _LoginPhoneState createState() => _LoginPhoneState();
}

class _LoginPhoneState extends State<LoginPhone> {
  String phone;
  var _key = GlobalKey<FormState>();

  Future<void> phoneVerified() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String id) {
      print(id);
    };
    final PhoneCodeSent smsCode = (String id, [int resendCode]) {
      print(id.toString() + " sent and " + resendCode.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTPScreen(verifiedID: id, phone: phone)));
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
            phoneNumber: '+66' + phone,
            timeout: Duration(seconds: 120),
            verificationCompleted: success,
            verificationFailed: failed,
            codeSent: smsCode,
            codeAutoRetrievalTimeout: autoRetrieval)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<bool> hasAccount(String phone) async {
    final QuerySnapshot phones = await Firestore.instance
        .collection('Users')
        .where('phone', isEqualTo: phone)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> doc = phones.documents;
    return doc.length < 1;
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(a.width / 20),
        child: Container(
          width: a.width,
          alignment: Alignment.topLeft,
          child: Form(
            key: _key,
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
                        "เบอร์โทรศัพท์",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: a.width / 15),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: a.width / 20, bottom: a.width / 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(a.width / 40)),
                              width: a.width / 5,
                              height: a.width / 8,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(a.width / 40)),
                              width: a.width / 2,
                              height: a.width / 8,
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: 'phone numbers',
                                ),
                                validator: (val) {
                                  return val.trim() == ""
                                      ? 'put isas'
                                      : val.trim().length != 10
                                          ? 'check pls'
                                          : null;
                                },
                                onSaved: (val) {
                                  phone = val.trim();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Text(
                        "เราจะส่งเลข 6 หลัก เพื่อยืนยันเบอร์คุณ",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: a.width / 30),
                      ),
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(a.width / 10)),
                          width: a.width / 3,
                          height: a.width / 6,
                          margin: EdgeInsets.only(top: a.width / 5),
                          alignment: Alignment.center,
                          child: Text(
                            "ต่อไป",
                            style: TextStyle(
                                fontSize: a.width / 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: () async {
                          if (_key.currentState.validate()) {
                            _key.currentState.save();
                            await hasAccount(phone)
                                ? print('ไม่เจอ')
                                : await phoneVerified();
                          } else {
                            print('nope');
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
