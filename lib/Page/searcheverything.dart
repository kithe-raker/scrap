import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrap/Page/suppeople.dart';
import 'package:scrap/widget/ScreenUtil.dart';

import 'MapScraps.dart';

class SearchEveryThing extends StatefulWidget {
  @override
  _SearchEveryThingState createState() => _SearchEveryThingState();
}

class _SearchEveryThingState extends State<SearchEveryThing> {
  var index = 0;
  var scrapindex = 0;
  final bodyList = [MapScraps(uid: null), Subpeople()];

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
    Size a = MediaQuery.of(context).size;
    var index = 0;
    return SafeArea(
        child: Container(
      child: Stack(
        children: <Widget>[
          Scaffold(
            body: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: bodyList,
              physics: NeverScrollableScrollPhysics(), // No sliding
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: screenWidthDp / 50),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: a.width / 8 / 1.2,
                    margin: EdgeInsets.only(
                        left: a.width / 25, right: a.width / 25 / 2),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      color: Color(0xff262626),
                    ),
                    child: TextField(
                      // controller: _controller,
                      // focusNode: focus,
                      style: TextStyle(color: Colors.white, fontSize: s42),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        // fillColor: Colors.red,
                      ),
                      onTap: () {},
                      onChanged: (val) {
                        //  var trim = val.trim();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              top: screenWidthDp / 7,
              child: Container(
                height: screenWidthDp / 10,
                width: screenWidthDp,
                padding: EdgeInsets.only(
                  left: a.width / 15,
                ),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    // selectbutton('สถานที่'),
                    // selectbutton('ผู้คน')
                    Container(
                      width: screenWidthDp / 5,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 0;
                            scrapindex = 0;
                            onTap(index);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xfff26A4FF)),
                              borderRadius:
                                  BorderRadius.circular(screenWidthDp),
                              color: scrapindex == 0
                                  ? Color(0xfff26A4FF)
                                  : Colors.black),
                          child: Text(
                            'สถานที่',
                            style: TextStyle(
                              color: scrapindex == 0
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
                      width: screenWidthDp / 50,
                    ),
                    Container(
                      width: screenWidthDp / 5,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 1;
                            scrapindex = 1;
                            onTap(index);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xfff26A4FF)),
                              borderRadius:
                                  BorderRadius.circular(screenWidthDp),
                              color: scrapindex == 1
                                  ? Color(0xfff26A4FF)
                                  : Colors.black),
                          child: Text(
                            'ผู้คน',
                            style: TextStyle(
                              color: scrapindex == 1
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
        ],
      ),
    ));
  }
}
