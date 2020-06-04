import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/widget/ScreenUtil.dart';

import 'dart:math' as math;

import 'package:scrap/widget/dialog/ScrapFeedDialog.dart';

class GridFollowing extends StatefulWidget {
  final List<DocumentSnapshot> scraps;
  GridFollowing({@required this.scraps});
  @override
  _GridFollowingState createState() => _GridFollowingState();
}

class _GridFollowingState extends State<GridFollowing> {
  var textGroup = AutoSizeGroup();

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
                    children:
                        widget.scraps.map((scrap) => block(scrap)).toList()),
              )
            : Center(child: guide('ไม่มีการเคลื่อนไหวจากคนที่คุณติดตาม')));
  }

  Widget block(DocumentSnapshot data) {
    Size a = MediaQuery.of(context).size;
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    return FutureBuilder(
        future: scrapAll
            .reference()
            .child('scraps/${data.documentID}/comment')
            .once(),
        builder: (context, snapshot) {
          return GestureDetector(
            child: Container(
              height: screenWidthDp / 2.16 * 1.21,
              width: screenWidthDp / 2.16,
              decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image: AssetImage('assets/paperscrap.jpg'),
                      fit: BoxFit.cover)),
              child: Stack(
                children: <Widget>[
                  Center(
                      child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidthDp / 64),
                    child: AutoSizeText(data['scrap']['text'],
                        textAlign: TextAlign.center,
                        group: textGroup,
                        style: TextStyle(fontSize: s46)),
                  )),
                  snapshot.hasData && snapshot.data?.value == null
                      ? Container(
                          margin: EdgeInsets.all(4),
                          height: screenWidthDp / 2.16 * 1.21,
                          width: screenWidthDp / 2.16,
                          color: Colors.black38,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.whatshot,
                                    size: 50, color: Color(0xffFF8F3A)),
                                Text('ถูกเผาแล้ว',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: s48)),
                              ]))
                      : SizedBox(),
                  snapshot.data?.value != null
                      ? Positioned(
                          bottom: 0,
                          right: 0,
                          child: commentTransactionBox(a, snapshot.data.value))
                      : SizedBox(),
                ],
              ),
            ),
            onTap: snapshot.data?.value == null
                ? null
                : () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => ScrapFeedDialog(
                            scraps: widget.scraps,
                            currentIndex: widget.scraps.indexOf(data)));
                  },
          );
        });
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
