import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class MyWebView extends StatelessWidget {
  final String title;
  final String selectedUrl;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  MyWebView({
    @required this.title,
    @required this.selectedUrl,
  });

// list_OptionSettingweb เป็น Widget ที่แสดงลิสต์ที่มากจากเว็บในการตั้งค่า
// (context , ชื่อicon, ชื่อการตั้งค่า, url )
  Widget list_OptionSettingweb(context, iconweb, String name, String url) {
    return FlatButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              //ฟังก์ชั่นส่งไปยัง MyWebView ซึ่งเป็น stl less มาจาก plugin webview
              builder: (BuildContext context) => MyWebView(
                    title: name,
                    selectedUrl: url,
                  )));
        },
        child: Container(
          margin: EdgeInsets.only(
              left: appBarHeight / 100, bottom: appBarHeight / 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    iconweb,
                    color: Colors.white,
                    size: s60,
                  ),
                  SizedBox(
                    width: screenWidthDp / 50,
                  ),
                  Text(
                    name,
                    style: TextStyle(color: Colors.white, fontSize: s52),
                  )
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: s42,
              )
            ],
          ),
        ));
  }

  Widget web() {
    return WebView(
      initialUrl: selectedUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
    );
  }

  Widget appbar_ListOptionSetting(BuildContext context, icon, name) {
    return Container(
      height: appBarHeight / 1.42,
      width: screenWidthDp,
      color: Colors.black,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidthDp / 21,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
              child: Icon(Icons.arrow_back, color: Colors.white, size: s60),
              onTap: () {
                Navigator.pop(context);
              }),
          Text(
            '\t' + name,
            style: TextStyle(
              fontSize: s52,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          // เปลี่ยนเป็น sizedbox ก็ได้
          GestureDetector(
              child: Icon(
                Icons.more_horiz,
                color: Colors.black,
                size: s65,
              ),
              onTap: () {
                // null only
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: appBarHeight / 1.5), child: web()),
          appbar_ListOptionSetting(context, Icons.web, title),
        ],
      )),
    );
  }
}

class CreateProfile2 extends StatefulWidget {
  @override
  _CreateProfile2State createState() => _CreateProfile2State();
}

class _CreateProfile2State extends State<CreateProfile2> {
  DateTime now = DateTime.now(), birthDay;
  StreamSubscription loadStatus;
  String genders;
  bool loading = false, checkpromise = false;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;

  String _format = 'yyyy-MMMM-dd';
  String minDateTime = '1920-01-01';
  String maxDateTime = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String initialDateTime = DateFormat("yyyy-MM-dd").format(DateTime.now());

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
    Size scr = MediaQuery.of(context).size;
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: appBarHeight,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: scr.width / 10, left: scr.width / 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'เกือบเสร็จแล้ว!',
                          style: TextStyle(
                            fontSize: scr.width / 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'สำหรับการให้ของขวัญในโอกาสพิเศษ',
                          style: TextStyle(
                            fontSize: scr.width / 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 20, 0),
                    margin: EdgeInsets.only(top: scr.width / 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'วันเกิด',
                              style: TextStyle(
                                  color: Colors.white, fontSize: scr.width / 8),
                            ),
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => _showDatePicker(),
                                  child: Icon(
                                    Icons.date_range,
                                    size: scr.width / 12,
                                    color: Color(0xff26A4FF),
                                  ),
                                ),
                                SizedBox(
                                  width: appBarHeight / 10,
                                ),
                                GestureDetector(
                                  child: Text(
                                    birthDay != null
                                        ? DateFormat('d/M/y').format(birthDay)
                                        : 'วัน/เดือน/ปี',
                                    style: TextStyle(
                                      color: Color(0xff26A4FF),
                                      fontSize: s60,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onTap: () => _showDatePicker(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'เพศ',
                              style: TextStyle(
                                  color: Colors.white, fontSize: scr.width / 8),
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: appBarHeight / 10,
                                ),
                                Radio(
                                  onChanged: (String ty) {
                                    setState(() => genders = ty);
                                  },
                                  value: 'male',
                                  groupValue: genders,
                                  activeColor: Color(0xff26A4FF),
                                ),
                                Text(
                                  'ชาย',
                                  style: TextStyle(
                                      fontSize: s60, color: Colors.white),
                                ),
                                Radio(
                                  onChanged: (String ty) {
                                    setState(() => genders = ty);
                                  },
                                  value: 'female',
                                  groupValue: genders,
                                  activeColor: Color(0xff26A4FF),
                                ),
                                Text(
                                  'หญิง',
                                  style: TextStyle(
                                      fontSize: s60, color: Colors.white),
                                ),
                                Radio(
                                  onChanged: (String ty) {
                                    setState(() => genders = ty);
                                  },
                                  value: 'LGBTQ',
                                  groupValue: genders,
                                  activeColor: Color(0xff26A4FF),
                                ),
                                Text(
                                  'LGBTQ',
                                  style: TextStyle(
                                      fontSize: s60, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: appBarHeight / 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Checkbox(
                              value: checkpromise,
                              onChanged: (bool value) {
                                setState(() {
                                  checkpromise = value;
                                });
                              },
                            ),
                            Text(
                              'ฉันได้อ่านและยอมรับ\t',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: s42,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              child: Text(
                                'นโยบายและข้อกำหนด',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Color(0xfff26A4FF),
                                    fontSize: s42,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    //ฟังก์ชั่นส่งไปยัง MyWebView ซึ่งเป็น stl less มาจาก plugin webview
                                    builder: (BuildContext context) =>
                                        MyWebView(
                                          title: "นโยบายและข้อกำหนด",
                                          selectedUrl:
                                              'https://scrap.bualoitech.com/termsofservice-and-policy.html',
                                        )));
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: appBarHeight / 2),
                        genders != null &&
                                checkpromise != false &&
                                birthDay != null
                            ? finished()
                            : unfinished()
                        /* Padding(
                          padding: EdgeInsets.only(top: appBarHeight / 2.5),
                          child: 
                          
                          
                          MaterialButton(
                            child: Text('เสร็จสิ้น',
                                style: TextStyle(
                                  fontSize: scr.width / 15,
                                  color: Color(0xfffffffff),
                                  fontWeight: FontWeight.w800,
                                )),
                            onPressed: () async {
                              if (bDay != now) {
                                _formKey.currentState.save();
                                setState(() {
                                  loading = true;
                                });
                                await creatProfile();
                              } else {
                                bDay == now
                                    ? Taoast()
                                        .toast('อย่าลืมเลือกวันเกิดของคุณ')
                                    : null;
                              }
                            },
                            color: Color(0xff26A4FF),
                            elevation: 0,
                            minWidth: 350,
                            height: 60,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
            loading ? Loading() : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget finished() {
    return Container(
      child: GestureDetector(
        child: Center(
          child: Container(
            padding: EdgeInsets.only(top: appBarHeight / 10),
            decoration: BoxDecoration(
                color: Color(0xfff26A4FE),
                borderRadius: BorderRadius.all(Radius.circular(7))),
            height: appBarHeight / 1.7,
            width: appBarHeight * 3.2,
            child: Text(
              'เสร็จสิ้น',
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.1,
                  color: Colors.white,
                  fontSize: s48,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        onTap: () {
          authService.setAccount(context, birthday: birthDay, gender: genders);
        },
      ),
    );
  }

  Widget unfinished() {
    return Container(
      child: Center(
        child: Container(
          padding: EdgeInsets.only(top: appBarHeight / 10),
          decoration: BoxDecoration(
              color: Color(0xfff515151),
              borderRadius: BorderRadius.all(Radius.circular(7))),
          height: appBarHeight / 1.7,
          width: appBarHeight * 3.2,
          child: Text(
            'เสร็จสิ้น',
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.1,
                color: Colors.white,
                fontSize: s48,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        itemTextStyle: TextStyle(fontSize: s42),
        showTitle: true,
        confirm: Text(
          'เสร็จ',
          style: TextStyle(
            color: Color(0xff26A4FF),
            fontSize: s42,
          ),
        ),
        cancel: Text(
          'ยกเลิก',
          style: TextStyle(
            color: Colors.red,
            fontSize: s42,
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
}
