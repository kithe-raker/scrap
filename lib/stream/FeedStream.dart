import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrap/Page/bottomBarItem/feed/FeedPage.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/OtherCache.dart';
import 'package:scrap/models/CacheQuery.dart';
import 'package:scrap/models/ScrapModel.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/stream/LoadStatus.dart';
import 'package:scrap/widget/FeedNativeAds.dart';

class FeedStream {
  BehaviorSubject<List> feedSubject = BehaviorSubject<List>();
  CacheQuery cache;
  String recentScrapId = '';
  int adsRate = 0, adsCount = 0;
  final allScrap = dbRef.scrapAll;
  Map<String, ScrapTransaction> transacs = {};

  Stream<List> get feedStream => feedSubject.stream;
  List get scraps => feedSubject.value;

  addScrap(ScrapModel scrap) {
    var newList = scraps ?? [];
    newList.add(scrap);
    ++adsCount;
    if (adsCount == adsRate) {
      newList.add(FeedNativeAds.feedAds);
      randomAdsRate();
    }
    feedSubject.add(newList);
  }

//timeStamp
  Future<void> initFeed() async {
    randomAdsRate();
    cache = CacheQuery.fromJSON(await cacheOther.recentlyPoint() ?? {});
    loadRecentScrap();
    if (cache.lessPoint == null || cache.lessPoint >= -5.6)
      cache.lessPoint = null;
    loadStatus.feedStatus.add(true);
    List<String> docId = [];
    var ref = cache.lessPoint != null
        ? allScrap
            .child('scraps')
            .orderByChild('point')
            .startAt(cache.lessPoint, key: cache.lessPointId)
            .limitToFirst(6)
        : allScrap.child('scraps').orderByChild('point').limitToFirst(6);
    DataSnapshot data = await ref.once();
    if (data.value?.length != null && data.value.length > 0) {
      data.value.forEach((key, value) {
        if (transacs[value['id']]?.point == null) {
          docId.add(value['id']);
          transacs[value['id']] = ScrapTransaction.fromJSON(value);
          if (cache.lessPoint == null || cache.lessPoint < value['point']) {
            cache.lessPoint = value['point'].toDouble();
            cache.lessPointId = value['id'];
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
      loadStatus.feedStatus.add(false);
    } else
      loadStatus.feedStatus.add(false);
    topbarStream.add(2100);
    print('------');
  }

  loadRecentScrap({int length = 4}) async {
    List<String> docId = [];
    var ref = cache.recentScrapId != null
        ? allScrap
            .child('scraps')
            .orderByChild('timeStamp')
            .startAt(cache.recentTime, key: cache.recentScrapId)
            .limitToFirst(length)
        : allScrap
            .child('scraps')
            .orderByChild('timeStamp')
            .startAt(cache.recentTime)
            .limitToFirst(length);
    DataSnapshot data = await ref.once();
    if (data.value?.length != null && data.value.length > 0) {
      data.value.forEach((key, value) {
        if (transacs[value['id']]?.point == null) {
          docId.add(value['id']);
          transacs[value['id']] = ScrapTransaction.fromJSON(value);
          if (cache.recentTime == null ||
              cache.recentTime < value['timeStamp']) {
            cache.recentTime = value['timeStamp'];
            cache.recentScrapId = value['id'];
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
      cacheOther.updateRecent(id: cache.recentScrapId, time: cache.recentTime);
      print('--t--');
    } else
      cacheOther.updateRecent(id: cache.recentScrapId, time: cache.recentTime);
  }

  Future<void> loadMore() async {
    int length = 4;
    if (cache.recentScrapId != null && recentScrapId != cache.recentScrapId) {
      recentScrapId = cache.recentScrapId;
    } else
      length += 4;
    if (cache.lessPoint <= 0) {
      List<String> docId = [];
      var ref = allScrap
          .child('scraps')
          .orderByChild('point')
          .startAt(cache.lessPoint, key: cache.lessPointId)
          .limitToFirst(length);
      DataSnapshot data = await ref.once();
      if (data.value?.length != null && data.value.length > 0) {
        data.value.forEach((key, value) {
          if (transacs[value['id']]?.point == null) {
            docId.add(value['id']);
            transacs[value['id']] = ScrapTransaction.fromJSON(value);
            if (cache.lessPoint < value['point']) {
              cache.lessPoint = value['point'].toDouble();
              cache.lessPointId = value['id'];
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
        print('----');
        cacheOther.updateHot(point: cache.lessPoint, id: cache.lessPointId);
      } else {
        cacheOther.updateHot(point: null, id: cache.lessPointId);
      }
    }
  }

  void randomAdsRate() {
    adsCount = 0;
    adsRate = 3;
    adsRate += Random().nextInt(2) + 1;
  }
}

final feed = FeedStream();
