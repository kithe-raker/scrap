import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/FriendsCache.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';

class FollowsFunction {
  PublishSubject<bool> loading = PublishSubject();

  Future<void> followUser(BuildContext context,
      {@required String otherUid,
      @required String otherCollRef,
      @required int followingCounts}) async {
    loading.add(true);
    final db = Provider.of<RealtimeDB>(context, listen: false);
    final user = Provider.of<UserData>(context, listen: false);
    final batch = fireStore.batch();
    var index = followingCounts ~/ 1000;
    var userDb = FirebaseDatabase(app: db.userTransact);
    var ref = userDb.reference().child('users/${user.uid}/follows');
    var otherRef = userDb.reference().child('users/$otherUid/follows');
    var data = await otherRef.child('followers').once();
    otherRef.update({'followers': data.value + 1});
    ref.update({'following': followingCounts + 1});
    cacheFriends.addFollowing(following: [otherUid]);
    batch.setData(
        fireStore
            .collection('Users/${user.region}/users/${user.uid}/following')
            .document('$index'),
        {
          'list': FieldValue.arrayUnion([otherUid])
        },
        merge: true);
    batch.setData(
        fireStore
            .collection('$otherCollRef/$otherUid/follower')
            .document('${(data.value + 1) ~/ 1000}'),
        {
          'list': FieldValue.arrayUnion([user.uid])
        },
        merge: true);
    await batch.commit();
    loading.add(false);
  }

  Future<void> unFollowUser(BuildContext context,
      {@required String otherUid,
      @required String otherCollRef,
      @required int followingCounts}) async {
    loading.add(true);
    final db = Provider.of<RealtimeDB>(context, listen: false);
    final user = Provider.of<UserData>(context, listen: false);
    final batch = fireStore.batch();
    var userDb = FirebaseDatabase(app: db.userTransact);
    var ref = userDb.reference().child('users/${user.uid}/follows');
    var otherRef = userDb.reference().child('users/$otherUid/follows');
    var data = await otherRef.child('followers').once();
    otherRef.update({'followers': data.value - 1});
    ref.update({'following': followingCounts - 1});
    cacheFriends.unFollowing(unFollowUid: otherUid);
    var otherDoc = await fireStore
        .collection('$otherCollRef/$otherUid/follower')
        .where('list', arrayContains: user.uid)
        .getDocuments();
    var docs = await fireStore
        .collection('Users/${user.region}/users/${user.uid}/following')
        .where('list', arrayContains: otherUid)
        .getDocuments();
    batch.setData(
        otherDoc.documents[0].reference,
        {
          'list': FieldValue.arrayRemove([user.uid])
        },
        merge: true);
    batch.setData(
        docs.documents[0].reference,
        {
          'list': FieldValue.arrayRemove([otherUid])
        },
        merge: true);
    await batch.commit();
    loading.add(false);
  }
}

final followFunc = FollowsFunction();
