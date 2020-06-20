import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/BottomBarItem/Backpack.dart';
import 'package:scrap/Page/BottomBarItem/FeedScrap.dart';
import 'package:scrap/Page/BottomBarItem/Profile.dart';
import 'package:scrap/Page/BottomBarItem/searcheverything.dart';
import 'package:scrap/Page/Gridfavorite.dart';
import 'package:scrap/stream/UserStream.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:flutter_svg/svg.dart';
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
    Backpack(),
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

  Widget activebutton(var _index, String activeicon, String unactiveicon) {
    return GestureDetector(
      onTap: () => onTap(_index),
      child: Container(
        height: screenWidthDp / 15,
        width: screenWidthDp / 15,
        child: SvgPicture.asset(
          currentIndex == _index ? activeicon : unactiveicon,
          color: Color(0xffff5f5f5),
        ),
      ),
    );
  }

  Widget bottom() {
    screenutilInit(context);
    return Container(
      decoration: BoxDecoration(color: Color(0xfff161414)),
      height: screenWidthDp / 6,
      width: screenWidthDp,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            activebutton(
                0, 'assets/home-fill-icon.svg', 'assets/home-icon.svg'),
            activebutton(
                1, 'assets/search-fill-icon.svg', 'assets/search-icon.svg'),
            activebutton(
                2, 'assets/write-fill-icon.svg', 'assets/write-icon.svg'),
            activebutton(3, 'assets/bag-fill-icon.svg', 'assets/bag-icon.svg'),
            activebutton(
                4, 'assets/profile-fill-icon.svg', 'assets/profile-icon.svg'),
          ]),
    );
  }
}
//------------------------
