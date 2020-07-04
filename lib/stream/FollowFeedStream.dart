import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/FriendsCache.dart';
import 'package:scrap/models/ScrapModel.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/stream/LoadStatus.dart';

class FollowFeedStream {
  BehaviorSubject<List<ScrapModel>> followfeedSubject =
      BehaviorSubject<List<ScrapModel>>();
  List followList = [];
  DocumentSnapshot lastDoc;

  Stream<List<ScrapModel>> get followfeedStream => followfeedSubject.stream;
  List<ScrapModel> get scraps => followfeedSubject.value;

  addScrap(ScrapModel scrap) {
    var newList = scraps ?? [];
    newList.add(scrap);
    followfeedSubject.add(newList);
  }

  Timestamp yesterDay() {
    var now = DateTime.now();
    return Timestamp.fromDate(
        DateTime(now.year, now.month, now.day - 1, now.hour, now.minute));
  }

  Future<void> initFeed(BuildContext context) async {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    loadStatus.followFeedStatus.add(true);
    followfeedSubject.add([]);
    followList = await cacheFriends.getFollowing();
    if (followList.length > 0) {
      var followDocs = await fireStore
          .collectionGroup('scrapCollection')
          .where('picker', whereIn: followList)
          .orderBy('timeStamp', descending: true)
          .limit(8)
          .getDocuments();
      if (followDocs.documents.length > 0) {
        lastDoc = followDocs.documents.last;
        await Future.forEach(followDocs.documents, (doc) async {
          var data = await scrapAll
              .reference()
              .child('scraps/${doc.documentID}')
              .once();
          addScrap(ScrapModel.fromJSON(doc.data,
              transaction: ScrapTransaction.fromJSON(data.value)));
        });
      }
    }
    loadStatus.followFeedStatus.add(false);
  }

  Future<void> loadMore(BuildContext context) async {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    if (followList.length > 0) {
      var followDocs = await fireStore
          .collectionGroup('scrapCollection')
          .where('picker', whereIn: followList)
          .orderBy('timeStamp', descending: true)
          .startAfterDocument(lastDoc)
          .limit(3)
          .getDocuments();
      if (followDocs.documents.length > 0) {
        lastDoc = followDocs.documents.last;
        await Future.forEach(followDocs.documents, (doc) async {
          var data = await scrapAll
              .reference()
              .child('scraps/${doc.documentID}')
              .once();
          addScrap(ScrapModel.fromJSON(doc.data,
              transaction: ScrapTransaction.fromJSON(data.value)));
        });
      }
    }
  }
}

final followFeed = FollowFeedStream();
