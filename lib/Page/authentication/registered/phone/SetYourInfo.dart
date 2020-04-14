import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:scrap/Page/authentication/not_registered/phone/PhoneWithOTP.dart';

class SetYourInfo extends StatefulWidget {
  SetYourInfo({Key key}) : super(key: key);
  @override
  _SetYourInfoState createState() => _SetYourInfoState();
}

class _SetYourInfoState extends State<SetYourInfo> {
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
            color: Color(0xff26A4FF),
            fontSize: ScreenUtil().setSp(38),
          ),
        ),
        cancel: Text(
          'ยกเลิก',
          style: TextStyle(
            color: Colors.red,
            fontSize: ScreenUtil().setSp(38),
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
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: Colors.black,
                    width: ScreenUtil.screenWidthDp,
                    height: ScreenUtil().setHeight(130),
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(15),
                      right: ScreenUtil().setWidth(20),
                      left: ScreenUtil().setWidth(20),
                      bottom: ScreenUtil().setHeight(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            width: ScreenUtil().setWidth(100),
                            height: ScreenUtil().setHeight(75),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil.screenWidthDp),
                                color: Colors.white),
                            child: Icon(Icons.arrow_back,
                                color: Colors.black,
                                size: ScreenUtil().setSp(48)),
                          ),
                          onTap: () {
                            Navigator.pop(
                              context,
                            );
                          },
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(
                        //     left: ScreenUtil().setWidth(60),
                        //   ),
                        //   child: Text(
                        //     'สร้างบัญชี',
                        //     style: TextStyle(
                        //       height: 1.0,
                        //       color: Colors.white,
                        //       fontSize: ScreenUtil().setSp(45),
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(130),
                ),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: ScreenUtil.screenWidthDp,
                      minHeight: ScreenUtil.screenHeightDp -
                          ScreenUtil.statusBarHeight -
                          ScreenUtil().setHeight(130),
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            flex: 15,
                            child: Container(
                              width: ScreenUtil.screenWidthDp,
                              margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(70),
                                right: ScreenUtil().setWidth(70),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'ใกล้เสร็จแล้ว!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(65),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'โลกของงานเขียนรอคุณอยู่หลังจากนี้ไป',
                                    style: TextStyle(
                                      height: 0.8,
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(40),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 40,
                            child: Container(
                              width: ScreenUtil.screenWidthDp,
                              margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(70),
                                right: ScreenUtil().setWidth(70),
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
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(60),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'ไทย',
                                            style: TextStyle(
                                              color: Colors.white38,
                                              fontSize: ScreenUtil().setSp(45),
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(5),
                                              right: ScreenUtil().setWidth(5),
                                            ),
                                            child: Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.white38,
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
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(60),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      GestureDetector(
                                        child: Text(
                                          '${_dateTime.day.toString().padLeft(2, '0')}/${_dateTime.month.toString().padLeft(2, '0')}/${_dateTime.year}',
                                          style: TextStyle(
                                            color: Color(0xff26A4FF),
                                            fontSize: ScreenUtil().setSp(60),
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
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(60),
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
                              width: ScreenUtil.screenWidthDp,
                              margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(70),
                                right: ScreenUtil().setWidth(70),
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
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(40),
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              ' (สำหรับเข้าใช้งานบัญชีของคุณ)',
                                          style: TextStyle(
                                            fontFamily: 'ThaiSans',
                                            color: Colors.white38,
                                            fontSize: ScreenUtil().setSp(38),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: ScreenUtil.screenWidthDp,
                                    height: ScreenUtil().setHeight(110),
                                    margin: EdgeInsets.only(
                                      bottom: ScreenUtil.screenHeightDp / 60,
                                      top: ScreenUtil.screenHeightDp / 80,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil.screenWidthDp),
                                      color: Color(0xff101010),
                                    ),
                                    child: Center(
                                      child: TextFormField(
                                        obscureText: true,
                                        textInputAction: TextInputAction.done,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 10,
                                          fontWeight: FontWeight.bold,
                                          fontSize: ScreenUtil().setSp(40),
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: '••••••••',
                                          hintStyle: TextStyle(
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.bold,
                                            fontSize: ScreenUtil().setSp(40),
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
                                    height: ScreenUtil().setHeight(110),
                                    width: ScreenUtil.screenWidthDp,
                                    margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(70),
                                      right: ScreenUtil().setWidth(70),
                                    ),
                                    // margin:
                                    //     EdgeInsets.only(bottom: ScreenUtil.screenHeightDp / 40),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil.screenWidthDp),
                                      color: Color(0xff26A4FF),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'เสร็จสิ้น',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(45),
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
