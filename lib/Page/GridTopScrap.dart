import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrap/services/admob_service.dart';

class GridTopScrap extends StatefulWidget {
  @override
  _GridTopScrapState createState() => _GridTopScrapState();
}

class _GridTopScrapState extends State<GridTopScrap> {
  bool loading = true;
  List scraps = [];
  int lessPoint;
  var controller = RefreshController();

  @override
  void initState() {
    Admob.initialize(AdmobService().getAdmobAppId());
    initDatabase();
    super.initState();
  }

  // initController(){
  //   controller.footerStatus
  // }

  initDatabase() async {
    List<String> docId = [];
    var ref = FirebaseDatabase.instance
        .reference()
        .child('scraps')
        .orderByChild('point')
        .limitToFirst(2);
    DataSnapshot data = await ref.once();
    data.value.forEach((key, value) {
      docId.add(value['id']);
      if (lessPoint == null)
        lessPoint = value['point'].abs();
      else if (lessPoint > value['point'].abs())
        lessPoint = value['point'].abs();
    });
    var docs = await Firestore.instance
        .collection('Scraps/hatyai/test2')
        .where(FieldPath.documentId, whereIn: docId)
        .getDocuments();
    scraps.addAll(docs.documents);
    scraps.add(lessPoint);
    setState(() => loading = false);
  }

  loadMoreScrap() async {
    List<String> docId = [];
    var ref = FirebaseDatabase.instance
        .reference()
        .child('scraps')
        .orderByChild('point')
        .startAt(-(++lessPoint))
        .limitToFirst(2);
    DataSnapshot data = await ref.once();
    data.value.forEach((key, value) {
      docId.add(value['id']);
      if (lessPoint > value['point'].abs()) lessPoint = value['point'].abs();
    });
    if (docId.length > 1) {
      print(docId);
      var docs = await Firestore.instance
          .collection('Scraps/hatyai/test2')
          .where(FieldPath.documentId, whereIn: docId)
          .getDocuments();
      scraps.addAll(docs.documents);
      scraps.add(lessPoint);
      setState(() => controller.loadComplete());
    } else {
      setState(() => controller.loadNoData());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
        child: SmartRefresher(
      enablePullUp: true,
      enablePullDown: false,
      controller: controller,
      onLoading: () {
        loadMoreScrap();
      },
      child: Container(
        margin: EdgeInsets.only(left: a.width / 42, right: a.width / 42),
        width: a.width,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : Wrap(
                spacing: a.width / 42,
                runSpacing: a.width / 42,
                alignment: WrapAlignment.center,
                children: scraps.map((scrap) => block(data: scrap)).toList()),
      ),
    ));
  }

  Widget block({dynamic data}) {
    return data.runtimeType == int ? admob() : scrapWidget(data);
  }

  Widget scrapWidget(data) {
    Size a = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
        width: a.width / 2.2,
        height: (a.width / 2.1) * 1.21,
        color: Colors.white,
        child: Center(
          child: Text(
            data['text'],
            style: TextStyle(fontSize: 32),
          ),
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
