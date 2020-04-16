import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrap/Page/authentication/not_registered/phone/CreateProfile2.dart';
import 'package:scrap/theme/ScreenUtil.dart';
import 'package:scrap/theme/AppColors.dart';
import 'package:scrap/widget/AppBar.dart';
import 'package:scrap/method/Navigator.dart';

class CreateProfile1 extends StatefulWidget {
  @override
  _CreateProfile1State createState() => _CreateProfile1State();
}

class _CreateProfile1State extends State<CreateProfile1> {
  final nav = Nav();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: fontScaling,
    );
    return Scaffold(
        backgroundColor: AppColors.bg,
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
                                    'เกือบเสร็จแล้ว!',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: s65,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'เพิ่มข้อมูลของคุณเพื่อให้ผู้คนค้นหาคุณเจอ',
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: screenHeightDp / 40,
                                        bottom: screenHeightDp / 40),
                                    child: Center(
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            height: 300.w,
                                            width: 300.w,
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
                                            right: 20.w,
                                            bottom: 0,
                                            child: Container(
                                              height: 55.w,
                                              width: 55.w,
                                              decoration: BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        screenWidthDp),
                                              ),
                                              child: Icon(
                                                Icons.create,
                                                color: AppColors.iconDark,
                                                size: s34,
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
                                          text: 'นามปากกา',
                                          style: TextStyle(
                                            fontFamily: 'ThaiSans',
                                            color: AppColors.white,
                                            fontSize: s40,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' (ผู้คนจะรู้จักคุณในชื่อนี้)',
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
                                        textInputAction: TextInputAction.done,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: s40,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: '@penname',
                                          hintStyle: TextStyle(
                                            color: AppColors.white30,
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
                                        'ต่อไป',
                                        style: TextStyle(
                                          color: AppColors.blueButtonText,
                                          fontSize: ScreenUtil().setSp(45),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    nav.push(context, CreateProfile2());
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
