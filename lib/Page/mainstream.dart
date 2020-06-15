import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/BottomBarItem/FeedScrap.dart';
import 'package:scrap/Page/Gridfavorite.dart';
import 'package:scrap/Page/searcheverything.dart';
import 'package:scrap/stream/UserStream.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scrap/Page/profile/Profile.dart';
import 'package:scrap/widget/guide.dart';

import '../testt.dart';

class MainStream extends StatefulWidget {
  @override
  _MainStreamState createState() => _MainStreamState();
}

class _MainStreamState extends State<MainStream> {
  int currentIndex = 0;
  final pageController = PageController();

  final bodyList = [
    FeedScrap(),
    SearchEveryThing(),
    SecondPage(),
    Gridfavorite(),
    Profile(),
  ];

  void onTap(int index) {
    setState(() => currentIndex = index);
    pageController.jumpToPage(index);
  }

  @override
  void initState() {
    userStream.initTransactionStream(context);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var location = Provider.of<Position>(context);
    screenutilInit(context);
    return Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: bottom(),
        body: location != null
            ? PageView(
                controller: pageController,
                children: bodyList,
                physics: NeverScrollableScrollPhysics(), // No sliding
              )
            : Center(
                child: guide(Size(screenWidthDp, screenHeightDp),
                    'กรุณาตรวจสอบ GPS ของคุณ'),
              ));
  }

  Widget activebutton(var _index, String icon) {
    return GestureDetector(
      onTap: () => onTap(_index),
      child: Container(
        height: screenWidthDp / 10,
        width: screenWidthDp / 10,
        child: SvgPicture.asset(icon,
            color: currentIndex != _index ? Color(0xfff434343) : Colors.white),
      ),
    );
  }

  Widget bottom() {
    screenutilInit(context);
    return Container(
      decoration: BoxDecoration(color: Color(0xfff161414)),
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
            activebutton(4, 'assets/paper.svg')
          ]),
    );
  }
}
//------------------------
