import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrap/Page/MapScraps.dart';
import 'package:scrap/Page/suppeople.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/SearchPlaceBox.dart';

class SearchEveryThing extends StatefulWidget {
  @override
  _SearchEveryThingState createState() => _SearchEveryThingState();
}

class _SearchEveryThingState extends State<SearchEveryThing> {
  var index = 0;
  bool loading = true, searching = false;
  String search;
  final pageController = PageController();
  final TextEditingController _controller = new TextEditingController();
  var focus = FocusNode();
  int currentIndex = 0;
  StreamController<String> streamController = StreamController();

  void onTap(int _index) {
    setState(() => index = _index);
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Container(
        child: Stack(
          children: <Widget>[
            PageView(
              controller: pageController,
              children: [MapScraps(), Subpeople()],
              physics: NeverScrollableScrollPhysics(), // No sliding
            ),
            Positioned(
                top: screenWidthDp / 7,
                child: Container(
                  height: screenWidthDp / 10,
                  width: screenWidthDp,
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      SizedBox(width: screenWidthDp / 25),
                      // selectbutton('สถานที่'),
                      // selectbutton('ผู้คน')
                      Container(
                        width: screenWidthDp / 5,
                        child: GestureDetector(
                          onTap: () => onTap(0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xfff26A4FF)),
                                borderRadius:
                                    BorderRadius.circular(screenWidthDp),
                                color: index == 0
                                    ? Color(0xfff26A4FF)
                                    : Colors.black),
                            child: Text(
                              'สถานที่',
                              style: TextStyle(
                                color: index == 0
                                    ? Colors.white
                                    : Color(0xfff26A4FF),
                                fontSize: s52,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidthDp / 50),
                      Container(
                        width: screenWidthDp / 5,
                        child: GestureDetector(
                          onTap: () => onTap(1),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xfff26A4FF)),
                                borderRadius:
                                    BorderRadius.circular(screenWidthDp),
                                color: index == 1
                                    ? Color(0xfff26A4FF)
                                    : Colors.black),
                            child: Text(
                              'ผู้คน',
                              style: TextStyle(
                                color: index == 1
                                    ? Colors.white
                                    : Color(0xfff26A4FF),
                                fontSize: s52,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        //color: Colors.red,
                        width: screenWidthDp / 5,
                      ),
                      Container(
                        // color: Colors.green,
                        width: screenWidthDp / 5,
                      ),
                      Container(
                        // color: Colors.blue,
                        width: screenWidthDp / 5,
                      ),
                    ],
                  ),
                )),
            Container(
              padding: EdgeInsets.only(top: screenWidthDp / 50),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: index == 0
                        ? Container(
                            margin: EdgeInsets.only(
                                left: screenWidthDp / 25,
                                right: screenWidthDp / 25 / 2),
                            child: SearchPlaceBox())
                        : Container(
                            height: screenWidthDp / 8 / 1.2,
                            padding: EdgeInsets.all(screenWidthDp / 100),
                            margin: EdgeInsets.only(
                                left: screenWidthDp / 25,
                                right: screenWidthDp / 25 / 2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                //color: Color(0xff262626),
                                color: Colors.black,
                                border: Border.all(color: Color(0xfff26A4FF))),
                            child: TextField(
                              controller: _controller,
                              focusNode: focus,
                              style:
                                  TextStyle(color: Colors.white, fontSize: s42),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                // fillColor: Colors.red,
                              ),
                              onTap: () {
                                focus.requestFocus();
                                setState(() => searching = true);
                              },
                              onChanged: (val) {
                                var trim = val.trim();
                                trim[0] == '@'
                                    ? streamController.add(trim.substring(1))
                                    : streamController.add(trim);
                              },
                            ),
                          ),
                  ),
                  searching
                      ? Row(
                          children: <Widget>[
                            SizedBox(width: screenWidthDp / 42),
                            GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xfff26A4FF)),
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(screenWidthDp))),
                                padding: EdgeInsets.all(screenWidthDp / 50),
                                child: Icon(
                                  Icons.clear,
                                  color: Color(0xfff26A4FF),
                                  size: s46,
                                ),
                              ),
                              onTap: () {
                                focus.unfocus();
                                _controller.clear();
                                setState(() => searching = false);
                              },
                            ),
                            SizedBox(width: screenWidthDp / 25),
                          ],
                        )
                      : SizedBox(width: screenWidthDp / 25 / 2)
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
