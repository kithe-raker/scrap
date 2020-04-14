import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrap/Page/createworld/CreateWorld.dart';
import 'package:scrap/theme/AppColors.dart';
import 'package:scrap/theme/ScreenUtil.dart';

class PreCreateWorld extends StatefulWidget {
  @override
  _PreCreateWorldState createState() => _PreCreateWorldState();
}

class _PreCreateWorldState extends State<PreCreateWorld> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
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
                                  'สร้างโลก',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: screen.setSp(65),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'สร้างโลกในแบบที่คุณต้องการ',
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
                            width: screenWidthDp,
                            margin: EdgeInsets.only(
                              right: screen.setWidth(70),
                              left: screen.setWidth(70),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(screenWidthDp),
                                    color: AppColors.black,
                                  ),
                                  width: screenWidthDp / 1.4,
                                  height: screenWidthDp / 1.4,
                                  child: ClipRRect(
                                    child: Image.network(
                                      'https://tarit.in.th/scrap/app_assets/Group144.png',
                                      fit: BoxFit.contain,
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
                                  height: screen.setWidth(100),
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
                                      builder: (context) => CreateWorld(),
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
      ),
    );
  }
}
