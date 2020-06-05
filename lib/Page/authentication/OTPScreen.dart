import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/authentication/LoginID.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';

class OTPScreen extends StatefulWidget {
  final bool register;
  final bool edit;
  OTPScreen({this.register = false, this.edit = false});
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String otp = '';
  bool loading = false, requestOTP = true;
  StreamSubscription loadStatus;
  Timer _timer;
  int _start = 60;

  void getOTP() {
    requestOTP = false;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (_start < 1) {
        timer.cancel();
        _start = 60;
        requestOTP = true;
      } else
        _start = _start - 1;

      setState(() {});
    });
  }

  @override
  void initState() {
    getOTP();
    loadStatus =
        authService.loading.listen((value) => setState(() => loading = value));
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    loadStatus.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            width: screenWidthDp,
            height: screenHeightDp,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'ใส่เลข 6 หลักจาก SMS',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: s52,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: screenHeightDp / 42),
                Container(
                  width: screenWidthDp / 1.16,
                  child: PinCodeTextField(
                      textInputType: TextInputType.number,
                      backgroundColor: Colors.transparent,
                      textStyle: TextStyle(fontSize: s90, color: Colors.white),
                      pinTheme: PinTheme(
                          activeColor: Colors.white,
                          inactiveColor: Colors.white,
                          fieldWidth: screenWidthDp / 7.8,
                          fieldHeight: screenHeightDp / 12),
                      length: 6,
                      onChanged: (val) {
                        setState(() => otp = val.trim());
                      }),
                ),
                SizedBox(height: (screenHeightDp / 14.6) / 3),
                GestureDetector(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidthDp / 42),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidthDp),
                      border: Border.all(
                        color:
                            requestOTP ? Color(0xff26A4FF) : Color(0xff525252),
                        width: 0.2,
                      ),
                    ),
                    child: Text(
                      requestOTP ? 'ส่งรหัส' : 'ส่งใหม่ ($_start)',
                      style: TextStyle(
                        color:
                            requestOTP ? Color(0xff26A4FF) : Color(0xff525252),
                        fontSize: s38,
                      ),
                    ),
                  ),
                  onTap: () async {
                    if (requestOTP) {
                      getOTP();
                      await authService.phoneVerified(context,
                          register: widget.register,
                          edit: widget.edit,
                          resend: true);
                      toast.toast('ส่งOTPไปใหม่แล้ว');
                    }
                  },
                ),
                GestureDetector(
                  child: Container(
                      width: screenWidthDp / 1.42,
                      height: screenWidthDp / 6.8,
                      alignment: Alignment.center,
                      margin:
                          EdgeInsets.only(top: 2 * (screenHeightDp / 14.6) / 3),
                      decoration: BoxDecoration(
                          color: otp.length < 6
                              ? Color(0xff525252)
                              : Color(0xff26A4FF),
                          borderRadius:
                              BorderRadius.circular(screenWidthDp / 36)),
                      child: Text(widget.edit ? 'ยืนยัน' : 'เข้าสู่ระบบ',
                          style: TextStyle(
                            color:
                                otp.length < 6 ? Colors.white38 : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: s52,
                          ))),
                  onTap: otp.length < 6
                      ? null
                      : () {
                          submitOTP();
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => SignUpMail()));
                        },
                ),
                SizedBox(height: screenHeightDp / 4.6),
                widget.edit
                    ? SizedBox()
                    : GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'มีไอดี\tSCRAP.',
                              style: TextStyle(
                                  //decoration: TextDecoration.underline,
                                  color: Colors.white,
                                  fontSize: s52,
                                  fontWeight: FontWeight.w600),
                            ),
                            /* Image.asset(
                          'assets/scrapmini.png',
                          scale: s10 / 2,
                        ),*/
                            Text(
                              '\tแล้ว',
                              style: TextStyle(
                                  //decoration: TextDecoration.underline,
                                  color: Colors.white,
                                  fontSize: s52,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginID()));
                        }),
                SizedBox(height: screenHeightDp / 12)
              ],
            ),
          ),
          loading ? Loading() : SizedBox()
        ],
      ),
    );
  }

  submitOTP() async {
    final user = Provider.of<UserData>(context, listen: false);
    var query =
        await authService.getDocuments('phone', user.phone, field: 'Users');
    var docs = query.documents;
    if (widget.register) {
      if (docs.length > 0) user.id = docs[0]['id'];

      authService.signUpWithPhone(context, smsCode: otp);
    } else if (widget.edit)
      authService.changePhoneNumber(context, otp: otp);
    else
      authService.signInWithPhone(context, smsCode: otp);
  }
}
