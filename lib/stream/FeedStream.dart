import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrap/Page/bottomBarItem/feed/FeedPage.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/OtherCache.dart';
import 'package:scrap/models/ScrapModel.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/stream/LoadStatus.dart';

class FeedStream {
  BehaviorSubject<List<ScrapModel>> feedSubject =
      BehaviorSubject<List<ScrapModel>>();
  double _lessPoint;
  String lessPointId;
  final allScrap = dbRef.scrapAll;
  Map<String, ScrapTransaction> transacs = {};

  Stream<List<ScrapModel>> get feedStream => feedSubject.stream;
  List<ScrapModel> get scraps => feedSubject.value;

  addScrap(ScrapModel scrap) {
    var newList = scraps ?? [];
    newList.add(scrap);
    feedSubject.add(newList);
  }

  Future<void> initFeed() async {
    var cache = await cacheOther.recentlyPoint();
    _lessPoint = cache['point'];
    lessPointId = cache['id'];
    if (_lessPoint == null || _lessPoint >= -5.6) _lessPoint = null;
    loadStatus.feedStatus.add(true);
    List<String> docId = [];
    var ref = _lessPoint != null
        ? allScrap
            .child('scraps')
            .orderByChild('point')
            .startAt(_lessPoint, key: lessPointId)
            .limitToFirst(9)
        : allScrap.child('scraps').orderByChild('point').limitToFirst(9);
    DataSnapshot data = await ref.once();
    if (data.value?.length != null && data.value.length > 0) {
      data.value.forEach((key, value) {
        docId.add(value['id']);
        transacs[value['id']] = ScrapTransaction.fromJSON(value);
        if (_lessPoint == null || _lessPoint < value['point']) {
          _lessPoint = value['point'].toDouble();
          lessPointId = value['id'];
        }
      });
    }
    docId.removeWhere((id) => id == null);
    if (docId.length > 0) {
      var docs = await fireStore
          .collectionGroup('history')
          .where('id', whereIn: docId)
          .where('burnt', isEqualTo: false)
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
    if (_lessPoint <= 0) {
      List<String> docId = [];
      var ref = allScrap
          .child('scraps')
          .orderByChild('point')
          .startAt(_lessPoint, key: lessPointId)
          .limitToFirst(8);
      DataSnapshot data = await ref.once();
      if (data.value?.length != null && data.value.length > 0) {
        data.value.forEach((key, value) {
          if (transacs[value['id']]?.point == null) {
            docId.add(value['id']);
            transacs[value['id']] = ScrapTransaction.fromJSON(value);
            if (_lessPoint < value['point']) {
              _lessPoint = value['point'].toDouble();
              lessPointId = value['id'];
            }
          }
        });
      }
      docId.removeWhere((id) => id == null);
      if (docId.length > 0) {
        var docs = await fireStore
            .collectionGroup('history')
            .where('id', whereIn: docId)
            .where('burnt', isEqualTo: false)
            .getDocuments();
        docs.documents.forEach((scrap) {
          addScrap(ScrapModel.fromJSON(scrap.data,
              transaction: transacs[scrap.documentID]));
        });
        print('------');
      }
      cacheOther.update(point: _lessPoint, id: lessPointId);
    }
  }
}

final feed = FeedStream();
