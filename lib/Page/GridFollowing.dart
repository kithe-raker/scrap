import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrap/services/jsonConverter.dart';

class GridFollowing extends StatefulWidget {
  @override
  _GridFollowingState createState() => _GridFollowingState();
}

class _GridFollowingState extends State<GridFollowing> {
  bool loading = true;
  List<DocumentSnapshot> scraps = [];
  List friends = [];
  var controller = RefreshController();

  @override
  void initState() {
    initScraps();
    super.initState();
  }

  initScraps() async {
    friends = await jsonConv.readFriendList();
    var docs = await Firestore.instance
        .collection('Scraps/hatyai/test2')
        .where('uid', whereIn: friends)
        .orderBy('timeStamp', descending: true)
        .limit(2)
        .getDocuments();
    scraps.addAll(docs.documents);
    setState(() => loading = false);
  }

  loadMoreScrap() async {
    var docs = await Firestore.instance
        .collection('Scraps/hatyai/test2')
        .where('uid', whereIn: friends)
        .orderBy('timeStamp', descending: true)
        .startAfterDocument(scraps.last)
        .limit(2)
        .getDocuments();
    scraps.addAll(docs.documents);
    setState(() => docs.documents.length < 0
        ? controller.loadComplete()
        : controller.loadNoData());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
      child: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SmartRefresher(
              enablePullUp: true,
              enablePullDown: false,
              controller: controller,
              onLoading: () {
                loadMoreScrap();
              },
              child: Container(
                margin:
                    EdgeInsets.only(left: a.width / 42, right: a.width / 42),
                width: a.width,
                child: Wrap(
                    spacing: a.width / 42,
                    runSpacing: a.width / 42,
                    alignment: WrapAlignment.center,
                    children: scraps
                        .map((scrap) => block(scrap['timeStamp'].toDate()))
                        .toList()),
              ),
            ),
    );
  }

  Widget block(data) {
    Size a = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
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
      onTap: () {
        // controller.refreshCompleted();
      },
    );
  }
}
