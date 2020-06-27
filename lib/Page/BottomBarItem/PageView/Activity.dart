import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrap/assets/PaperTexture.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/widget/CountDownText.dart';
import 'package:scrap/widget/LoadNoBlur.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/beforeburn.dart';
import 'package:scrap/widget/dialog/ScrapDialog.dart';
import 'package:scrap/widget/dialog/ScrapFeedDialog.dart';
import 'package:scrap/widget/sheets/CommentSheet.dart';
import 'package:scrap/widget/sheets/MapSheet.dart';
import 'package:scrap/widget/showdialogreport.dart';

class Activity extends StatefulWidget {
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity>
    with AutomaticKeepAliveClientMixin {
  List cacheComments = [];
  var refreshController = RefreshController();
  Map<String, List> history = {};
  bool loading = true;
  var textGroup = AutoSizeGroup();

  @override
  void initState() {
    initScrap();
    super.initState();
  }

  initScrap() async {
    cacheComments = await cacheHistory.readHistory(field: 'picked') ?? [];
    history['like'] = await cacheHistory.readOnlyId(field: 'like') ?? [];
    history['picked'] = await cacheHistory.readOnlyId(field: 'picked') ?? [];
    history['burn'] = await cacheHistory.readOnlyId(field: 'burn') ?? [];
    setState(() => loading = false);
  }

  Timestamp yesterDay() {
    var now = DateTime.now();
    return Timestamp.fromDate(
        DateTime(now.year, now.month, now.day - 1, now.hour, now.minute));
  }

  bool isExpired(DocumentSnapshot data) {
    DateTime startTime = data['scrap']['timeStamp'].toDate();
    return DateTime(startTime.year, startTime.month, startTime.day + 1,
            startTime.hour, startTime.second)
        .difference(DateTime.now())
        .isNegative;
  }

  Future<DataSnapshot> scrapTransaction(String docId) {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    var ref = scrapAll.reference().child('scraps').child(docId);
    return ref.once();
  }

  bool inHistory(String field, String id) {
    return history[field].contains(id);
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = Provider.of<UserData>(context, listen: false);
    screenutilInit(context);
    return Scaffold(
        backgroundColor: Colors.black,
        body: loading
            ? Center(child: LoadNoBlur())
            : Container(
                width: screenWidthDp,
                height: screenHeightDp,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: screenHeightDp / 42),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidthDp / 48),
                        child: Text(
                          'สแครปโยนล่าสุดของคุณ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: s46,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: screenHeightDp / 72),
                      Container(
                        height: screenWidthDp / 2.16 * 1.21,
                        child: StreamBuilder(
                            stream: fireStore
                                .collection(
                                    'Users/${user.region}/users/${user.uid}/history')
                                .orderBy('scrap.timeStamp', descending: true)
                                .where('scrap.timeStamp',
                                    isGreaterThan: yesterDay())
                                .limit(10)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<DocumentSnapshot> writtenScrap =
                                    snapshot.data.documents;
                                return writtenScrap.length > 0
                                    ? ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: writtenScrap
                                            .map((dat) => Container(
                                                  margin: EdgeInsets.only(
                                                      left: screenWidthDp / 48),
                                                  child: scrapWidget(dat,
                                                      showComment: false),
                                                ))
                                            .toList())
                                    : Center(
                                        child: Text(
                                          'ยังไม่มีสแครปที่คุณโยนในวันนี้',
                                          style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.51),
                                              fontWeight: FontWeight.bold,
                                              fontSize: s52),
                                        ),
                                      );
                              } else
                                return Center(child: LoadNoBlur());
                            }),
                      ),
                      SizedBox(height: screenHeightDp / 48),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidthDp / 48),
                        child: Text(
                          'สแครปเก็บล่าสุดของคุณ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: s46,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: screenHeightDp / 72),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidthDp / 48),
                        child: StreamBuilder(
                            stream: fireStore
                                .collection(
                                    'Users/${user.region}/users/${user.uid}/scrapCollection')
                                .orderBy('scrap.timeStamp', descending: true)
                                .where('scrap.timeStamp',
                                    isGreaterThan: yesterDay())
                                .limit(10)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<DocumentSnapshot> scraps =
                                    snapshot.data.documents;
                                return scraps.length > 0
                                    ? Wrap(
                                        spacing: screenWidthDp / 42,
                                        runSpacing: screenWidthDp / 42,
                                        alignment: WrapAlignment.center,
                                        children: scraps
                                            .map((scrap) => scrapWidget(scrap,
                                                docs: scraps))
                                            .toList())
                                    : Container(
                                        margin: EdgeInsets.only(
                                            top: screenWidthDp / 5.1),
                                        child: Center(
                                          child: Text(
                                            'ยังไม่มีสแครปที่คุณเก็บในวันนี้',
                                            style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.51),
                                                fontWeight: FontWeight.bold,
                                                fontSize: s52),
                                          ),
                                        ),
                                      );
                              } else
                                return Center(child: LoadNoBlur());
                            }),
                      ),
                      SizedBox(height: screenHeightDp / 42)
                    ],
                  ),
                ),
              ));
  }

  Widget text(String textt) {
    Size a = MediaQuery.of(context).size;
    return Text(textt,
        style: TextStyle(
            color: Color(0xfffFFFFFF).withOpacity(0.51),
            fontWeight: FontWeight.bold,
            fontSize: a.width / 15));
  }

  Widget scrapWidget(DocumentSnapshot data,
      {List docs, bool showComment = true}) {
    var fontRatio = s48 / screenWidthDp / 1.04;
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    int ments, comments;
    if (showComment && cacheComments.length > 0) {
      var result =
          cacheComments.where((cache) => cache['id'] == data['id']).toList();
      result.length > 0 ? comments = result.first['comments'] : comments = 0;
    }
    return GestureDetector(
      child: FutureBuilder(
          future:
              scrapAll.reference().child('scraps/${data['id']}/comment').once(),
          builder: (context, snapshot) {
            ments = snapshot.data?.value ?? null;
            return Container(
              height: screenWidthDp / 2.16 * 1.21,
              width: screenWidthDp / 2.16,
              child: Stack(
                children: <Widget>[
                  Container(
                    child: SvgPicture.asset(
                        'assets/${texture.textures[data['scrap']['texture']]}',
                        fit: BoxFit.cover),
                  ),
                  Center(
                      child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidthDp / 64),
                    child: AutoSizeText(data['text'] ?? data['scrap']['text'],
                        textAlign: TextAlign.center,
                        group: textGroup,
                        style: TextStyle(
                            fontSize: screenWidthDp / 2.16 * fontRatio)),
                  )),
                  showComment
                      ? snapshot.hasData && snapshot.data?.value == null
                          ? Container(
                              height: screenWidthDp / 2.16 * 1.21,
                              width: screenWidthDp / 2.16,
                              color: Colors.black38,
                              child: ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 8.1, sigmaY: 8.1),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                          : SizedBox()
                      : data['burnt'] ?? false
                          ? Container(
                              height: screenWidthDp / 2.16 * 1.21,
                              width: screenWidthDp / 2.16,
                              color: Colors.black38,
                              child: ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 8.1, sigmaY: 8.1),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                  showComment
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: snapshot.hasData
                              ? ments != null
                                  ? commentTransactionBox(
                                      ments.abs(), comments?.abs() ?? 0)
                                  : SizedBox()
                              : commentTransactionBox(
                                  comments?.abs() ?? 0, comments?.abs() ?? 0))
                      : SizedBox()
                ],
              ),
            );
          }),
      onTap: () {
        if (ments != null && showComment) {
          if (ments.abs() != comments?.abs() ?? 0) {
            cacheHistory.updateFollowingScrap(
                data['id'], ments, data['scrap']['timeStamp'].toDate());
            if (cacheComments.length > 0) {
              var result = cacheComments
                  .where((cache) => cache['id'] == data['id'])
                  .toList();
              if (result.length > 0) {
                cacheComments.firstWhere(
                    (scrap) => scrap['id'] == data['id'])['comments'] = ments;
              } else
                cacheComments.add({'id': data['id'], 'comments': ments});
            } else
              cacheComments.add({'id': data['id'], 'comments': ments});
          }
          setState(() {});

          // dialog(cacheComments.indexOf(data));
          showDialog(
              context: context,
              builder: (BuildContext context) => ScrapFeedDialog(
                  scraps: docs, currentIndex: docs.indexOf(data)));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) => ScrapDialog(data: data));
        }
      },
    );
  }

  Widget commentTransactionBox(int comments, int cacheComment) {
    return Container(
        margin: EdgeInsets.all(screenWidthDp / 45),
        alignment: Alignment.center,
        width: screenWidthDp / 6,
        height: screenWidthDp / 13,
        decoration: BoxDecoration(
            color: comments == cacheComment
                ? Color(0xff707070)
                : Color(0xff0077CC),
            borderRadius: BorderRadius.circular(screenWidthDp / 80)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('$comments',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: screenWidthDp / 20)),
              Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: Icon(Icons.sms, color: Colors.white))
            ]));
  }
}
