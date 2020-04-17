import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrap/function/authServices/authService.dart';
import 'package:scrap/provider/authen_provider.dart';
import 'package:scrap/theme/ScreenUtil.dart';
import 'package:scrap/theme/AppColors.dart';
import 'package:scrap/widget/AppBar.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/warning.dart';

class CreateProfile2 extends StatefulWidget {
  @override
  _CreateProfile2State createState() => _CreateProfile2State();
}

class _CreateProfile2State extends State<CreateProfile2> {
  var _key = GlobalKey<FormState>();
  bool _showTitle = true;
  String gender;
  bool loading = false;
  StreamSubscription loadStatus;
  var _passwordField = TextEditingController();

  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  List<DateTimePickerLocale> _locales = DateTimePickerLocale.values;

  String _format = 'yyyy-MMMM-dd';
  TextEditingController _formatCtrl = TextEditingController();

  DateTime birthDay, now = DateTime.now();

  String minDateTime = '1920-01-01';
  String maxDateTime = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String initialDateTime = DateFormat("yyyy-MM-dd").format(DateTime.now());

  /// Display date picker.
  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: _showTitle,
        confirm: Text(
          'เสร็จ',
          style: TextStyle(
            color: AppColors.scrapblue,
            fontSize: s38,
          ),
        ),
        cancel: Text(
          'ยกเลิก',
          style: TextStyle(
            color: AppColors.red,
            fontSize: s38,
          ),
        ),
      ),
      minDateTime: DateTime.parse(minDateTime),
      maxDateTime: DateTime.parse(maxDateTime),
      initialDateTime: now,
      dateFormat: _format,
      locale: _locale,
      // onClose: () => print("onClose"),
      // onCancel: () => print('onCancel'),
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          birthDay = dateTime;
        });
      },
    );
  }

  @override
  void initState() {
    _formatCtrl.text = _format;
    loadStatus =
        authService.load.listen((value) => setState(() => loading = value));
    super.initState();
  }

  @override
  void dispose() {
    loadStatus.cancel();
    _formatCtrl.dispose();
    _passwordField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
        backgroundColor: AppColors.black,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              AppBarWithArrow(),
              Container(
                margin: EdgeInsets.only(
                  top: appBarHeight,
                ),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: screenWidthDp,
                      minHeight:
                          screenHeightDp - statusBarHeight - appBarHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _key,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              flex: 15,
                              child: Container(
                                width: screenWidthDp,
                                margin: EdgeInsets.only(
                                  left: 70.w,
                                  right: 70.w,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'ใกล้เสร็จแล้ว!',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: s65,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'โลกของงานเขียนรอคุณอยู่หลังจากนี้ไป',
                                      style: TextStyle(
                                        height: 0.8,
                                        color: AppColors.white,
                                        fontSize: s40,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 40,
                              child: Container(
                                width: screenWidthDp,
                                margin: EdgeInsets.only(
                                  left: 70.w,
                                  right: 70.w,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'ประเทศ/ภูมิภาค',
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: s60,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              'ไทย',
                                              style: TextStyle(
                                                color: AppColors.white38,
                                                fontSize: s45,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                left: 5.w,
                                                right: 5.w,
                                              ),
                                              child: Icon(
                                                Icons.arrow_drop_down,
                                                color: AppColors.white38,
                                                size: ScreenUtil().setSp(50),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'วันเกิด',
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: s60,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        GestureDetector(
                                          child: Text(
                                            DateFormat('d/M/y')
                                                .format(birthDay ?? now),
                                            style: TextStyle(
                                              color: AppColors.scrapblue,
                                              fontSize: s60,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          onTap: () {
                                            _showDatePicker();
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'เพศ',
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: s60,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Radio(
                                          onChanged: (String ty) {
                                            setState(() => gender = ty);
                                            authenInfo.gender = ty;
                                          },
                                          value: 'male',
                                          groupValue: gender,
                                          activeColor: Color(0xff26A4FF),
                                        ),
                                        Text(
                                          'ชาย',
                                          style: TextStyle(
                                              fontSize: 21,
                                              color: Colors.white),
                                        ),
                                        Radio(
                                          onChanged: (String ty) {
                                            setState(() => gender = ty);
                                            authenInfo.gender = ty;
                                          },
                                          value: 'female',
                                          groupValue: gender,
                                          activeColor: Color(0xff26A4FF),
                                        ),
                                        Text(
                                          'หญิง',
                                          style: TextStyle(
                                              fontSize: 21,
                                              color: Colors.white),
                                        ),
                                        Radio(
                                          onChanged: (String ty) {
                                            setState(() => gender = ty);
                                            authenInfo.gender = ty;
                                          },
                                          value: 'other',
                                          groupValue: gender,
                                          activeColor: Color(0xff26A4FF),
                                        ),
                                        Text(
                                          'อื่นๆ',
                                          style: TextStyle(
                                              fontSize: 21,
                                              color: Colors.white),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 20,
                              child: Container(
                                width: screenWidthDp,
                                margin: EdgeInsets.only(
                                  left: 70.w,
                                  right: 70.w,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Password',
                                            style: TextStyle(
                                              fontFamily: 'ThaiSans',
                                              color: AppColors.white,
                                              fontSize: s40,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                ' (สำหรับเข้าใช้งานบัญชีของคุณ)',
                                            style: TextStyle(
                                              fontFamily: 'ThaiSans',
                                              color: AppColors.white38,
                                              fontSize: s38,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: screenWidthDp,
                                      height: textFieldHeight,
                                      margin: EdgeInsets.only(
                                        bottom: screenHeightDp / 60,
                                        top: screenHeightDp / 80,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            screenWidthDp),
                                        color: AppColors.textField,
                                      ),
                                      child: Center(
                                        child: TextFormField(
                                          controller: _passwordField,
                                          obscureText: true,
                                          textInputAction: TextInputAction.done,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors.white,
                                            letterSpacing: 10,
                                            fontWeight: FontWeight.bold,
                                            fontSize: s40,
                                          ),
                                          decoration: InputDecoration(
                                            counterText: '',
                                            counterStyle:
                                                TextStyle(fontSize: 0),
                                            errorStyle: TextStyle(
                                                fontSize: 0, height: 0),
                                            border: InputBorder.none,
                                            hintText: '••••••••',
                                            hintStyle: TextStyle(
                                              color: AppColors.hintText,
                                              fontWeight: FontWeight.bold,
                                              fontSize: s40,
                                            ),
                                          ),
                                          validator: (val) {
                                            return val.trim() == ''
                                                ? 'ใส่รหัสผ่านของคุณ'
                                                : val.trim().length < 6
                                                    ? 'ต้องมี 6 ตัวขึ้นไป'
                                                    : null;
                                          },
                                          onSaved: (val) {
                                            authenInfo.password = val.trim();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 25,
                              child: Column(
                                children: <Widget>[
                                  GestureDetector(
                                      child: Container(
                                        height: textFieldHeight,
                                        width: screenWidthDp,
                                        margin: EdgeInsets.only(
                                          left: 70.w,
                                          right: 70.w,
                                        ),
                                        // margin:
                                        //     EdgeInsets.only(bottom: screenHeightDp / 40),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              screenWidthDp),
                                          color: AppColors.blueButton,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'เสร็จสิ้น',
                                            style: TextStyle(
                                              color: AppColors.blueButtonText,
                                              fontSize: s45,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        if (_key.currentState.validate() &&
                                            birthDay != null &&
                                            gender != null) {
                                          _key.currentState.save();
                                          authenInfo.region = 'th';
                                          authenInfo.birthday = birthDay;
                                          authService.setAccount(context);
                                        } else {
                                          if (birthDay == null)
                                            warn("กรุณาระบุวันเกิดของคุณ",
                                                context);
                                          else if (gender == null)
                                            warn("กรุณาระบุเพศของคุณ", context);
                                          else if (_passwordField.text.trim() ==
                                              '')
                                            warn("กรุณากรอกรหัสผ่าน", context);
                                          else if (_passwordField.text
                                                  .trim()
                                                  .length <
                                              6)
                                            warn(
                                                "รหัสผ่านต้องมีความยาว 6 ตัวอักษรขึ้นไป",
                                                context);
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              loading ? Loading() : SizedBox()
            ],
          ),
        ));
  }
}
