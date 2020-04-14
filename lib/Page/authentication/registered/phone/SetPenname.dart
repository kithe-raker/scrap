import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrap/Page/authentication/registered/phone/SetYourInfo.dart';

class SetPenname extends StatefulWidget {
  @override
  _SetPennameState createState() => _SetPennameState();
}

class _SetPennameState extends State<SetPenname> {
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
                                    'เกือบเสร็จแล้ว!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(65),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'เพิ่มข้อมูลของคุณเพื่อให้ผู้คนค้นหาคุณเจอ',
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil.screenHeightDp / 40,
                                        bottom: ScreenUtil.screenHeightDp / 40),
                                    child: Center(
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            height: ScreenUtil().setWidth(300),
                                            width: ScreenUtil().setWidth(300),
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ScreenUtil.screenWidthDp),
                                              border: Border.all(
                                                color: Color(0xff8E8E8E),
                                                width: 1.5,
                                              ),
                                            ),
                                            // child: ClipRRect(
                                            //   borderRadius:
                                            //       BorderRadius.circular(300),
                                            //   child: Image.network(
                                            //     'https://tarit.in.th/scrap/app_assets/globe-01-512.png',
                                            //     fit: BoxFit.cover,
                                            //   ),
                                            // ),
                                          ),
                                          Positioned(
                                            right: ScreenUtil().setWidth(20),
                                            bottom: ScreenUtil().setWidth(0),
                                            child: Container(
                                              height: ScreenUtil().setWidth(55),
                                              width: ScreenUtil().setWidth(55),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        ScreenUtil
                                                            .screenWidthDp),
                                              ),
                                              child: Icon(
                                                Icons.create,
                                                color: Color(0xff4A4A4A),
                                                size: ScreenUtil().setSp(34),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
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
                                          text: 'นามปากกา',
                                          style: TextStyle(
                                            fontFamily: 'ThaiSans',
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(40),
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' (ผู้คนจะรู้จักคุณในชื่อนี้)',
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
                                        textInputAction: TextInputAction.done,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(40),
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: '@penname',
                                          hintStyle: TextStyle(
                                            color: Colors.white30,
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
                                        'ต่อไป',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(45),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SetYourInfo(),
                                      ),
                                    );
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
