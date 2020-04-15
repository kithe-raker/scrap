import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:scrap/theme/ScreenUtil.dart';
import 'package:scrap/theme/AppColors.dart';
import 'package:scrap/widget/AppBar.dart';
import 'package:scrap/method/Navigator.dart';

class CreateProfile2 extends StatefulWidget {
  CreateProfile2({Key key}) : super(key: key);
  @override
  _CreateProfile2State createState() => _CreateProfile2State();
}

class _CreateProfile2State extends State<CreateProfile2> {
  bool _showTitle = true;

  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  List<DateTimePickerLocale> _locales = DateTimePickerLocale.values;

  String _format = 'yyyy-MMMM-dd';
  TextEditingController _formatCtrl = TextEditingController();

  DateTime _dateTime;

  String minDateTime = '1920-01-01';
  String maxDateTime = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String initialDateTime = DateFormat("yyyy-MM-dd").format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _formatCtrl.text = _format;
    _dateTime = DateTime.parse(initialDateTime);
  }

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
      initialDateTime: _dateTime,
      dateFormat: _format,
      locale: _locale,
      // onClose: () => print("onClose"),
      // onCancel: () => print('onCancel'),
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                                          '${_dateTime.day.toString().padLeft(2, '0')}/${_dateTime.month.toString().padLeft(2, '0')}/${_dateTime.year}',
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
                                      borderRadius:
                                          BorderRadius.circular(screenWidthDp),
                                      color: AppColors.textField,
                                    ),
                                    child: Center(
                                      child: TextFormField(
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
                                          border: InputBorder.none,
                                          hintText: '••••••••',
                                          hintStyle: TextStyle(
                                            color: AppColors.hintText,
                                            fontWeight: FontWeight.bold,
                                            fontSize: s40,
                                          ),
                                        ),
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
                                      borderRadius:
                                          BorderRadius.circular(screenWidthDp),
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
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => ConfigWorld(),
                                    //   ),
                                    // );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
