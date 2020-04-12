import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:preload_page_view/preload_page_view.dart';

class ScrapWrite extends StatefulWidget {
  @override
  _ScrapWriteState createState() => _ScrapWriteState();
}

class _ScrapWriteState extends State<ScrapWrite> {
  int _index = 0, _page = 1, pageCount = 1;
  PageController pageController = PageController(viewportFraction: 1.0);
  bool textValidate = false, _showCreatePage = true;
  List<Widget> v = [];

  _goConfig() {
    print('setting');
  }

  void removePage(int index) {
    pageController.animateToPage(_page < pageCount ? index : index - 1,
        duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
    setState(() {
      pageCount -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          height: ScreenUtil.screenHeightDp,
          width: ScreenUtil.screenWidthDp,
          color: Color(0xff0e0e0e),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: Color(0xff0e0e0e),
                    width: ScreenUtil.screenWidthDp,
                    height: ScreenUtil.screenWidthDp / 5.5,
                    padding: EdgeInsets.only(
                      top: ScreenUtil.screenHeightDp / 80,
                      right: ScreenUtil().setWidth(20),
                      left: ScreenUtil().setWidth(20),
                      bottom: ScreenUtil.screenHeightDp / 80,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              width: ScreenUtil.screenWidthDp / 7,
                              height: ScreenUtil.screenWidthDp / 10,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil.screenWidthDp),
                                  color: Colors.white),
                              child: Icon(Icons.arrow_back,
                                  color: Colors.black,
                                  size: ScreenUtil.screenWidthDp / 15),
                            ),
                            onTap: () {
                              Navigator.pop(
                                context,
                              );
                            },
                          ),
                          InkWell(
                            child: Container(
                              width: ScreenUtil.screenWidthDp / 6,
                              height: ScreenUtil.screenWidthDp / 10,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil.screenWidthDp),
                                  color: Colors.white
                                      .withOpacity(!textValidate ? 0.3 : 1.0)),
                              child: Center(
                                  child: Text(
                                'ต่อไป',
                                style: TextStyle(
                                    color: Color(0xff0e0e0e),
                                    fontSize: ScreenUtil().setSp(40),
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                            onTap: !textValidate ? null : _goConfig,
                          ),
                        ]),
                  ),
                ],
              ),
              Container(
                height: ScreenUtil().setHeight(840),
                margin: EdgeInsets.only(top: ScreenUtil().setWidth(80)),
                color: Color(0xff0e0e0e),
                child: Listener(
                  onPointerUp: (event) {
                    setState(() {
                      // Set _showCreatePage to false for hidden createPage when removePage scroll animateToPage
                      _showCreatePage = false;
                    });
                  },
                  onPointerDown: (event) {
                    setState(() {
                      // Set _showCreatePage to true , when drag down for slide to create new page.
                      _showCreatePage = true;
                    });
                  },
                  child: PageView.builder(
                      // pageSnapping: false,
                      physics: BouncingScrollPhysics(),
                      onPageChanged: (int index) {
                        setState(() {
                          _index = index;
                          _page = index + 1;
                          if (_index == pageCount) {
                            // when create new page always set textValidate to false
                            textValidate = false;
                            pageCount += 1;
                          }
                        });
                      },
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: pageCount + 1,
                      itemBuilder: (context, index) {
                        if (index == _index) {
                          // Current page
                          return writePage(_page, pageCount);
                        } else if (index < _index) {
                          // Page before current page
                          return writePage(_page - 1, pageCount);
                        } else if (index > _index && _page < pageCount) {
                          // Page after current page
                          return writePage(_page + 1, pageCount);
                        } else if (_page == pageCount) {
                          // Slide to create new page. and Condition for drag down to create new page or removePage with animateToPage
                          return _showCreatePage ? createPage() : SizedBox();
                        }
                      }),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
                padding: EdgeInsets.only(
                  top: ScreenUtil.screenHeightDp / 80,
                  right: ScreenUtil().setWidth(10),
                  left: ScreenUtil().setWidth(10),
                  bottom: ScreenUtil.screenHeightDp / 80,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: ScreenUtil.screenWidthDp / 11,
                      height: ScreenUtil.screenWidthDp / 11,
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                      decoration: BoxDecoration(
                          // border: Border.all(color: Colors.white, width: 0.25),
                          color: Color(0xff6F6F6F).withOpacity(0.4),
                          borderRadius:
                              BorderRadius.circular(ScreenUtil.screenWidthDp)),
                      child: Icon(
                        Icons.create,
                        color: Colors.white.withOpacity(0.6),
                        size: ScreenUtil().setSp(35),
                      ),
                    ),
                    Container(
                      width: ScreenUtil.screenWidthDp / 11,
                      height: ScreenUtil.screenWidthDp / 11,
                      decoration: BoxDecoration(
                          // border: Border.all(color: Colors.white, width: 0.25),
                          color: Color(0xff6F6F6F).withOpacity(0.4),
                          borderRadius:
                              BorderRadius.circular(ScreenUtil.screenWidthDp)),
                      child: Icon(
                        Icons.image,
                        color: Colors.white.withOpacity(0.6),
                        size: ScreenUtil().setSp(35),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget writePage(int page, int pageCount) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Stack(
        children: <Widget>[
          Container(
            height: ScreenUtil.screenHeightDp,
            width: ScreenUtil.screenWidthDp,
            decoration: BoxDecoration(
              // color: color,
              borderRadius: BorderRadius.circular(ScreenUtil().setHeight(12)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ScreenUtil().setHeight(12)),
              child: Image.asset(
                'assets/paper-readed.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            child: Center(
                child: Text(
              'เขียนอะไรบางอย่างสิ',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(48),
              ),
            )),
          ),
          // page != 1
          //     ? Positioned(
          //         bottom: ScreenUtil().setHeight(30),
          //         left: ScreenUtil().setHeight(30),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: <Widget>[
          //             Container(
          //               width: ScreenUtil.screenWidthDp / 11,
          //               height: ScreenUtil.screenWidthDp / 11,
          //               margin:
          //                   EdgeInsets.only(right: ScreenUtil().setWidth(10)),
          //               decoration: BoxDecoration(
          //                   // border: Border.all(color: Colors.white, width: 0.25),
          //                   color: Color(0xff6F6F6F).withOpacity(0.4),
          //                   borderRadius: BorderRadius.circular(
          //                       ScreenUtil.screenWidthDp)),
          //               child: Icon(
          //                 Icons.create,
          //                 color: Colors.black.withOpacity(0.6),
          //                 size: ScreenUtil().setSp(35),
          //               ),
          //             ),
          //             Container(
          //               width: ScreenUtil.screenWidthDp / 11,
          //               height: ScreenUtil.screenWidthDp / 11,
          //               decoration: BoxDecoration(
          //                   // border: Border.all(color: Colors.white, width: 0.25),
          //                   color: Color(0xff6F6F6F).withOpacity(0.4),
          //                   borderRadius: BorderRadius.circular(
          //                       ScreenUtil.screenWidthDp)),
          //               child: Icon(
          //                 Icons.image,
          //                 color: Colors.black.withOpacity(0.6),
          //                 size: ScreenUtil().setSp(35),
          //               ),
          //             ),
          //           ],
          //         ),
          //       )
          //     : SizedBox(),

          Positioned(
            bottom: ScreenUtil().setHeight(30),
            right: ScreenUtil().setHeight(30),
            child: Container(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(20),
                  right: ScreenUtil().setWidth(20)),
              decoration: BoxDecoration(
                  color: Color(0xff6F6F6F).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(ScreenUtil.screenWidth)),
              child: Text(
                '$page/$pageCount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(32),
                ),
              ),
            ),
          ),
          pageCount > 1 || _page != 1
              ? Positioned(
                  top: ScreenUtil().setHeight(20),
                  left: ScreenUtil().setHeight(20),
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.all(
                        ScreenUtil().setWidth(5),
                      ),
                      decoration: BoxDecoration(
                          color: Color(0xff6F6F6F).withOpacity(0.3),
                          borderRadius:
                              BorderRadius.circular(ScreenUtil.screenWidth)),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: ScreenUtil().setSp(30),
                      ),
                    ),
                    onTap: () {
                      removePage(_index);
                    },
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }

  Widget createPage() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Stack(
        children: <Widget>[
          Container(
            height: ScreenUtil.screenHeightDp,
            width: ScreenUtil.screenWidthDp / 2.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: ScreenUtil.screenWidthDp / 7,
                  height: ScreenUtil.screenWidthDp / 7,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 0.25),
                      borderRadius:
                          BorderRadius.circular(ScreenUtil.screenWidthDp)),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: ScreenUtil().setSp(52),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil.screenWidthDp / 30,
                ),
                Text(
                  'ปัดหน้าจอ \nเพื่อเขียนแผ่นใหม่',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
