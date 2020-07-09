import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scrap/assets/PaperTexture.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/stream/UserStream.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/dialog/WatchVideoDialog.dart';

class Backpack extends StatefulWidget {
  @override
  _BackpackState createState() => _BackpackState();
}

class _BackpackState extends State<Backpack>
    with AutomaticKeepAliveClientMixin {
  StreamSubscription attStream;
  double att = 0;

  @override
  void initState() {
    attStream = userStream.attSubject
        .listen((value) => setState(() => att = value ?? 0.0));
    super.initState();
  }

  @override
  void dispose() {
    attStream.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: StreamBuilder(
          initialData: userStream.papers ?? 5,
          stream: userStream.paperSubject,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return floatButton(snapshot.data);
            } else
              return SizedBox();
          }),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: screenHeightDp / 42),
          padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 42),
          child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: screenWidthDp / 42,
                  crossAxisSpacing: screenWidthDp / 42,
                  childAspectRatio: 0.8968,
                  crossAxisCount: 2),
              children: texture.texturesList
                  .map((fileName) => paperBlock(fileName))
                  .toList()),
        ),
      ),
    );
  }

  Widget floatButton(int papers) {
    final user = Provider.of<UserData>(context, listen: false);
    return GestureDetector(
      child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidthDp / 24, vertical: screenWidthDp / 36),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6.0,
                  spreadRadius: 3.0,
                  offset: Offset(0.0, 3.2),
                )
              ],
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(screenWidthDp / 14.2)),
          child: papers > 0
              ? RichText(
                  text: TextSpan(
                  style: TextStyle(
                      fontSize: screenWidthDp / 18,
                      color: Colors.white,
                      fontFamily: 'ThaiSans'),
                  children: <TextSpan>[
                    TextSpan(text: 'เหลือกระดาษ '),
                    TextSpan(
                        text: '$papers',
                        style: TextStyle(
                            fontSize: screenWidthDp / 16,
                            fontWeight: FontWeight.bold)),
                    TextSpan(text: ' แผ่น')
                  ],
                ))
              : Text(
                  'กระดาษของคุณหมดแล้ว',
                  style: TextStyle(
                      fontSize: screenWidthDp / 18,
                      color: Colors.white,
                      fontFamily: 'ThaiSans'),
                )),
      onTap: () {
        papers == 5
            ? toast.toast('กระดาษของคุณยังเต็มอยู่')
            : dialogvideo(context, user.uid);
      },
    );
  }

  Widget paperBlock(String fileName) {
    var requiredAtt = texture.point[fileName];
    return Stack(
      children: <Widget>[
        Container(
          height: screenWidthDp / 2.16 * 1.21,
          width: screenWidthDp / 2.16,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: att < requiredAtt
              ? Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        child: SvgPicture.asset(
                          'assets/$fileName',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                          height: screenWidthDp / 2.16 * 1.21,
                          width: screenWidthDp / 2.16,
                          color: Colors.black.withOpacity(0.6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.lock, color: Colors.black, size: s100),
                              RichText(
                                  text: TextSpan(
                                style: TextStyle(
                                    fontSize: s42,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'ThaiSans'),
                                children: <TextSpan>[
                                  TextSpan(text: 'ต้องการ '),
                                  TextSpan(
                                      text: '$requiredAtt',
                                      style: TextStyle(
                                          color: Colors.lightBlue[300])),
                                  TextSpan(text: ' เอทเทนชั่น'),
                                ],
                              ))
                            ],
                          )),
                    ),
                  ],
                )
              : Container(
                  child: SvgPicture.asset(
                    'assets/$fileName',
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ],
    );
  }
}
