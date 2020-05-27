import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrap/widget/ScreenUtil.dart';

import 'dart:math' as math;

class GridFollowing extends StatefulWidget {
  final List<DocumentSnapshot> scraps;
  GridFollowing({@required this.scraps});
  @override
  _GridFollowingState createState() => _GridFollowingState();
}

class _GridFollowingState extends State<GridFollowing> {
  @override
  void initState() {
    super.initState();
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
                child: Wrap(
                    spacing: a.width / 42,
                    runSpacing: a.width / 42,
                    alignment: WrapAlignment.center,
                    children: widget.scraps
                        .map((scrap) => block(scrap['timeStamp'].toDate()))
                        .toList()),
              )
            : Center(child: guide('ไม่มีการเคลื่อนไหวจากคนที่คุณติดตาม')));
  }

  Widget block(data) {
    Size a = MediaQuery.of(context).size;
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Container(
            width: a.width / 2.2,
            height: (a.width / 2.1) * 1.21,
            color: Colors.white,
            child: Center(
              child: Text(
                DateFormat('d/M/y').format(data),
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
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
                  Text(
                    "1.2K",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: a.width / 20),
                  ),
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: Icon(
                      Icons.sms,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        // controller.refreshCompleted();
      },
    );
  }

  Widget guide(String text) {
    return Container(
      height: screenHeightDp / 2.5,
      width: screenWidthDp,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/paper.png',
              color: Colors.white60, height: screenHeightDp / 10),
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
