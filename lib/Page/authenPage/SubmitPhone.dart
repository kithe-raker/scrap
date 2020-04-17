import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/function/authServices/authService.dart';
import 'package:scrap/provider/authen_provider.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/Toast.dart';

class SubmitPhone extends StatefulWidget {
  final bool register;
  final bool login;
  SubmitPhone({this.register = false, this.login = false});
  @override
  _SubmitPhoneState createState() => _SubmitPhoneState();
}

class _SubmitPhoneState extends State<SubmitPhone> {
  String phone, otp;
  var _keyOTP = GlobalKey<FormState>();
  var _keyPhone = GlobalKey<FormState>();

  bool loading = false;
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
    final authenInfo = Provider.of<AuthenProvider>(context);
    return Scaffold(
        backgroundColor: Colors.black,
        body: ListView(children: <Widget>[
          Stack(children: <Widget>[
            Padding(
                padding: EdgeInsets.all(a.width / 20),
                child: Container(
                    width: a.width,
                    height: a.height,
                    alignment: Alignment.topLeft,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: a.width / 7,
                            height: a.width / 10,
                            child: InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(a.width),
                                    color: Colors.white),
                                child: Icon(Icons.arrow_back,
                                    color: Colors.black, size: a.width / 15),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          SizedBox(
                            height: a.height / 16,
                          ),
                          Container(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                Text(
                                  "ยืนยันตัวตน",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: a.width / 8),
                                ),
                                Form(
                                    key: _keyPhone,
                                    child: Column(children: <Widget>[
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: a.width / 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        const Radius.circular(
                                                            40.0),
                                                    bottomLeft:
                                                        const Radius.circular(
                                                            40.0)),
                                                border: Border(
                                                    top: BorderSide(
                                                        width: 1.0,
                                                        color: Colors.white),
                                                    left: BorderSide(
                                                        width: 1.0,
                                                        color: Colors.white),
                                                    right: BorderSide(
                                                        width: 1.0,
                                                        color: Colors.white),
                                                    bottom: BorderSide(
                                                        width: 1.0,
                                                        color: Colors.white)),
                                              ),
                                              width: a.width / 4,
                                              height: a.width / 6.3,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    '+66',
                                                    style: TextStyle(
                                                      fontSize: a.width / 13,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(width: 6),
                                                  Container(
                                                    child: Image.asset(
                                                      'assets/thai-flag-round.png',
                                                      width: a.width / 18,
                                                      height: a.width / 18,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Container(
                                                width: a.width / 1.7,
                                                height: a.width / 6.3,
                                                padding:
                                                    EdgeInsets.only(left: 15),
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight: const Radius
                                                              .circular(40.0),
                                                          bottomRight:
                                                              const Radius
                                                                      .circular(
                                                                  40.0)),
                                                  border: Border(
                                                    top: BorderSide(
                                                        width: 1.0,
                                                        color: Colors.white),
                                                    left: BorderSide(
                                                        width: 1.0,
                                                        color: Colors.white),
                                                    right: BorderSide(
                                                        width: 1.0,
                                                        color: Colors.white),
                                                    bottom: BorderSide(
                                                        width: 1.0,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                child: TextFormField(
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: a.width / 14,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: 'เบอร์โทรศัพท์',
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[500]),
                                                    ),
                                                    validator: (val) {
                                                      return val.trim() == ""
                                                          ? Taoast().toast(
                                                              "กรุณาใส่เบอร์โทรศัพท์")
                                                          : val.trim().length !=
                                                                  10
                                                              ? Taoast().toast(
                                                                  "กรุณาใส่เบอร์โทรศัพท์ 10 หลัก")
                                                              : null;
                                                    },
                                                    onSaved: (val) {
                                                      authenInfo.phone =
                                                          val.trim();
                                                      phone = val.trim();
                                                    })),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        a.width / 10)),
                                            width: a.width / 2.5,
                                            padding: EdgeInsets.all(10.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "ส่งOTP",
                                              style: TextStyle(
                                                  fontSize: a.width / 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          onTap: () async {                      
                                          })
                                    ])),
                                Form(
                                  key: _keyOTP,
                                  child: Container(
                                      width: a.width,
                                      margin:
                                          EdgeInsets.only(top: a.width / 12),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: a.width / 2,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                              ),
                                              child: TextFormField(
                                                maxLength: 6,
                                                textAlign: TextAlign.center,
                                                keyboardType:
                                                    TextInputType.number,
                                                style: TextStyle(
                                                  fontSize: a.width / 10,
                                                  color: Colors.white,
                                                  letterSpacing: 10,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: '******',
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  border: InputBorder.none,
                                                ),
                                                validator: (val) {
                                                  return val.trim() == "" ||
                                                          val.trim().length < 6
                                                      ? 'กรุณากรอกเลข 6 หลัก'
                                                      : null;
                                                },
                                                onSaved: (val) =>
                                                    otp = val.trim(),
                                              ),
                                            ),
                                            InkWell(
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        top: a.width / 10),
                                                    width: a.width / 1.5,
                                                    height: a.width / 6,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: authenInfo?.verificationID == null
                                                            ? Colors.black
                                                            : Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                a.width),
                                                        border: Border.all(
                                                            color:
                                                                Colors.white)),
                                                    child: Text("ยืนยัน",
                                                        style: TextStyle(
                                                            fontSize:
                                                                a.width / 14,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            color: authenInfo?.verificationID == null ? Colors.white54 : Colors.black))),
                                                onTap: authenInfo?.verificationID != null
                                                    ? () async {
                                                        if (_keyOTP.currentState
                                                            .validate()) {
                                                          optionFunction();
                                                        }
                                                      }
                                                    : null)
                                          ])),
                                ),
                                SizedBox(
                                  height: a.width / 7,
                                )
                              ]))
                        ]))),
            loading ? Loading() : SizedBox()
          ])
        ]));
  }

  optionFunction() {
    _keyOTP.currentState.save();
    widget.register
        ? authService.signUpWithPhone(context, smsCode: otp)
        : widget.login
            ? authService.signInWithPhone(context, smsCode: otp)
            : print('edit');
  }
}
