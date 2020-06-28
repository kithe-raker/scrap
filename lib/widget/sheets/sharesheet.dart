import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:social_share/social_share.dart';
import 'package:screenshot/screenshot.dart';

class ShareSheet extends StatefulWidget {
  @override
  _ShareSheetState createState() => _ShareSheetState();
}

class _ShareSheetState extends State<ShareSheet> {
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

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
      body: Center(
        child: Container(
          height: screenWidthDp / 2.4,
          width: screenWidthDp,
          decoration: BoxDecoration(
              color: Color(0xff282828),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24))),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // story ig
                  GestureDetector(
                      onTap: () async {
                        await screenshotController
                            .capture()
                            .then((image) async {
                          //facebook appId is mandatory for andorid or else share won't work
                          Platform.isAndroid
                              ? SocialShare.shareInstagramStory(image.path,
                                  "#ffffff", "#000000", "https://deep-link-url")
                              : SocialShare.shareInstagramStory(
                                  image.path,
                                  "#ffffff",
                                  "#000000",
                                  "https://deep-link-url");
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
                                      "https://google.com",
                                      appId: "152617042778122")
                                  .then((data) {
                                  print(data);
                                })
                              : SocialShare.shareFacebookStory(
                                      image.path,
                                      "#ffffff",
                                      "#000000",
                                      "https://google.com")
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
