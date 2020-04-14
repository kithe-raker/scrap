import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainLogin extends StatefulWidget {
  @override
  _MainLoginState createState() => _MainLoginState();
}

class _MainLoginState extends State<MainLogin> {
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
            children: <Widget>[],
          ),
        ),
      ),
    );
  }
}
