import 'package:admob_flutter/admob_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrap/services/admob_service.dart';
import 'dart:math' as math;

import 'package:scrap/widget/ScreenUtil.dart';

class GridTopScrap extends StatefulWidget {
  final List scraps;
  final Map<String, int> comments;
  GridTopScrap({@required this.scraps, @required this.comments});
  @override
  _GridTopScrapState createState() => _GridTopScrapState();
}

class _GridTopScrapState extends State<GridTopScrap> {
  var controller = RefreshController();
  var textGroup = AutoSizeGroup();

  @override
  void initState() {
    Admob.initialize(AdmobService().getAdmobAppId());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    screenutilInit(context);
    return Container(
        child: Container(
      margin: EdgeInsets.only(left: a.width / 42, right: a.width / 42),
      width: a.width,
      child: Wrap(
          spacing: a.width / 42,
          runSpacing: a.width / 42,
          alignment: WrapAlignment.center,
          children: widget.scraps.map((scrap) => block(data: scrap)).toList()),
    ));
  }

  Widget block({dynamic data}) {
    return data.runtimeType == int ? admob() : scrapWidget(data);
  }

  Widget scrapWidget(data) {
    Size a = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
        height: screenWidthDp / 2.16 * 1.21,
        width: screenWidthDp / 2.16,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/paper-readed.png'),
                fit: BoxFit.cover)),
        child: Stack(
          children: <Widget>[
            Center(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 64),
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
                      color: Color(0xff2D2D2F),
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
      onTap: () {},
    );
  }

  Widget admob() {
    Size a = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: a.width / 80),
      width: a.width,
      color: Colors.grey,
      child: AdmobBanner(
          adUnitId: AdmobService().getBannerAdId(),
          adSize: AdmobBannerSize.LARGE_BANNER),
    );
  }
}
