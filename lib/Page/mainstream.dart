import 'package:flutter/material.dart';
import 'package:scrap/Page/Gridfavorite.dart';
import 'package:scrap/Page/Gridsubscripe.dart';
import 'package:scrap/Page/HomePage.dart';
import 'package:scrap/Page/searcheverything.dart';
import 'package:scrap/Page/suppeople.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scrap/Page/profile/Profile.dart';

import '../testt.dart';

class MainStream extends StatefulWidget {
  @override
  _MainStreamState createState() => _MainStreamState();
}

class _MainStreamState extends State<MainStream> {
  var index = 0;

  final bodyList = [
    SecondPage(),
    SearchEveryThing(),
    Gridsubscripe(),
    Gridfavorite(),
    Profile(),
  ];

  final pageController = PageController();

  int currentIndex = 0;

  void onTap(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: bottom(),
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          children: bodyList,
          physics: NeverScrollableScrollPhysics(), // No sliding
        ));
  }

  Widget activebutton(var _index, String icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          index = _index;
          onTap(index);
        });
      },
      child: Container(
        height: screenWidthDp / 10,
        width: screenWidthDp / 10,
        child: SvgPicture.asset(icon,
            color: index != _index ? Color(0xfff434343) : Colors.white),
      ),
    );
  }

  Widget bottom() {
    screenutilInit(context);
    return Container(
      decoration: BoxDecoration(
        color: Color(0xfff161414),
      ),
      height: screenWidthDp / 5,
      width: screenWidthDp,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          activebutton(0, 'assets/paper.svg'),
          activebutton(1, 'assets/paper.svg'),
          activebutton(2, 'assets/paper.svg'),
          activebutton(3, 'assets/paper.svg'),
          activebutton(4, 'assets/paper.svg'),
        ],
      ),
    );
  }
}
//------------------------
