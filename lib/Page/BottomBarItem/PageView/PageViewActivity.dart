import 'package:flutter/material.dart';
import 'package:scrap/Page/bottomBarItem/PageView/Activity.dart';
import 'package:scrap/Page/bottomBarItem/PageView/Backpack.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class PageViewActivity extends StatefulWidget {
  @override
  _PageViewActivityState createState() => _PageViewActivityState();
}

class _PageViewActivityState extends State<PageViewActivity>
    with AutomaticKeepAliveClientMixin {
  int page = 0;
  var controller = PageController();
  bool loading = true;
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    height: screenHeightDp / 14,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 2.1,
                                color: page != 0
                                    ? Colors.transparent
                                    : Colors.white))),
                    child: Text(
                      "กิจกรรม",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: page != 0 ? Colors.white70 : Colors.white,
                          fontSize: s54,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {
                    if (controller.page != 0)
                      controller.previousPage(
                          duration: Duration(milliseconds: 120),
                          curve: Curves.ease);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      height: screenHeightDp / 14,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 2.1,
                                  color: page != 1
                                      ? Colors.transparent
                                      : Colors.white))),
                      child: Text("กระเป๋า",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: page != 1 ? Colors.white70 : Colors.white,
                              fontSize: s52,
                              fontWeight: FontWeight.bold)),
                    ),
                    onTap: () {
                      if (controller.page != 1)
                        controller.nextPage(
                            duration: Duration(milliseconds: 120),
                            curve: Curves.ease);
                    }),
              )
            ]),
            Expanded(
              child: PageView(
                  controller: controller,
                  onPageChanged: (index) {
                    setState(() => page = index);
                  },
                  children: <Widget>[Activity(), Backpack()]),
            )
          ],
        ),
      ),
    );
  }
}
