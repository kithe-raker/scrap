import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrap/theme/ScreenUtil.dart';
import 'package:scrap/theme/AppColors.dart';
import 'package:scrap/method/Navigator.dart';

class AppBarWithTitle extends StatefulWidget {
  final String title;
  const AppBarWithTitle(this.title);

  @override
  AppBarWithTitleState createState() => AppBarWithTitleState();
}

class AppBarWithTitleState extends State<AppBarWithTitle> {
  final nav = Nav();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: screenWidthDp,
          height: 130.h,
          padding: EdgeInsets.only(
            top: 15.h,
            right: 20.w,
            left: 20.w,
            bottom: 15.h,
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: 100.w,
                    height: 75.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidthDp),
                        color: AppColors.white),
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.black,
                      size: s48,
                    ),
                  ),
                  onTap: () {
                    nav.pop(context);
                  },
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 60.w,
                  ),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      height: 1.0,
                      color: AppColors.white,
                      fontSize: s45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]),
        ),
      ],
    );
  }
}

class AppBarWithArrow extends StatelessWidget {
  final nav = Nav();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: screenWidthDp,
          height: 130.h,
          padding: EdgeInsets.only(
            top: 15.h,
            right: 20.w,
            left: 20.w,
            bottom: 15.h,
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: 100.w,
                    height: 75.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidthDp),
                        color: AppColors.white),
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.black,
                      size: s48,
                    ),
                  ),
                  onTap: () {
                    nav.pop(context);
                  },
                ),
              ]),
        ),
      ],
    );
  }
}

class AppBarMainLogin extends StatelessWidget {
  final nav = Nav();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: screenWidthDp,
          height: 130.h,
          padding: EdgeInsets.only(
            top: 15.h,
            right: 70.w,
            left: 70.w,
            bottom: 15.h,
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    height: 80.h,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/SCRAP.png',
                    ),
                  ),
                  onTap: () {
                    nav.pop(context);
                  },
                ),
              ]),
        ),
      ],
    );
  }
}
