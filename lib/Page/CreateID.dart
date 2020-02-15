import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrap/Page/OTPScreen.dart';

class CreateID extends StatefulWidget {
  @override
  _CreateIDState createState() => _CreateIDState();
}

class _CreateIDState extends State<CreateID> {
  String _email, _pass, _password, phone;
  var _key = GlobalKey<FormState>();

  Future<bool> uniqueEmail(String email) async {
    final QuerySnapshot emails = await Firestore.instance
        .collection('Users')
        .where('email', isEqualTo: email)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> doc = emails.documents;
    return doc.length < 1;
  }

  Future<void> phoneVerified() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String id) {
      print(id);
    };
    final PhoneCodeSent smsCode = (String id, [int resendCode]) {
      print(id.toString() + " sent and " + resendCode.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTPScreen(
                  verifiedID: id,
                  email: _email,
                  password: _password,
                  phone: phone)));
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
                  height: a.height / 1.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(a.width / 40)),
                        width: a.width / 2,
                        height: a.width / 8,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'email',
                          ),
                          validator: (val) {
                            return val.trim() == ""
                                ? 'put isas'
                                : val.contains('@') &&
                                        val.contains('.com', val.length - 4)
                                    ? null
                                    : 'format pls';
                          },
                          onSaved: (val) {
                            _email = val.trim();
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(a.width / 40)),
                        width: a.width / 2,
                        height: a.width / 8,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'pass',
                          ),
                          validator: (val) {
                            return val.trim() == ""
                                ? 'put isas'
                                : val.length < 6 ? '6ตัวขึ้นไป' : null;
                          },
                          onChanged: (val) {
                            _pass = val.trim();
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(a.width / 40)),
                        width: a.width / 2,
                        height: a.width / 8,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'password',
                          ),
                          validator: (val) {
                            return val.trim() == ""
                                ? 'put isas'
                                : _pass != val ? 'check pls' : null;
                          },
                          onSaved: (val) {
                            _password = val.trim();
                          },
                        ),
                      ),
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
                                      : val.trim().length > 10
                                          ? 'put 10 หลัก'
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
                            await uniqueEmail(_email)
                                ? await phoneVerified()
                                : print('ซ้ำ');
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
