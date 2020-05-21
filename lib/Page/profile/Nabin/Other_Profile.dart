import 'package:flutter/material.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Ads.dart';
import 'My_Profile.dart';

bool value = false;
/*
List Problem
- Text ก่อน wrap() ไม่อยู่ตรงกลาง ( control+F => ยุบพรรคอนาโค้งใหม่ )
- wrap() : ต้องเปลี่ยนเป็น "ตารางสแครปยอดนิยมและจากคนที่เราติดตาม" ตามใน XD
*/

// หน้า Profile ของคนอื่น
class Other_Profile extends StatefulWidget {
  @override
  _Other_ProfileState createState() => _Other_ProfileState();
}

class _Other_ProfileState extends State<Other_Profile> {
  int page = 0;
  var controller = PageController();
  // Appbar สำหรับ หน้า Profile ของคนอื่น
  Widget appbar_OtherProfile(BuildContext context) {
    return Container(
      height: appBarHeight / 1.35,
      width: screenWidthDp,
      margin: EdgeInsets.symmetric(
        horizontal: screenWidthDp / 100,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {}),
          IconButton(
              icon: Icon(
                Icons.more_horiz,
                color: Colors.white,
              ),
              onPressed: () {
                showButtonSheet(context);
              }),
        ],
      ),
    );
  }

  Widget followed() {
    return Container(
      child: GestureDetector(
        onTap: () {},
        //color: Colors.grey,
        child: Container(
          padding: EdgeInsets.fromLTRB(appBarHeight / 3, appBarHeight / 50,
              appBarHeight / 3, appBarHeight / 50),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xfff26A4FF)),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            'ติดตาม',
            style: TextStyle(
              color: Colors.white,
              fontSize: s40,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: appBarHeight / 1.35),
              color: Colors.black,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  //user_MyProfile(),
                  Column(
                    children: <Widget>[
                      // appbar_OtherProfile(context),
                      Container(
                        height: screenWidthDp / 3,
                        width: screenWidthDp / 3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(screenHeightDp),
                        ),
                      ),
                      SizedBox(
                        height: appBarHeight / 5,
                      ),
                      Text(
                        '@MIKE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: s60,
                        ),
                      ),
                      SizedBox(
                        height: appBarHeight / 10,
                      ),
                      Container(
                        /*margin: EdgeInsets.symmetric(
                          horizontal: screenWidthDp / 40,
                        ),*/
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            dataProfile(15, 'เก็บไว้'),
                            dataProfile(41, 'ผู้ติดตาม'),
                            dataProfile(31, 'โดนปาใส่'),
                          ],
                        ),
                      ),
                      Container(
                        height: screenHeightDp / 100,
                      ),
                      SizedBox(
                        height: appBarHeight / 10,
                      ),
                      Container(
                        width: appBarHeight * 4.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: appBarHeight * 1.55,
                              child: GestureDetector(
                                onTap: () {},
                                //color: Colors.grey,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                      appBarHeight / 3,
                                      appBarHeight / 50,
                                      appBarHeight / 3,
                                      appBarHeight / 50),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xfff26A4FF)),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    'ติดตาม',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xfff26A4FF),
                                      fontSize: s52,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: appBarHeight / 6,
                            ),
                            Container(
                              child: GestureDetector(
                                onTap: () {},
                                //color: Colors.grey,
                                child: Container(
                                  width: appBarHeight * 1.55,
                                  padding: EdgeInsets.fromLTRB(
                                      appBarHeight / 5,
                                      appBarHeight / 50,
                                      appBarHeight / 5,
                                      appBarHeight / 50),
                                  decoration: BoxDecoration(
                                    // border: Border.all(
                                    //   color: Colors.blue
                                    // ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    'ปาสแครป',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xfff26A4FF),
                                      fontSize: s52,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: screenHeightDp / 40,
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: screenWidthDp / 30,
                        ),
                        child: Text(
                          '“ยุบพรรคอนาคตใหม่แต่ยุบคนไทย\nไม่ได้หรอก\tไอตู่หน้าโง่”',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: s40,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        height: screenHeightDp / 40,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: Column(
                          children: [
                            Divider(
                              color: Colors.white,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (controller.page != 0)
                                      controller.previousPage(
                                          duration: Duration(milliseconds: 120),
                                          curve: Curves.ease);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text('เก็บจากที่ทิ้งไว้',
                                        style:
                                            // page != 0
                                            // ?
                                            // TextStyle(
                                            //   color: Colors.white,
                                            //   fontSize: s52,
                                            //   )
                                            // :
                                            TextStyle(
                                          //decoration: TextDecoration.underline,
                                          color: Colors.white,
                                          fontSize: s52,
                                        )),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (controller.page != 1)
                                      controller.nextPage(
                                          duration: Duration(milliseconds: 120),
                                          curve: Curves.ease);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text('เก็บจากโดนปาใส่',
                                        style:
                                            // page != 1
                                            // ?
                                            // TextStyle(
                                            //   color: Colors.white,
                                            //   fontSize: s52,
                                            //   )
                                            // :
                                            TextStyle(
                                          //decoration: TextDecoration.underline,
                                          color: Colors.white,
                                          fontSize: s52,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            Stack(
                              children: [
                                Divider(
                                  color: Colors.white,
                                ),
                                Divider(
                                  color: Colors.white,
                                  thickness: 2,
                                  indent: page != 1 ? (9) : (127),
                                  endIndent: page != 1
                                      ? (screenWidthDp - 107)
                                      : (screenWidthDp - 240),
                                  // indent: 9,
                                  // endIndent: screenWidthDp-82,
                                ),
                                // Divider(
                                //   color: Colors.white,
                                //   thickness: 2,
                                //   indent: 76,
                                //   endIndent: screenWidthDp-168,
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: screenHeightDp * 1.3,
                        width: screenWidthDp,
                        child: PageView(
                          onPageChanged: (index) {
                            setState(() => page = index);
                          },
                          controller: controller,
                          children: [
                            /* wrap(),
                            wrap2(),*/
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: appBarHeight,
                  ),
                ],
              ),
            ),
            Positioned(
                top: 0,
                child: Container(
                  child: appbar_OtherProfile(context),
                )),
            Positioned(
                bottom: 0,
                child: Container(
                  child: Ads(),
                )),
          ],
        ),
      ),
    );
  }
}

// void bottomSheet ใช้กับ icon_horiz
void showButtonSheet(context) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: appBarHeight * 3.4,
          decoration: BoxDecoration(
            color: Color(0xff202020),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Stack(
            children: <Widget>[
              // Divider(
              //   thickness: 10,
              //   color: Colors.grey,
              //   indent: 140,
              //   endIndent: 140,
              // ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 12, bottom: 4),
                    width: screenWidthDp / 3.2,
                    height: screenHeightDp / 81,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenHeightDp / 42),
                      color: Color(0xff929292),
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(
                  bottom: appBarHeight - 20,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(screenHeightDp)),
                            child: IconButton(
                                icon: Icon(
                                  Icons.block,
                                  size: appBarHeight / 3,
                                ),
                                onPressed: null),
                          ),
                          Text(
                            'บล็อคผู้ใช้',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: s42,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(screenHeightDp)),
                            child: IconButton(
                                icon: Icon(
                                  Icons.report_problem,
                                  size: appBarHeight / 3,
                                ),
                                onPressed: null),
                          ),
                          Text(
                            'รายงาน',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: s42,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    child: Ads(),
                  )),
            ],
          ),
        );
      });
}
