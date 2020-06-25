import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrap/Page/bottomBarItem/feed/FeedPage.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/OtherCache.dart';
import 'package:scrap/models/ScrapModel.dart';
import 'package:scrap/stream/LoadStatus.dart';

class FeedStream {
  BehaviorSubject<List<ScrapModel>> feedSubject =
      BehaviorSubject<List<ScrapModel>>();
  double _lessPoint;

  Stream<List<ScrapModel>> get feedStream => feedSubject.stream;
  List<ScrapModel> get scraps => feedSubject.value;
  double get lesspoint => _lessPoint;

  addScrap(ScrapModel scrap) {
    var newList = scraps ?? [];
    newList.add(scrap);
    feedSubject.add(newList);
  }

  clearOldScrap() {
    print('clear');
    var newList = scraps ?? [];
    newList.removeAt(0);
    feedSubject.add(newList);
  }

  Timestamp yesterDay() {
    var now = DateTime.now();
    return Timestamp.fromDate(
        DateTime(now.year, now.month, now.day - 1, now.hour, now.minute));
  }

  Future<void> initFeed() async {
    _lessPoint = await cacheOther.recentlyPoint();
    if (_lessPoint == null || _lessPoint >= -5.6) _lessPoint = null;
    loadStatus.feedStatus.add(true);
    var transacs = {};
    List<String> docId = [];
    var ref = _lessPoint != null
        ? FirebaseDatabase.instance
            .reference()
            .child('scraps')
            .orderByChild('point')
            .startAt(_lessPoint)
            .limitToFirst(9)
        : FirebaseDatabase.instance
            .reference()
            .child('scraps')
            .orderByChild('point')
            .limitToFirst(9);
    DataSnapshot data = await ref.once();
    if (data.value?.length != null && data.value.length > 0) {
      data.value.forEach((key, value) {
        docId.add(value['id']);
        transacs[value['id']] = ScrapTransaction.fromJSON(value);
        if (_lessPoint == null || _lessPoint < value['point'])
          _lessPoint = value['point'].toDouble();
      });
    }
    docId.removeWhere((id) => id == null);
    if (docId.length > 0) {
      var docs = await fireStore
          .collectionGroup('ScrapDailys-th')
          .where('id', whereIn: docId)
          .where('scrap.timeStamp', isGreaterThan: yesterDay())
          .getDocuments();
      docs.documents.forEach((scrap) {
        addScrap(ScrapModel.fromJSON(scrap.data,
            transaction: transacs[scrap.documentID]));
      });
      loadStatus.feedStatus.add(false);
    } else
      loadStatus.feedStatus.add(false);
    topbarStream.add(2100);
    print('------');
  }

  Future<void> loadMore() async {
    var queryPoint = _lessPoint + 0.1;
    if (queryPoint <= 0) {
      var transacs = {};
      List<String> docId = [];
      var ref = FirebaseDatabase.instance
          .reference()
          .child('scraps')
          .orderByChild('point')
          .startAt(queryPoint)
          .limitToFirst(2);
      DataSnapshot data = await ref.once();
      if (data.value?.length != null && data.value.length > 0) {
        data.value.forEach((key, value) {
          docId.add(value['id']);
          transacs[value['id']] = ScrapTransaction.fromJSON(value);
          if (queryPoint < value['point'])
            queryPoint = value['point'].toDouble();
        });
      }
      docId.removeWhere((id) => id == null);
      if (docId.length > 0) {
        var docs = await fireStore
            .collectionGroup('ScrapDailys-th')
            .where('id', whereIn: docId)
            .where('scrap.timeStamp', isGreaterThan: yesterDay())
            .getDocuments();
        docs.documents.forEach((scrap) {
          addScrap(ScrapModel.fromJSON(scrap.data,
              transaction: transacs[scrap.documentID]));
        });
        print('------');
      }

      _lessPoint = queryPoint.toDouble();
      cacheOther.update(queryPoint);
    }
  }
}

final feed = FeedStream();
