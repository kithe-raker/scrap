import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:social_share/social_share.dart';
import 'package:screenshot/screenshot.dart';

class TestT extends StatefulWidget {
  @override
  _TestTState createState() => _TestTState();
}

class _TestTState extends State<TestT> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  ScreenshotController screenshotController = ScreenshotController();
  void showShare(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          screenutilInit(context);
          return Container(
            height: appBarHeight * 3.3,
            decoration: BoxDecoration(
              color: Color(0xff202020),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 12, bottom: 4),
                      width: screenWidthDp / 3.2,
                      height: screenHeightDp / 81,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(screenHeightDp / 42),
                        color: Color(0xff929292),
                      ),
                    )),
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: screenWidthDp / 10),
                      child: Row(
                        // scrollDirection: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // story ig
                          GestureDetector(
                              onTap: () async {
                                await screenshotController
                                    .capture()
                                    .then((image) async {
                                  SocialShare.shareInstagramStory(
                                      image.path,
                                      "#ffffff",
                                      "#000000",
                                      "https://scrap.bualoitech.com/");
                                });
                              },
                              child: Container(
                                height: screenWidthDp / 5,
                                width: screenWidthDp / 5,
                                child: SvgPicture.asset('assets/paper.svg',
                                    color: Colors.pink),
                              )),
                          // facebook story
                          GestureDetector(
                              onTap: () async {
                                await screenshotController
                                    .capture()
                                    .then((image) async {
                                  //facebook appId is mandatory for andorid or else share won't work
                                  Platform.isAndroid
                                      ? SocialShare.shareFacebookStory(
                                              image.path,
                                              "#ffffff",
                                              "#000000",
                                              "https://scrap.bualoitech.com/",
                                              appId: "152617042778122")
                                          .then((data) {
                                          print(data);
                                        })
                                      : SocialShare.shareFacebookStory(
                                              image.path,
                                              "#ffffff",
                                              "#000000",
                                              "https://scrap.bualoitech.com/")
                                          .then((data) {
                                          print(data);
                                        });
                                });
                              },
                              child: Container(
                                height: screenWidthDp / 5,
                                width: screenWidthDp / 5,
                                child: SvgPicture.asset(
                                  'assets/paper.svg',
                                  color: Colors.blue[900],
                                ),
                              )),
                          //Twitter
                        ],
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: screenWidthDp / 12,
                                ),
                                GestureDetector(
                                  child: Container(
                                      height: 50,
                                      width: 50,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              screenHeightDp)),
                                      child: Icon(Icons.whatshot,
                                          color: Color(0xffFF8F3A),
                                          size: appBarHeight / 3)),
                                  onTap: () {},
                                ),
                                Text(
                                  'เผา',
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
                                SizedBox(
                                  height: screenWidthDp / 12,
                                ),
                                GestureDetector(
                                  child: Container(
                                      height: 50,
                                      width: 50,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              screenHeightDp)),
                                      child: Icon(Icons.report_problem,
                                          size: appBarHeight / 3)),
                                  onTap: () {},
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
                    SizedBox(
                      height: screenWidthDp / 10,
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Center(
              child: RaisedButton(
            onPressed: () async {
              Map map = {};
              var place = await fireStore.collection('Places').getDocuments();
              place.documents.forEach(
                  (element) => map[element.documentID] = element['name']);
              var docs =
                  await fireStore.collectionGroup('history').getDocuments();
              await Future.forEach(docs.documents, (element) async {
                print(element.documentID);
                if (element['placeName'] == null && element['places'] != null) {
                  await element.reference
                      .updateData({'placeName': map[element['places'][0]]});
                  print('update');
                }
              });
              print('fin');
              // authService.signOut(context);
            },
            child: Text('data'),
          ))),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage>
    with AutomaticKeepAliveClientMixin {
  int count = 0;

  void add() {
    setState(() {
      count++;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print('second initState');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: Center(
            child: Text('Second: $count', style: TextStyle(fontSize: 30))),
        floatingActionButton: FloatingActionButton(
          onPressed: add,
          child: Icon(Icons.add),
        ));
  }
}
