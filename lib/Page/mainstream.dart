import 'package:flutter/material.dart';
import 'package:scrap/Page/BottomBarItem/FeedScrap.dart';
import 'package:scrap/Page/HomePage.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class MainStream extends StatefulWidget {
  @override
  _MainStreamState createState() => _MainStreamState();
}

class _MainStreamState extends State<MainStream> {
  bool index = false;
  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
        bottomNavigationBar: Container(
          child: Container(
            height: appBarHeight,
            color: Colors.white,
            child: GestureDetector(
              child: Text('test'),
              onTap: () {
                setState(() => index = !index);
              },
            ),
          ),
        ),
        backgroundColor: Colors.black,
        body: index
            ? Container(
                color: Colors.red[100],
                child: Center(
                  child: Text('data'),
                ),
              )
            : FeedScrap());
  }
}
