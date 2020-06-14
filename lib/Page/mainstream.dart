import 'package:flutter/material.dart';
import 'package:scrap/Page/HomePage.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:flutter_svg/svg.dart';

var index = 0;

class MainStream extends StatefulWidget {
  @override
  _MainStreamState createState() => _MainStreamState();
}

class _MainStreamState extends State<MainStream> {
  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: HomePage(),
      bottomNavigationBar: bottom(),
    );
  }

  Widget activebutton(var _index, String icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          index = _index;
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
    return Container(
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
