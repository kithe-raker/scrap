import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scrap/widget/ScreenUtil.dart';

import 'dart:math' as math;

import 'package:scrap/widget/dialog/ScrapFeedDialog.dart';

class GridFollowing extends StatefulWidget {
  final List<DocumentSnapshot> scraps;
  final Map<String, int> comment;
  GridFollowing({@required this.scraps, @required this.comment});
  @override
  _GridFollowingState createState() => _GridFollowingState();
}

class _GridFollowingState extends State<GridFollowing> {
  var textGroup = AutoSizeGroup();

  bool isExpired(DocumentSnapshot data) {
    DateTime startTime = data['scrap']['timeStamp'].toDate();
    return DateTime(startTime.year, startTime.month, startTime.day + 1,
            startTime.hour, startTime.second)
        .difference(DateTime.now())
        .isNegative;
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
        child: widget.scraps.length > 0
            ? Container(
                margin:
                    EdgeInsets.only(left: a.width / 42, right: a.width / 42),
                width: a.width,
                child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: screenWidthDp / 42,
                        crossAxisSpacing: screenWidthDp / 42,
                        childAspectRatio: 0.8968,
                        crossAxisCount: 2),
                    children:
                        widget.scraps.map((scrap) => block(scrap)).toList()),
              )
            : Center(child: guide('ไม่มีการเคลื่อนไหวจากคนที่คุณติดตาม')));
  }

  Widget block(DocumentSnapshot data) {
    Size a = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
        height: screenWidthDp / 2.16 * 1.21,
        width: screenWidthDp / 2.16,
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage('assets/paperscrap.jpg'), fit: BoxFit.cover)),
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
            isExpired(data)
                ? Container(
                    height: screenWidthDp / 2.16 * 1.21,
                    width: screenWidthDp / 2.16,
                    color: Colors.black38,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.restore, size: 50, color: Colors.white),
                          Text('หมดเวลาแล้ว',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: s48,
                                  fontWeight: FontWeight.bold)),
                        ]))
                : widget.comment[data.documentID] == null
                    ? Container(
                        height: screenWidthDp / 2.16 * 1.21,
                        width: screenWidthDp / 2.16,
                        color: Colors.black38,
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8.1, sigmaY: 8.1),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.whatshot,
                                      size: 50, color: Color(0xffFF8F3A)),
                                  Text('ถูกเผาแล้ว',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: s48,
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ),
                        ))
                    : SizedBox(),
            widget.comment[data.documentID] != null && !isExpired(data)
                ? Positioned(
                    bottom: 0,
                    right: 0,
                    child: commentTransactionBox(
                        a, widget.comment[data.documentID]))
                : SizedBox(),
          ],
        ),
      ),
      onTap: widget.comment[data.documentID] == null
          ? null
          : () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => ScrapFeedDialog(
                      scraps: widget.scraps,
                      currentIndex: widget.scraps.indexOf(data)));
            },
    );
  }

  Widget commentTransactionBox(Size a, int comments) {
    return Container(
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
              Text('${comments.abs()}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: a.width / 20)),
              Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Icon(Icons.sms, color: Colors.white))
            ]));
  }

  Widget guide(String text) {
    return Container(
      height: screenHeightDp / 2.5,
      width: screenWidthDp,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          /* Image.asset('assets/paper.png',
              color: Colors.white60, height: screenHeightDp / 10),*/
          SvgPicture.asset('assets/paper.svg',
              color: Colors.white60,
              height: screenWidthDp / 3.5,
              fit: BoxFit.contain),
          Text(
            text,
            style: TextStyle(
                fontSize: screenWidthDp / 16,
                color: Colors.white60,
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
