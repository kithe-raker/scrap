import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PennameLogin extends StatefulWidget {
  @override
  _PennameLoginState createState() => _PennameLoginState();
}

class _PennameLoginState extends State<PennameLogin> {
  String loginMode = 'phone';

  changeLogin(String mode) {
    setState(() {
      loginMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          height: ScreenUtil.screenHeightDp,
          width: ScreenUtil.screenWidthDp,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          Container(
                            margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(60),
                            ),
                            child: Text(
                              'ลงชื่อเข้าใช้',
                              style: TextStyle(
                                height: 1.0,
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(45),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
              Expanded(
                flex: 15,
                child: Container(),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'ThaiSans',
                                height: 0.9,
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(40),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '@tarit.in.th',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: ScreenUtil().setSp(70),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      Container(
                        width: ScreenUtil.screenWidthDp,
                        height: ScreenUtil().setHeight(110),
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setHeight(15),
                          bottom: ScreenUtil().setHeight(15),
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(ScreenUtil.screenWidthDp),
                          color: Color(0xff101010),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(50),
                              right: ScreenUtil().setWidth(50),
                            ),
                            child: Text(
                              'Password',
                              style: TextStyle(
                                color: Colors.white30,
                                fontSize: ScreenUtil().setSp(40),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          child: Text(
                            'ลืมรหัสผ่าน?',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              height: 1.0,
                              color: Colors.white70,
                              fontSize: ScreenUtil().setSp(38),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                      Container(
                        width: ScreenUtil.screenWidthDp,
                        height: ScreenUtil().setHeight(110),
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setHeight(50),
                          bottom: ScreenUtil().setHeight(25),
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(ScreenUtil.screenWidthDp),
                          color: Color(0xff26A4FF),
                        ),
                        child: Center(
                          child: Text(
                            'ดำเนินการต่อ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(45),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   child: Text(
                      //     loginMode == 'phone'
                      //         ? 'ลงชื่อเข้าใช้ด้วยนามปากกา'
                      //         : 'ลงชื่อเข้าใช้ด้วยเบอร์โทรศัพท์',
                      //     style: TextStyle(
                      //       decoration: TextDecoration.underline,
                      //       height: 1.0,
                      //       color: Colors.white70,
                      //       fontSize: ScreenUtil().setSp(38),
                      //     ),
                      //   ),
                      //   onTap: () {
                      //     changeLogin(
                      //         loginMode == 'phone' ? 'penname' : 'phone');
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(70),
                        right: ScreenUtil().setWidth(70),
                        bottom: ScreenUtil().setHeight(70),
                      ),
                      width: ScreenUtil.screenWidthDp,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Divider(
                                  color: Colors.white24,
                                  thickness: 0.4,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(15),
                                  right: ScreenUtil().setWidth(15),
                                ),
                                child: Text(
                                  'หรือ',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: ScreenUtil().setSp(34),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.white24,
                                  thickness: 0.4,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(15),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                width: ScreenUtil().setWidth(80),
                                height: ScreenUtil().setWidth(80),
                                decoration: BoxDecoration(
                                  color: Color(0xff0D0D0D),
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil.screenWidthDp),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 0.2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'f',
                                    style: TextStyle(
                                      height: 1.2,
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(70),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                width: ScreenUtil().setWidth(80),
                                height: ScreenUtil().setWidth(80),
                                decoration: BoxDecoration(
                                  color: Color(0xff0D0D0D),
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil.screenWidthDp),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 0.2,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                width: ScreenUtil().setWidth(80),
                                height: ScreenUtil().setWidth(80),
                                decoration: BoxDecoration(
                                  color: Color(0xff0D0D0D),
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil.screenWidthDp),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 0.2,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
