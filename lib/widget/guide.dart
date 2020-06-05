import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'ScreenUtil.dart';

Widget guide(Size a, String text) {
  return Container(
    height: a.height / 2.4,
    width: a.width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Image.asset(
        //   'assets/paper.png',
        //   color: Colors.white60,
        //   height: a.height / 10,
        // ),
        SvgPicture.asset('assets/paper.svg',
            color: Colors.white60,
            height: screenWidthDp / 3.5,
            fit: BoxFit.contain),
        Text(
          text,
          style: TextStyle(
              fontSize: a.width / 16,
              color: Colors.white60,
              fontWeight: FontWeight.w300),
        ),
      ],
    ),
  );
}
