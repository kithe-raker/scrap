import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/guide.dart';

import '../footer.dart';

class CommentSheet extends StatefulWidget {
  final DocumentSnapshot scrapSnapshot;
  CommentSheet({@required this.scrapSnapshot});
  @override
  _CommentSheetState createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  List commentList = [];
  DocumentSnapshot scrapSnapshot;
  var controller = RefreshController();
  TextEditingController comment = TextEditingController();
  CollectionReference ref;
  bool loading = true;

  @override
  void initState() {
    initComments();
    super.initState();
  }

  initComments() async {
    ref = Firestore.instance.collection(
        'Users/${widget.scrapSnapshot['region']}/users/${widget.scrapSnapshot['uid']}/history/${widget.scrapSnapshot.documentID}/comments');
    scrapSnapshot = widget.scrapSnapshot;
    var docs = await ref
        .orderBy('timeStamp', descending: true)
        .limit(8)
        .getDocuments();
    commentList.addAll(docs.documents);
    setState(() => loading = false);
  }

  @override
  void dispose() {
    controller.dispose();
    comment.dispose();
    super.dispose();
  }

  bool isExpired(List commentList, CollectionReference ref, String scrapId,
      {@required String comment}) {
    DateTime startTime = scrapSnapshot['scrap']['timeStamp'].toDate();
    if (DateTime(startTime.year, startTime.month, startTime.day + 1,
            startTime.hour, startTime.second)
        .difference(DateTime.now())
        .isNegative) {
      return true;
    } else {
      addComment(commentList, ref, scrapId, comment: comment);
      return false;
    }
  }

  addComment(List commentList, CollectionReference ref, String scrapId,
      {@required String comment}) async {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    final user = Provider.of<UserData>(context, listen: false);
    final scrapAll = FirebaseDatabase(app: db.scrapAll);
    final userDb = FirebaseDatabase(app: db.userTransact);
    final defaultDb = FirebaseDatabase.instance;
    var refChild = 'scraps/$scrapId';

    commentList.insert(0, {
      'name': user.id,
      'image': user.imgUrl,
      'comment': comment,
      'timeStamp': DateTime.now()
    });
    ref.add({
      'name': user.id,
      'image': user.imgUrl,
      'comment': comment,
      'timeStamp': FieldValue.serverTimestamp()
    });

    var mutableData = await defaultDb.reference().child(refChild).once();
    var newPoint = mutableData.value['point'] - 0.3;
    defaultDb.reference().child(refChild).update(
        {'comment': mutableData.value['comment'] - 1, 'point': newPoint});

    scrap.pushNotification(widget.scrapSnapshot,
        notiRate: mutableData.value['CPN'],
        currentPoint: mutableData.value['comment'] - 1,
        isComment: true);

    scrapAll.reference().child(refChild).update(
        {'comment': mutableData.value['comment'] - 1, 'point': newPoint});

    userDb.reference().child('users/${scrapSnapshot['uid']}/att').once().then(
        (data) => userDb
            .reference()
            .child('users/${scrapSnapshot['uid']}')
            .update({'att': data.value + 0.3}));
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
            width: screenWidthDp,
            height: screenHeightDp / 1.18,
            child: Container(
              margin: EdgeInsets.only(top: screenWidthDp / 8.1),
              decoration: BoxDecoration(
                  color: Color(0xff282828),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24))),
              child: Column(
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
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidthDp / 56),
                        child: loading
                            ? Center(child: CircularProgressIndicator())
                            : StatefulBuilder(
                                builder: (context, StateSetter setComment) {
                                return SmartRefresher(
                                    footer: Footer(),
                                    enablePullUp: true,
                                    enablePullDown: true,
                                    controller: controller,
                                    onRefresh: () {
                                      setComment(() {});
                                      controller.refreshCompleted();
                                    },
                                    onLoading: () async {
                                      var docs = await ref
                                          .orderBy('timeStamp',
                                              descending: true)
                                          .startAfterDocument(commentList.last)
                                          .limit(8)
                                          .getDocuments();
                                      if (docs.documents.length > 0) {
                                        commentList.addAll(docs.documents);
                                        setComment(() {});
                                        controller.loadComplete();
                                      } else {
                                        controller.loadNoData();
                                      }
                                    },
                                    child: commentList.length > 0
                                        ? ListView(
                                            children: commentList
                                                .map((doc) => commentBox(doc))
                                                .toList())
                                        : Center(
                                            child: guide(
                                                Size(screenWidthDp,
                                                    screenHeightDp),
                                                'ไม่มีการแสดงความเห็น'),
                                          ));
                              })),
                  ),
                  StatefulBuilder(builder: (context, StateSetter setSheet) {
                    return Container(
                        width: screenWidthDp,
                        height: screenHeightDp / 12,
                        decoration: BoxDecoration(
                            color: Color(0xff282828),
                            border: Border(
                                top: BorderSide(
                                    color: Color(0xff414141), width: 1.2))),
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: screenWidthDp / 32),
                            Expanded(
                                child: Container(
                              height: screenHeightDp / 17.4,
                              padding: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  color: Color(0xff313131),
                                  borderRadius: BorderRadius.circular(8)),
                              child: TextField(
                                  controller: comment,
                                  onChanged: (val) {
                                    //  var text = val.trimLeft();

                                    /* comment.text = val;
                                    comment.selection =
                                        TextSelection.fromPosition(
                                            TextPosition(offset: val.length));*/
                                    setSheet(() {});
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'พิมพ์อะไรสักอย่างสิ',
                                      hintStyle: TextStyle(
                                          color: Colors.white38,
                                          fontSize: s48,
                                          height: 0.72)),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: s48,
                                      height: 0.72),
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: comment.text != null &&
                                          comment.text.length > 0
                                      ? (val) {
                                          if (isExpired(commentList, ref,
                                              scrapSnapshot.documentID,
                                              comment: comment.text.trim())) {
                                            scrap.toast('แสครปนี้ย่อยสลายแล้ว');
                                          } else {
                                            comment.clear();
                                            setSheet(() {});
                                            controller.requestRefresh();
                                          }
                                        }
                                      : null),
                            )),
                            SizedBox(width: screenWidthDp / 32),
                            GestureDetector(
                                child: Icon(
                                  Icons.send,
                                  color: comment.text != null &&
                                          comment.text.length > 0
                                      ? Color(0xff26A4FF)
                                      : Color(0xff6C6C6C),
                                  size: s60,
                                ),
                                onTap: comment.text != null &&
                                        comment.text.length > 0
                                    ? () {
                                        if (isExpired(commentList, ref,
                                            scrapSnapshot.documentID,
                                            comment: comment.text.trim())) {
                                          scrap.toast('แสครปนี้ย่อยสลายแล้ว');
                                        } else {
                                          comment.clear();
                                          setSheet(() {});
                                          controller.requestRefresh();
                                        }
                                      }
                                    : null),
                            SizedBox(width: screenWidthDp / 32),
                          ],
                        ));
                  })
                ],
              ),
            )),
      ),
    );
  }

  Widget commentBox(dynamic comment) {
    return Container(
        child: ListTile(
      leading: ClipRRect(
          borderRadius: BorderRadius.circular(screenWidthDp),
          child: CachedNetworkImage(
            imageUrl: comment['image'],
            fit: BoxFit.cover,
            width: screenWidthDp / 8.1,
            height: screenWidthDp / 8.1,
          )),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Text(
            '${comment['name']}',
            style: TextStyle(
                color: Colors.white,
                fontSize: s42,
                fontWeight: FontWeight.bold),
          ),
          Text(
            ' ${readTimestamp(comment['timeStamp'])}',
            style:
                TextStyle(color: Colors.white, fontSize: s42, wordSpacing: 0.5),
          )
        ],
      ),
      subtitle: Text(
        comment['comment'],
        style: TextStyle(color: Colors.white, fontSize: s42, height: 0.9),
      ),
    ));
  }

  String readTimestamp(dynamic timestamp) {
    var now = DateTime.now();
    var format = DateFormat('dd/MM/yyyy');
    var date =
        timestamp.runtimeType == Timestamp ? timestamp.toDate() : timestamp;
    var diff = now.difference(date);
    var time = '';
    if (diff.inDays < 1) {
      if (diff.inSeconds <= 30) {
        time = 'ไม่กี่วินาทีที่ผ่านมานี้';
      } else if (diff.inSeconds <= 60) {
        time = diff.inSeconds.toString() + ' วินาทีที่แล้ว';
      } else if (diff.inMinutes < 5) {
        time = 'เมื่อไม่นานมานี้';
      } else if (diff.inMinutes < 60) {
        time = diff.inMinutes.toString() + ' นาทีที่แล้ว';
      } else {
        time = diff.inHours.toString() + ' ชั่วโมงที่แล้ว';
      }
    } else if (diff.inDays < 7) {
      diff.inDays == 1
          ? time = 'เมื่อวานนี้'
          : time = diff.inDays.toString() + ' วันที่แล้ว';
    } else {
      diff.inDays == 7 ? time = 'สัปดาที่แล้ว' : time = format.format(date);
    }
    return time;
  }
}
