import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:scrap/Page/bottomBarItem/feed/FeedFollowing.dart';
import 'package:scrap/Page/bottomBarItem/feed/FeedHotScrap.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with TickerProviderStateMixin {
  final pageController = PageController();
  int current = 0;
  StreamSubscription topbarSub;
  AnimationController animateController;
  var animation;

  @override
  void initState() {
    animateController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 175));
    animation = Tween(begin: 0.0, end: 1.0).animate(animateController);
    topbarSub = topbarStream.listen((value) => displayTopBar(value));
    super.initState();
  }

  @override
  void dispose() {
    animateController.dispose();
    pageController.dispose();
    topbarSub.cancel();
    super.dispose();
  }

  displayTopBar(int duration) {
    if (!animateController.isAnimating) {
      animateController.forward();
      Future.delayed(
          Duration(milliseconds: duration), () => animateController.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          PageView(
            onPageChanged: (index) {
              topbarStream.add(2100);
              setState(() => current = index);
            },
            controller: pageController,
            children: <Widget>[FeedHotScrap(), FeedFollowng()],
          ),
          Align(alignment: Alignment.topCenter, child: topBar()),
        ],
      ),
    );
  }

  Widget topBar() {
    return FadeTransition(
      opacity: animateController,
      child: Container(
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
            textGesture(0, text: 'สแครปน่าสนใจ'),
            Text('|', style: TextStyle(color: Colors.white, fontSize: s46)),
            textGesture(1, text: 'คนที่ติดตามเก็บ')
          ],
        ),
      ),
    );
  }

  Widget textGesture(int index, {@required String text}) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: screenWidthDp / 42),
        child: Text(text,
            style: TextStyle(
                color: current != index ? Colors.white70 : Colors.white,
                fontSize: s42,
                fontWeight: FontWeight.bold)),
      ),
      onTap: () {
        pageController.animateToPage(index,
            duration: Duration(milliseconds: 420), curve: Curves.easeOut);
        setState(() => current = index);
      },
    );
  }
}

final topbarStream = BehaviorSubject<int>();
