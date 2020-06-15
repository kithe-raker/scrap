import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:math' as math;

import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/ads.dart';
import 'package:scrap/widget/dialog/ScrapFeedDialog.dart';

class GridTopScrap extends StatefulWidget {
  final List scraps;
  final List feedScrap;
  final Map<String, int> comments;
  GridTopScrap(
      {@required this.scraps,
      @required this.comments,
      @required this.feedScrap});
  @override
  _GridTopScrapState createState() => _GridTopScrapState();
}

class _GridTopScrapState extends State<GridTopScrap> {
  var controller = RefreshController();
  var textGroup = AutoSizeGroup();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    screenutilInit(context);
    return Container(
      margin: EdgeInsets.only(
          left: a.width / 42, right: a.width / 42, bottom: screenWidthDp / 27),
      width: a.width,
      child: Wrap(
          spacing: a.width / 42,
          runSpacing: a.width / 42,
          alignment: WrapAlignment.start,
          children: widget.scraps.map((scrap) => block(data: scrap)).toList()),
    );
  }

  Widget block({dynamic data}) {
    return data.runtimeType != DocumentSnapshot
        ? AdBanner()
        : scrapWidget(data);
  }

  Widget scrapWidget(data) {
    Size a = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
        height: screenWidthDp / 2.16 * 1.21,
        width: screenWidthDp / 2.16,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/paperscrap.jpg'), fit: BoxFit.cover)),
        child: Stack(
          children: <Widget>[
            Center(
                child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidthDp / 64, vertical: screenWidthDp / 16),
              child: AutoSizeText(data['scrap']['text'],
                  textAlign: TextAlign.center,
                  group: textGroup,
                  style: TextStyle(fontSize: s46)),
            )),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                  margin: EdgeInsets.all(a.width / 45),
                  alignment: Alignment.center,
                  width: a.width / 6,
                  height: a.width / 13,
                  decoration: BoxDecoration(
                      color: Color(0xff707070),
                      borderRadius: BorderRadius.circular(a.width / 80)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(widget.comments[data['id']].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: a.width / 20)),
                        Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi),
                            child: Icon(Icons.sms, color: Colors.white))
                      ])),
            ),
          ],
        ),
      ),
      onTap: () {
        List scraps = [];
        scraps.addAll(widget.scraps);
        scraps
            .removeWhere((element) => element.runtimeType != DocumentSnapshot);
        showDialog(
            context: context,
            builder: (BuildContext context) => ScrapFeedDialog(
                scraps: widget.feedScrap,
                currentIndex: scraps.indexOf(data),
                topScrap: true));
      },
    );
  }
}
