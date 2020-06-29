import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/BottomBarItem/Profile.dart';
import 'package:scrap/Page/bottomBarItem/Explore/ExplorePage.dart';
import 'package:scrap/Page/bottomBarItem/PageView/PageViewActivity.dart';
import 'package:scrap/Page/bottomBarItem/WriteScrap.dart';
import 'package:scrap/Page/bottomBarItem/feed/FeedPage.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/method/Globalkey.dart';
import 'package:scrap/method/Navigator.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/stream/UserStream.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scrap/widget/guide.dart';
import 'package:scrap/widget/warning.dart';

class MainStream extends StatefulWidget {
  final int initPage;
  MainStream({this.initPage = 0});
  @override
  _MainStreamState createState() => _MainStreamState();
}

class _MainStreamState extends State<MainStream> {
  int currentIndex = 0;
  var pageController;

  final bodyList = [
    FeedPage(),
    ExplorePage(),
    PageViewActivity(),
    Profile(),
  ];

  void onTap(int index) {
    setState(() => currentIndex = index);
    pageController.jumpToPage(index);
  }

  @override
  void initState() {
    userStream.initTransactionStream(context);
    currentIndex = widget.initPage;
    pageController = PageController(initialPage: currentIndex);
    initUser();
    super.initState();
  }

  initUser() async {
    final user = Provider.of<UserData>(context, listen: false);
    var data = await userinfo.readContents();
    user.img = data['img'];
    user.id = data['id'];
    user.imgUrl = data['imgUrl'];
    user.promise = data['promise'];
  }

  @override
  void didUpdateWidget(MainStream oldWidget) {
    pageController.dispose();
    currentIndex = widget.initPage;
    pageController = PageController(initialPage: currentIndex);
    initUser();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final location = Provider.of<Position>(context);
    screenutilInit(context);
    return WillPopScope(
      onWillPop: () async {
        Dg().warnDialog(context, 'คุณต้องการออกจาก Scrap ใช่หรือไม่', () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        });
        return null;
      },
      child: Scaffold(
          key: myGlobals.scaffoldKey,
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
                )),
    );
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
            GestureDetector(
              child: Container(
                height: screenWidthDp / 15,
                width: screenWidthDp / 15,
                child: SvgPicture.asset(
                  'assets/write-icon.svg',
                  color: Color(0xffff5f5f5),
                ),
              ),
              onTap: () {
                final location = Provider.of<Position>(context, listen: false);
                if (location != null) nav.push(context, WriteScrap(main: true));
              },
            ),
            activebutton(2, 'assets/bag-fill-icon.svg', 'assets/bag-icon.svg'),
            activebutton(
                3, 'assets/profile-fill-icon.svg', 'assets/profile-icon.svg'),
          ]),
    );
  }
}
//------------------------
