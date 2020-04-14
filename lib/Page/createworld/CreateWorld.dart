import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrap/Page/createworld/ConfigWorld.dart';
import 'package:scrap/theme/AppColors.dart';
import 'package:scrap/theme/ScreenUtil.dart';

class CreateWorld extends StatefulWidget {
  @override
  _CreateWorldState createState() => _CreateWorldState();
}

class _CreateWorldState extends State<CreateWorld> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: defaultScreenWidth,
        height: defaultScreenHeight,
        allowFontScaling: fontScaling);
    return Scaffold(
        backgroundColor: AppColors.black,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: AppColors.black,
                    width: screenWidthDp,
                    height: screen.setHeight(130),
                    padding: EdgeInsets.only(
                      top: screen.setHeight(15),
                      right: screen.setWidth(20),
                      left: screen.setWidth(20),
                      bottom: screen.setHeight(15),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            child: Container(
                              width: screen.setWidth(100),
                              height: screen.setHeight(75),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(screenWidthDp),
                                  color: AppColors.arrowBackBg),
                              child: Icon(
                                Icons.arrow_back,
                                color: AppColors.arrowBackIcon,
                                size: screen.setSp(48),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(
                                context,
                              );
                            },
                          ),
                        ]),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  top: screen.setHeight(130),
                ),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: screenWidthDp,
                      minHeight: screenHeightDp -
                          statusBarHeight -
                          screen.setHeight(130),
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            flex: 12,
                            child: Container(
                              width: screenWidthDp,
                              margin: EdgeInsets.only(
                                right: screen.setWidth(70),
                                left: screen.setWidth(70),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'เริ่มกันเลย!',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: screen.setSp(65),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'เพิ่มข้อมูลเพื่อให้ผู้คนรู้จักโลกของคุณ',
                                    style: TextStyle(
                                      height: 0.8,
                                      color: AppColors.white,
                                      fontSize: screen.setSp(40),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 70,
                            child: Container(
                              margin: EdgeInsets.only(
                                right: screen.setWidth(70),
                                left: screen.setWidth(70),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: screenHeightDp / 40,
                                        bottom: screenHeightDp / 60),
                                    child: Center(
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            height: screen.setWidth(300),
                                            width: screen.setWidth(300),
                                            decoration: BoxDecoration(
                                              color: AppColors.imagePlaceholder,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      screenWidthDp),
                                              border: Border.all(
                                                color: AppColors
                                                    .imagePlaceholderBoder,
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
                                            right: screen.setWidth(20),
                                            bottom: screen.setWidth(0),
                                            child: Container(
                                              height: screen.setWidth(56),
                                              width: screen.setWidth(56),
                                              decoration: BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        ScreenUtil
                                                            .screenWidthDp),
                                              ),
                                              child: Icon(
                                                Icons.create,
                                                color: AppColors.iconDark,
                                                size: screen.setSp(38),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'ชื่อโลก',
                                    style: TextStyle(
                                      // height: 0.8,
                                      color: AppColors.textFieldLabel,
                                      fontSize: screen.setSp(40),
                                    ),
                                  ),
                                  Container(
                                    width: screenWidthDp,
                                    height: screen.setHeight(110),
                                    margin: EdgeInsets.only(
                                        bottom: screenHeightDp / 60,
                                        top: screenHeightDp / 80),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(screenWidthDp),
                                      color: AppColors.textField,
                                    ),
                                    child: Center(
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.textFieldInput,
                                          fontSize: screen.setSp(40),
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'ชื่อโลกของคุณ',
                                          hintStyle: TextStyle(
                                            color: AppColors.hintText,
                                            fontSize: screen.setSp(40),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'คำอธิบายสั้น ๆ',
                                    style: TextStyle(
                                      // height: 0.8,
                                      color: AppColors.textFieldLabel,
                                      fontSize: screen.setSp(40),
                                    ),
                                  ),
                                  Container(
                                    width: screenWidthDp,
                                    height: screen.setHeight(110),
                                    margin: EdgeInsets.only(
                                        bottom: screenHeightDp / 60,
                                        top: screenHeightDp / 80),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(screenWidthDp),
                                      color: AppColors.textField,
                                    ),
                                    child: Center(
                                      child: TextFormField(
                                        textInputAction: TextInputAction.done,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.textFieldInput,
                                          fontSize: screen.setSp(40),
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'เกี่ยวกับโลกของคุณ',
                                          hintStyle: TextStyle(
                                            color: AppColors.hintText,
                                            fontSize: screen.setSp(40),
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
                            flex: 18,
                            child: Column(
                              children: <Widget>[
                                GestureDetector(
                                  child: Container(
                                    width: screenWidthDp,
                                    height: screen.setHeight(110),
                                    margin: EdgeInsets.only(
                                      right: screen.setWidth(70),
                                      left: screen.setWidth(70),
                                    ),
                                    // margin:
                                    //     EdgeInsets.only(bottom: screenHeightDp / 40),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(screenWidthDp),
                                      color: AppColors.whiteButton,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'ต่อไป',
                                        style: TextStyle(
                                          color: AppColors.whiteButtonText,
                                          fontSize: screen.setSp(45),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ConfigWorld(),
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
