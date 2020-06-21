import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/sheets/sharesheet.dart';
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
        body: Screenshot(
          controller: screenshotController,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Running on: $_platformVersion\n',
                  textAlign: TextAlign.center,
                ),
                GestureDetector(
                  onTap: () async {
                    showShare(context);
                  },
                  child: Text("ShowShare"),
                ),
                RaisedButton(
                  onPressed: () async {
                    await screenshotController.capture().then((image) async {
                      SocialShare.shareInstagramStorywithBackground(image.path,
                              "#ffffff", "#000000", "https://deep-link-url",
                              backgroundImagePath: image.path)
                          .then((data) {
                        print(data);
                      });
                    });
                  },
                  child: Text("Share On Instagram Story with background"),
                ),
                RaisedButton(
                  onPressed: () async {
                    await screenshotController.capture().then((image) async {
                      //facebook appId is mandatory for andorid or else share won't work
                      Platform.isAndroid
                          ? SocialShare.shareFacebookStory(image.path,
                                  "#ffffff", "#000000", "https://google.com",
                                  appId: "xxxxxxxxxxxxx")
                              .then((data) {
                              print(data);
                            })
                          : SocialShare.shareFacebookStory(image.path,
                                  "#ffffff", "#000000", "https://google.com")
                              .then((data) {
                              print(data);
                            });
                    });
                  },
                  child: Text("Share On Facebook Story"),
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.copyToClipboard(
                      "This is Social Share plugin",
                    ).then((data) {
                      print(data);
                    });
                  },
                  child: Text("Copy to clipboard"),
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.shareTwitter(
                            "This is Social Share twitter example",
                            hashtags: ["hello", "world", "foo", "bar"],
                            url: "https://google.com/#/hello",
                            trailingText: "\nhello")
                        .then((data) {
                      print(data);
                    });
                  },
                  child: Text("Share on twitter"),
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.shareSms("This is Social Share Sms example",
                            url: "\nhttps://google.com/",
                            trailingText: "\nhello")
                        .then((data) {
                      print(data);
                    });
                  },
                  child: Text("Share on Sms"),
                ),
                RaisedButton(
                  onPressed: () async {
                    await screenshotController.capture().then((image) async {
                      SocialShare.shareOptions("Hello world",
                              imagePath: image.path)
                          .then((data) {
                        print(data);
                      });
                    });
                  },
                  child: Text("Share Options"),
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.shareWhatsapp(
                            "Hello World \n https://google.com")
                        .then((data) {
                      print(data);
                    });
                  },
                  child: Text("Share on Whatsapp"),
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.shareTelegram(
                            "Hello World \n https://google.com")
                        .then((data) {
                      print(data);
                    });
                  },
                  child: Text("Share on Telegram"),
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.checkInstalledAppsForShare().then((data) {
                      print(data.toString());
                    });
                  },
                  child: Text("Get all Apps"),
                ),
              ],
            ),
          ),
        ),
      ),
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
