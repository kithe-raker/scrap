import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrap/Page/authentication/not_registered/phone/CreateProfile2.dart';
import 'package:scrap/Page/authentication/not_registered/social/CreateProfile1.dart';
import 'package:scrap/theme/AppColors.dart';
import 'package:scrap/theme/ScreenUtil.dart';
import 'package:scrap/method/Navigator.dart';

class SocialLogin extends StatefulWidget {
  @override
  _SocialLoginState createState() => _SocialLoginState();
}

class _SocialLoginState extends State<SocialLogin> {
  final nav = Nav();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Divider(
                color: AppColors.white30,
                thickness: 0.4,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 15.w,
                right: 15.w,
              ),
              child: Text(
                'หรือ',
                style: TextStyle(
                  color: AppColors.white30,
                  fontSize: s34,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppColors.white30,
                thickness: 0.4,
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(screenWidthDp),
                    border: Border.all(
                      color: AppColors.white,
                      width: 0.2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'f',
                      style: TextStyle(
                        height: 1.2,
                        color: AppColors.white,
                        fontSize: s70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  nav.push(context, CreateProfile1());
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(screenWidthDp),
                  border: Border.all(
                    color: AppColors.white,
                    width: 0.2,
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.all(15.w),
                  child: Image.network(
                    'https://tarit.in.th/scrap/app_assets/icon/gmail.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(screenWidthDp),
                  border: Border.all(
                    color: AppColors.white,
                    width: 0.2,
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.all(15.w),
                  child: Image.network(
                    'https://tarit.in.th/scrap/app_assets/icon/twitter.png',
                    fit: BoxFit.contain,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
