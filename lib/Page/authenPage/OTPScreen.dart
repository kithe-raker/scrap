import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scrap/function/authServices/authService.dart';
import 'package:scrap/widget/Loading.dart';

class OTPScreen extends StatefulWidget {
  final bool edit;
  final bool register;
  OTPScreen({this.edit = false, this.register = false});
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  var _key = GlobalKey<FormState>();
  String otp, newVerified;
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
    return WillPopScope(
      onWillPop: () => warning2(context,
          'การดำเนินการจะไม่เสร็จสมบูรณ์คุณต้องการออกจากหน้านี้ใช่หรือไม่'),
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: <Widget>[
              Padding(
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
                                    borderRadius:
                                        BorderRadius.circular(a.width),
                                    color: Colors.white),
                                child: Icon(Icons.arrow_back,
                                    color: Colors.black, size: a.width / 15),
                              ),
                              onTap: () {
                                warning2(context,
                                    'การดำเนินการจะไม่เสร็จสมบูรณ์คุณต้องการออกจากหน้านี้ใช่หรือไม่');
                              },
                            ),
                          ),
                          Container(
                              width: a.width,
                              margin: EdgeInsets.only(top: a.width / 4),
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
                                  Container(
                                    width: a.width / 2,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                    ),
                                    child: TextFormField(
                                      maxLength: 6,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        fontSize: a.width / 10,
                                        color: Colors.white,
                                        letterSpacing: 10,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '******',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                      validator: (val) {
                                        return val.trim() == "" ||
                                                val.trim().length < 6
                                            ? 'กรุณากรอกเลข 6 หลัก'
                                            : null;
                                      },
                                      onSaved: (val) => otp = val.trim(),
                                    ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        'โปรดใส่รหัสยืนยันที่ได้รับจากทาง SMS\nหากไม่ได้รับ SMS ขอให้ดำเนินการตามวิธิต่อไปนี้',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 19,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      FlatButton(
                                        child: Text(
                                          'ส่งรหัสยืนยันอีกครั้ง',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: a.width / 19,
                                              fontWeight: FontWeight.w700,
                                              decoration:
                                                  TextDecoration.underline),
                                          textAlign: TextAlign.center,
                                        ),
                                        onPressed: () async {},
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: a.width / 10),
                                      width: a.width / 1.5,
                                      height: a.width / 6,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(a.width)),
                                      child: Text(
                                        "ยืนยัน",
                                        style: TextStyle(
                                            fontSize: a.width / 14,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                    onTap: () async {
                                      if (_key.currentState.validate()) {
                                        _key.currentState.save();
                                        widget.register
                                            ? authService.signUpWithPhone(
                                                context,
                                                smsCode: otp)
                                            : widget.edit
                                                ? print('edit')
                                                : authService.signInWithPhone(
                                                    context,
                                                    smsCode: otp);
                                      }
                                    },
                                  ),
                                ],
                              ))
                        ],
                      )),
                ),
              ),
              loading ? Loading() : SizedBox()
            ],
          )),
    );
  }

  warning2(BuildContext context, String sub) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            "คุณต้องการออกจากหน้านี้ใช่หรือไม่",
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
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
