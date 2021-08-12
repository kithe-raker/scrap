import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String oldPass = '', newPass = '', confirmPass = '';
  bool loading = false;
  StreamSubscription loadStatus;

  @override
  void initState() {
    loadStatus =
        authService.loading.listen((value) => setState(() => loading = value));
    super.initState();
  }

  @override
  void dispose() {
    loadStatus.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: screenWidthDp,
              height: screenHeightDp / 1.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('เปลี่ยนรหัสผ่าน',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: s54,
                          fontWeight: FontWeight.bold)),
                  Container(
                    margin: EdgeInsets.only(top: screenWidthDp / 16),
                    width: screenWidthDp / 1.5,
                    height: screenHeightDp / 15,
                    decoration: BoxDecoration(
                        color: Color(0xfff272727),
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: s52,
                        fontWeight: FontWeight.w900,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'password',
                        hintStyle: TextStyle(
                            fontSize: s52,
                            height: 1.2,
                            color: Color(0xffFFFFFF).withOpacity(0.15)),
                      ),
                      onChanged: (val) => setState(() => oldPass = val.trim()),
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: screenWidthDp / 16),
                    width: screenWidthDp / 1.5,
                    height: screenHeightDp / 15,
                    decoration: BoxDecoration(
                        color: Color(0xfff272727),
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                    child: TextFormField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: s52,
                        fontWeight: FontWeight.w900,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'new password',
                        hintStyle: TextStyle(
                            fontSize: s52,
                            height: 1.2,
                            color: Color(0xffFFFFFF).withOpacity(0.15)),
                      ),
                      onChanged: (val) => setState(() => newPass = val.trim()),
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: screenWidthDp / 16),
                    width: screenWidthDp / 1.5,
                    height: screenHeightDp / 15,
                    decoration: BoxDecoration(
                        color: Color(0xfff272727),
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                    child: TextFormField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: s52,
                        fontWeight: FontWeight.w900,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'confirm password',
                        hintStyle: TextStyle(
                            fontSize: s52,
                            height: 1.2,
                            color: Color(0xffFFFFFF).withOpacity(0.15)),
                      ),
                      onChanged: (val) =>
                          setState(() => confirmPass = val.trim()),
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  SizedBox(height: screenHeightDp / 21),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(appBarHeight / 7),
                      width: screenWidthDp / 1.5,
                      height: screenHeightDp / 15,
                      decoration: BoxDecoration(
                          color: isEmptyString()
                              ? Color(0xff515151)
                              : Color(0xff26A4FE),
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      child: Text(
                        'ยืนยัน',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: s52,
                            fontWeight: FontWeight.w900,
                            color: isEmptyString()
                                ? Color(0xffFFFFFF).withOpacity(0.15)
                                : Colors.white),
                      ),
                    ),
                    onTap: isEmptyString()
                        ? null
                        : () async {
                            authService.loading.add(true);
                            if (newPass.length < 6)
                              authService.warn('รหัสผ่านต้องมี6ตัวขึ้นไป');
                            else if (newPass != confirmPass)
                              authService
                                  .warn('ตรวจสอบการยืนยันรหัสผ่านของคุณ');
                            else {
                              authService.changePassword(context,
                                  newPassword: newPass, oldPassword: oldPass);
                            }
                          },
                  )
                ],
              ),
            ),
          ),
          loading ? Loading() : SizedBox()
        ],
      ),
    );
  }

  bool isEmptyString() {
    return oldPass.length < 1 || newPass.length < 1 || confirmPass.length < 1;
  }
}
