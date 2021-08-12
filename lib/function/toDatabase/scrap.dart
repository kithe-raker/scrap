import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/FriendsCache.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';
import 'package:scrap/function/randomLocation.dart';
import 'package:scrap/method/Globalkey.dart';
import 'package:scrap/models/PlaceModel.dart';
import 'package:scrap/models/ScrapModel.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/provider/WriteScrapProvider.dart';
import 'package:scrap/services/GeoLocation.dart';
import 'package:scrap/stream/UserStream.dart';

final rtdb = FirebaseDatabase.instance.reference();

class Scraps {
  PublishSubject<bool> loading = PublishSubject();
  final FirebaseMessaging fcm = FirebaseMessaging();
  final scrapAll = dbRef.scrapAll;
  final userDb = dbRef.userTransact;
  final allPlace = dbRef.placeAll;
  final globalContext = myGlobals.scaffoldKey.currentContext;

  throwTo(BuildContext context,
      {@required Map data,
      @required String thrownUID,
      @required String collRef,
      bool fromMain = false}) async {
    loading.add(true);
    final scrapData = Provider.of<WriteScrapProvider>(context, listen: false);
    final batch = fireStore.batch();
    final user = Provider.of<UserData>(context, listen: false);
    var refDb = userDb.child('users/$thrownUID');
    bool allow = (await refDb.child('allowThrow').once()).value;
    if (allow) {
      var ref = fireStore.collection('$collRef/$thrownUID/thrownScraps');
      var blockDoc = await fireStore
          .collection('$collRef/$thrownUID/blocks')
          .where('list', arrayContains: user.uid)
          .limit(1)
          .getDocuments();
      if (blockDoc.documents.length < 1) {
        var scrap = {
          'uid': user.uid,
          'region': user.region,
          'thrown': thrownUID,
          'scrap': {
            'text': scrapData.text,
            'texture': scrapData.textureIndex,
            'writer': scrapData.private ? 'ไม่ระบุตัวตน' : user.id,
            'timeStamp': FieldValue.serverTimestamp()
          }
        };
        var docId = ref.document().documentID;
        cacheFriends.addRecently(
            id: data['id'],
            img: data['img'],
            status: data['status'],
            thrownUid: thrownUID,
            ref: collRef);
        userDb
            .child('users/${user.uid}')
            .update({'papers': userStream.papers - 1});
        refDb.child('thrown').once().then((data) => userDb
            .child('users/$thrownUID')
            .update({'thrown': data.value + 1}));

        batch.setData(ref.document(docId), scrap);
        scrap['burnt'] = false;
        batch.setData(
            fireStore
                .collection('Users/${user.region}/users/${user.uid}/thrownLog')
                .document(docId),
            scrap);
        await batch.commit();
      }
      scrapData.clearData();
      loading.add(false);
      toast('ปาสำเร็จแล้ว');
      if (!fromMain) nav.pop(context);
    } else {
      loading.add(false);
      toast('ผู้ใช้คนนี้พึ่งปิดการปาเมื่อไม่นานมานี้');
    }
  }

  throwBack(BuildContext context,
      {@required String thrownUID, @required String region}) async {
    final scrapData = Provider.of<WriteScrapProvider>(context, listen: false);
    final user = Provider.of<UserData>(context, listen: false);
    var batch = fireStore.batch();
    loading.add(true);
    var refDb = userDb.child('users/$thrownUID');
    bool allow = (await refDb.child('allowThrow').once()).value;
    if (allow) {
      var blockDoc = await fireStore
          .collection('Users/$region/users/$thrownUID/blocks')
          .where('list', arrayContains: user.uid)
          .limit(1)
          .getDocuments();
      if (blockDoc.documents.length < 1) {
        var scrap = {
          'uid': user.uid,
          'region': user.region,
          'thrown': thrownUID,
          'scrap': {
            'text': scrapData.text,
            'writer': user.id,
            'texture': scrapData.textureIndex,
            'timeStamp': FieldValue.serverTimestamp()
          }
        };
        var ref =
            fireStore.collection('Users/$region/users/$thrownUID/thrownScraps');
        var docId = ref.document().documentID;
        userDb
            .child('users/${user.uid}')
            .update({'papers': userStream.papers - 1});
        refDb.child('thrown').once().then((data) => userDb
            .child('users/$thrownUID')
            .update({'thrown': data.value + 1}));

        batch.setData(ref.document(docId), scrap);
        scrap['burnt'] = false;
        batch.setData(
            fireStore
                .collection('Users/${user.region}/users/${user.uid}/thrownLog')
                .document(docId),
            scrap);
        await batch.commit();
      }
      loading.add(false);
      toast('ปาสำเร็จแล้ว');
      nav.pop(context);
    } else {
      loading.add(false);
      toast('ผู้ใช้คนนี้พึ่งปิดการปาเมื่อไม่นานมานี้');
    }
    scrapData.clearData();
  }

  Future<void> litter(BuildContext context,
      {@required PlaceModel place}) async {
    loading.add(true);
    final scrapData = Provider.of<WriteScrapProvider>(context, listen: false);
    final user = Provider.of<UserData>(context, listen: false);
    var batch = fireStore.batch();
    GeoLocation point;
    var ref =
        fireStore.collection('Users/${user.region}/users/${user.uid}/history');
    var docId = ref.document().documentID;

    if (place != null) {
      var ranLocation = random.getLocation(
          lat: place.location.latitude, lng: place.location.longitude);
      point = GeoLocation(ranLocation.latitude, ranLocation.longitude);
    }

    var mainTrans = {
      'comment': 0,
      'id': docId,
      'point': 0.0,
      'like': 0,
      'picked': 0,
      'burn': 0,
      'timeStamp': ServerValue.timestamp,
      'CPN': -1
    };
    Map<String, dynamic> scrap = {
      'id': docId,
      'uid': user.uid,
      'region': user.region,
      'burnt': false,
      'scrap': {
        'text': scrapData.text,
        'texture': scrapData.textureIndex,
        'writer': scrapData.private ? 'ไม่ระบุตัวตน' : user.id,
        'timeStamp': FieldValue.serverTimestamp()
      },
    };
    if (place != null) {
      scrap['position'] = point.data;
      scrap['places'] = FieldValue.arrayUnion([place.placeId]);
      scrap['placeName'] = place.name;
    }
    batch.setData(ref.document(docId), scrap);
    await rtdb
        .child('scrap-app/allScrap')
        .runTransaction((mutableData) async => (mutableData?.value ?? 0) + 1);
    await scrapAll.child('scraps/$docId').set(mainTrans);
    await userDb
        .child('users/${user.uid}')
        .update({'papers': userStream.papers - 1});
    await batch.commit();
    if (place != null)
      await updatePlace(context,
          place: place,
          id: docId,
          text: scrapData.text,
          texture: scrapData.textureIndex);
    scrapData.clearData();
    loading.add(false);
    toast('คุณโยนสแครปไปที่คุณเลือกแล้ว');
    nav.pop(context);
  }

  updatePlace(BuildContext context,
      {@required PlaceModel place,
      @required String id,
      @required String text,
      @required int texture}) async {
    final user = Provider.of<UserData>(context, listen: false);
    var ref = allPlace.child('places/${place.placeId}');
    var placeData;
    await ref.runTransaction((mutableData) async {
      placeData = mutableData.value;
      if (mutableData?.value != null) {
        var recently =
            DateTime.fromMillisecondsSinceEpoch(mutableData.value['recently']);
        if (DateTime.now().difference(recently).inHours > 24) {
          mutableData.value['recently'] = ServerValue.timestamp;
          mutableData.value['count'] =
              ((mutableData.value['count'] / 2) - 1).toInt();
        } else
          mutableData.value['count'] = mutableData.value['count'] - 1;

        mutableData.value['allCount'] = mutableData.value['allCount'] - 1;
      }
      return mutableData;
    });
    if (placeData == null || placeData['id'] == null) {
      ref.update({
        'id': place.placeId,
        'recently': ServerValue.timestamp,
        'count': -1,
        'allCount': -1
      });
      await fireStore
          .collection('Places')
          .document(place.placeId)
          .setData(place.toJSON, merge: true);
    }
    var refDoc = fireStore.collection('Places').document(place.placeId);
    await fireStore.runTransaction((transaction) async {
      var doc = await transaction.get(refDoc);
      List recently = doc?.data['recently'] ?? [];
      if (recently.length > 7) recently.removeAt(0);
      recently.add({
        'text': text,
        'id': id,
        'timeStamp': DateTime.now(),
        'region': user.region,
        'texture': texture
      });
      await transaction.update(refDoc, {'recently': recently});
    });
  }

  bool updating = false;

  void updateScrapTrans(String field,
      {int comments, ScrapModel scrap, DocumentSnapshot doc}) async {
    assert(!updating);
    updating = true;
    Map<String, List> history = {};
    history['like'] = await cacheHistory.readOnlyId(field: 'like') ?? [];
    history['picked'] = await cacheHistory.readOnlyId(field: 'picked') ?? [];

    var scrapId = scrap != null ? scrap.scrapId : doc.documentID;
    var writerUid = scrap != null ? scrap.writerUid : doc['uid'];
    var ref = 'scraps/$scrapId';

    if (history[field].contains(scrapId)) {
      cacheHistory.removeHistory(field, scrapId);
      var mutableData = await scrapAll.child(ref).once();
      if (mutableData?.value != null) {
        var newPoint = field == 'like'
            ? mutableData.value['point'] + 2
            : mutableData.value['point'] + 3;
        scrapAll
            .child(ref)
            .update({field: mutableData.value[field] + 1, 'point': newPoint});

        userDb.child('users/$writerUid/att').runTransaction((data) async {
          if (data?.value != null)
            data.value = field == 'like' ? data.value - 1 : data.value - 3;
          return data;
        });

        if (field != 'like') {
          fcm.unsubscribeFromTopic(scrapId);
          pickScrap(scrap: scrap, doc: doc, cancel: true);
        }
      } else
        toast('กระดาษแผ่นนี้ถูกเผาแล้ว');
    } else {
      var mutableData = await scrapAll.child(ref).once();
      if (mutableData?.value != null) {
        cacheHistory.addHistory(scrap, doc, field: field, comments: comments);

        var newPoint = field == 'like'
            ? mutableData.value['point'] - 2
            : mutableData.value['point'] - 3;
        scrapAll
            .child(ref)
            .update({field: mutableData.value[field] - 1, 'point': newPoint});

        userDb.child('users/$writerUid/att').runTransaction((data) async {
          if (data?.value != null)
            data.value = field == 'like' ? data.value + 2 : data.value + 3;
          return data;
        });

        if (field != 'like') {
          fcm.subscribeToTopic(scrapId);
          pickScrap(scrap: scrap, doc: doc);
        }
      } else
        toast('กระดาษแผ่นนี้ถูกเผาแล้ว');
    }
    updating = false;
  }

  pickScrap(
      {bool cancel = false, ScrapModel scrap, DocumentSnapshot doc}) async {
    final user = Provider.of<UserData>(globalContext, listen: false);
    var ref = userDb.child('users/${user.uid}');
    var data = scrap != null ? scrap.toJSON : doc.data;
    var scrapId = scrap?.scrapId ?? doc.documentID;
    if (cancel) {
      fireStore
          .collection('Users/${user.region}/users/${user.uid}/scrapCollection')
          .document(scrapId)
          .delete();
      ref.update({'pick': userStream.pick - 1});
    } else {
      data['picker'] = user.uid;
      data['timeStamp'] = FieldValue.serverTimestamp();
      fireStore
          .collection('Users/${user.region}/users/${user.uid}/scrapCollection')
          .document(scrapId)
          .setData(data);
      ref.update({'pick': userStream.pick + 1});
    }
  }

  pushNotification(String scrapId, String writerUid,
      {@required int notiRate, @required dynamic currentPoint}) {
    var target = 'CPN';
    if (currentPoint <= notiRate) {
      fireStore
          .collection('ScrapNotification')
          .document(scrapId)
          .setData({'id': scrapId, 'isComment': true, 'writer': writerUid});
      scrapAll
          .child('scraps/$scrapId')
          .update({target: notiRate < 5 ? 5 : notiRate * 2});
    }
  }

  Future<void> resetScrap({@required String uid}) async {
    await userDb.child('users/$uid').update({'papers': 5});
  }

  Future<bool> blocked(String uid, String thrownUID) async {
    List blockList = [];
    await Firestore.instance
        .collection('Users')
        .document(thrownUID)
        .collection('info')
        .document('blockList')
        .get()
        .then((value) {
      value?.data == null
          ? blockList = []
          : blockList = value?.data['blockList'] ?? [];
    });
    return blockList.where((data) => data['uid'] == uid).length > 0;
  }

  toast(String text) {
    return Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        // timeInSecForIos: 1,
        backgroundColor: Colors.white60,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}

final scrap = Scraps();
