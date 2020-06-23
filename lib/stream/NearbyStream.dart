import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/models/ScrapModel.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/stream/LoadStatus.dart';

class NearbyStream {
  BehaviorSubject<List<ScrapModel>> nearbySubject =
      BehaviorSubject<List<ScrapModel>>();
  DocumentSnapshot lastDoc;

  Stream<List<ScrapModel>> get nearbyStream => nearbySubject.stream;
  List<ScrapModel> get scraps => nearbySubject.value;

  addScrap(ScrapModel scrap) {
    var newList = scraps ?? [];
    newList.add(scrap);
    nearbySubject.add(newList);
  }

  clearOldScrap() {
    print('clear');
    var newList = scraps ?? [];
    newList.removeAt(0);
    nearbySubject.add(newList);
  }

  Timestamp yesterDay() {
    var now = DateTime.now();
    return Timestamp.fromDate(
        DateTime(now.year, now.month, now.day - 1, now.hour, now.minute));
  }

  Future<void> initNearby(BuildContext context,
      {@required String placeId}) async {
    loadStatus.nearbyStatus.add(true);
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    List<ScrapModel> queryScraps = [];
    var ref = fireStore
        .collectionGroup('ScrapDailys-th')
        .where('places', arrayContains: placeId)
        .orderBy('scrap.timeStamp', descending: true)
        .limit(16);
    var docs = (await ref.getDocuments()).documents;
    if (docs.length > 0) {
      lastDoc = docs.last;
      await Future.forEach(docs, (DocumentSnapshot doc) async {
        var ref = scrapAll.reference().child('scraps').child(doc.documentID);
        var data = await ref.once();
        queryScraps.add(ScrapModel.fromJSON(doc.data,
            transaction: ScrapTransaction.fromJSON(data.value)));
      });
      nearbySubject.add(queryScraps);
    }
    loadStatus.nearbyStatus.add(false);
  }

  Future<void> loadMore(BuildContext context,
      {@required String placeId}) async {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    var ref = fireStore
        .collectionGroup('ScrapDailys-th')
        .where('places', arrayContains: placeId)
        .orderBy('scrap.timeStamp', descending: true)
        .startAfterDocument(lastDoc)
        .limit(3);
    var docs = (await ref.getDocuments()).documents;
    if (docs.length > 0) {
      await Future.forEach(docs, (DocumentSnapshot doc) async {
        var ref = scrapAll.reference().child('scraps').child(doc.documentID);
        var data = await ref.once();
        addScrap(ScrapModel.fromJSON(doc.data,
            transaction: ScrapTransaction.fromJSON(data.value)));
      });
    }
  }
}

final nearby = NearbyStream();
