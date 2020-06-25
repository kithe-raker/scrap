import 'package:flutter/material.dart';
import 'package:scrap/Page/bottomBarItem/feed/FeedFollowing.dart';
import 'package:scrap/Page/bottomBarItem/feed/FeedHotScrap.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final pageController = PageController();
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          PageView(
            controller: pageController,
            children: <Widget>[FeedHotScrap(), FeedFollowng()],
          ),
          Align(alignment: Alignment.topCenter, child: topBar())
        ],
      ),
    );
  }

  Widget topBar() {
    return Container(
      margin: EdgeInsets.only(top: screenHeightDp / 16),
      padding:
          EdgeInsets.symmetric(horizontal: screenWidthDp / 42, vertical: 2.4),
      decoration: BoxDecoration(
          color: Color(0xff2E2E2E),
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 4.2,
                spreadRadius: 1.8,
                offset: Offset(0.0, 3.2))
          ],
          borderRadius: BorderRadius.circular(screenWidthDp / 64)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidthDp / 42),
            child: Text('สแครปน่าสนใจ',
                style: TextStyle(color: Colors.white, fontSize: s42)),
          ),
          Text('|', style: TextStyle(color: Colors.white, fontSize: s46)),
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidthDp / 42),
            child: Text('คนที่ติดตามเก็บ',
                style: TextStyle(color: Colors.white, fontSize: s42)),
          ),
        ],
      ),
    );
  }
}
