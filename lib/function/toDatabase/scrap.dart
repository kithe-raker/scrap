import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/FriendsCache.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';
import 'package:scrap/function/randomLocation.dart';
import 'package:scrap/models/PlaceModel.dart';
import 'package:scrap/models/ScrapModel.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/provider/WriteScrapProvider.dart';
import 'package:scrap/services/GeoLocation.dart';
import 'package:scrap/stream/UserStream.dart';

final rtdb = FirebaseDatabase.instance;

class Scraps {
  PublishSubject<bool> loading = PublishSubject();
  final FirebaseMessaging fcm = FirebaseMessaging();

  throwTo(BuildContext context,
      {@required Map data,
      @required String thrownUID,
      @required String collRef,
      bool fromMain = false}) async {
    loading.add(true);
    final db = Provider.of<RealtimeDB>(context, listen: false);
    final scrapData = Provider.of<WriteScrapProvider>(context, listen: false);
    final batch = fireStore.batch();
    var userDb = FirebaseDatabase(app: db.userTransact);
    final user = Provider.of<UserData>(context, listen: false);
    var refDb = userDb.reference().child('users/$thrownUID');
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
            .reference()
            .child('users/${user.uid}')
            .update({'papers': userStream.papers - 1});
        refDb.child('thrown').once().then((data) => userDb
            .reference()
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
    final db = Provider.of<RealtimeDB>(context, listen: false);
    final scrapData = Provider.of<WriteScrapProvider>(context, listen: false);
    final user = Provider.of<UserData>(context, listen: false);
    var userDb = FirebaseDatabase(app: db.userTransact);
    var batch = fireStore.batch();
    loading.add(true);
    var refDb = userDb.reference().child('users/$thrownUID');
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
            .reference()
            .child('users/${user.uid}')
            .update({'papers': userStream.papers - 1});
        refDb.child('thrown').once().then((data) => userDb
            .reference()
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

  binScrap(BuildContext context,
      {@required LatLng location, @required LatLng defaultLocation}) async {
    loading.add(true);
    final scrapData = Provider.of<WriteScrapProvider>(context, listen: false);
    final user = Provider.of<UserData>(context, listen: false);
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var allScrap = FirebaseDatabase(app: db.scrapAll);
    var userDb = FirebaseDatabase(app: db.userTransact);
    var now = DateTime.now();
    var batch = Firestore.instance.batch();
    GeoLocation defaultPoint =
        GeoLocation(defaultLocation.latitude, defaultLocation.longitude);
    GeoLocation point = GeoLocation(location.latitude, location.longitude);
    var ref = Firestore.instance.collection(
        'Scraps/th/${DateFormat('yyyyMMdd').format(now)}/${now.hour}/ScrapDailys-th');
    var docId = ref.document().documentID;
    var trans = {
      'comment': 0,
      'id': docId,
      'point': 0.0,
      'like': 0,
      'picked': 0
    };
    var mainTrans = {
      'comment': 0,
      'id': docId,
      'point': 0.0,
      'burn': 0,
      'PPN': -5,
      'CPN': -5
    };
    Map<String, dynamic> scrap = {
      'id': docId,
      'uid': user.uid,
      'region': user.region,
      'scrap': {
        'text': scrapData.text,
        'texture': scrapData.textureIndex,
        'writer': scrapData.private ? 'ไม่ระบุตัวตน' : user.id,
        'timeStamp': FieldValue.serverTimestamp(),
      },
      'position': point.data,
    };
    batch.setData(ref.document(docId), scrap);
    scrap['default'] = defaultPoint.data;
    scrap['burnt'] = false;
    batch.setData(
        fireStore
            .collection('Users/${user.region}/users/${user.uid}/history')
            .document(docId),
        scrap);

    await allScrap.reference().child('scraps/$docId').set(trans);
    await FirebaseDatabase.instance
        .reference()
        .child('scraps/$docId')
        .set(mainTrans);
    await userDb
        .reference()
        .child('users/${user.uid}')
        .update({'papers': userStream.papers - 1});
    await batch.commit();
    scrapData.clearData();
    loading.add(false);
    toast('คุณโยนสแครปไปที่คุณเลือกแล้ว');
    Navigator.pop(context);
  }

  Future<void> litter(BuildContext context,
      {@required PlaceModel place}) async {
    loading.add(true);
    final scrapData = Provider.of<WriteScrapProvider>(context, listen: false);
    final user = Provider.of<UserData>(context, listen: false);
    var location = Provider.of<Position>(context, listen: false);
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var allScrap = FirebaseDatabase(app: db.scrapAll);
    var userDb = FirebaseDatabase(app: db.userTransact);
    var now = DateTime.now();
    var batch = fireStore.batch();
    GeoLocation point;
    GeoLocation defaultPoint =
        GeoLocation(location.latitude, location.longitude);
    var ref = fireStore.collection(
        'Scraps/th/${DateFormat('yyyyMMdd').format(now)}/${now.hour}/ScrapDailys-th');
    var docId = ref.document().documentID;

    if (place != null) {
      var ranLocation = random.getLocation(
          lat: place.location.latitude, lng: place.location.longitude);
      point = GeoLocation(ranLocation.latitude, ranLocation.longitude);
    }

    var trans = {
      'comment': 0,
      'id': docId,
      'point': 0.0,
      'like': 0,
      'picked': 0
    };
    var mainTrans = {
      'comment': 0,
      'id': docId,
      'point': 0.0,
      'like': 0,
      'picked': 0,
      'burn': 0,
      'PPN': -5,
      'CPN': -5
    };
    Map<String, dynamic> scrap = {
      'id': docId,
      'uid': user.uid,
      'region': user.region,
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
    }
    batch.setData(ref.document(docId), scrap);
    scrap['default'] = defaultPoint.data;
    scrap['burnt'] = false;
    batch.setData(
        fireStore
            .collection('Users/${user.region}/users/${user.uid}/history')
            .document(docId),
        scrap);
    await allScrap.reference().child('scraps/$docId').set(trans);
    await rtdb.reference().child('scraps/$docId').set(mainTrans);
    await userDb
        .reference()
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
    final db = Provider.of<RealtimeDB>(context, listen: false);
    final user = Provider.of<UserData>(context, listen: false);
    var allPlace = FirebaseDatabase(app: db.placeAll);
    var ref = allPlace.reference().child('places/${place.placeId}');
    var placeData;
    await ref.runTransaction((mutableData) async {
      placeData = mutableData.value;
      if (mutableData?.value != null) {
        var recently =
            DateTime.fromMillisecondsSinceEpoch(mutableData.value['recently']);
        if (DateTime.now().difference(recently).inHours > 24) {
          mutableData.value['recently'] = ServerValue.timestamp;
          mutableData.value['count'] = -1;
        } else
          mutableData.value['count'] = mutableData.value['count'] - 1;

        mutableData.value['allCount'] = mutableData.value['allCount'] - 1;
      }
      return mutableData;
    });
    if (placeData == null) {
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
    await fireStore
        .runTransaction((transaction) => transaction.get(refDoc).then((doc) {
              List recently = doc?.data['recently'] ?? [];
              if (recently.length > 7) recently.removeAt(0);
              recently.add({
                'text': text,
                'id': id,
                'timeStamp': DateTime.now(),
                'region': user.region,
                'texture': texture
              });
              transaction.update(refDoc, {'recently': recently});
            }));
  }

  void updateScrapTrans(String field, BuildContext context,
      {int comments, ScrapModel scrap, DocumentSnapshot doc}) async {
    Map<String, List> history = {};
    history['like'] = await cacheHistory.readOnlyId(field: 'like') ?? [];
    history['picked'] = await cacheHistory.readOnlyId(field: 'picked') ?? [];
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    var defaultDb = FirebaseDatabase.instance;
    var userDb = FirebaseDatabase(app: db.userTransact);
    var scrapId = scrap != null ? scrap.scrapId : doc.documentID;
    var writerUid = scrap != null ? scrap.writerUid : doc['uid'];
    var ref = 'scraps/$scrapId';

    if (history[field].contains(scrapId)) {
      cacheHistory.removeHistory(field, scrapId);
      var mutableData = await scrapAll.reference().child(ref).once();
      if (mutableData?.value != null) {
        var newPoint = field == 'like'
            ? mutableData.value['point'] + 2
            : mutableData.value['point'] + 3;
        defaultDb
            .reference()
            .child(ref)
            .update({'point': newPoint, field: mutableData.value[field] + 1});
        scrapAll
            .reference()
            .child(ref)
            .update({field: mutableData.value[field] + 1, 'point': newPoint});

        userDb.reference().child('users/$writerUid/att').once().then((data) =>
            userDb.reference().child('users/$writerUid').update(
                {'att': field == 'like' ? data.value - 1 : data.value - 3}));

        if (field == 'like')
          fcm.unsubscribeFromTopic(scrapId);
        else
          pickScrap(context, scrap: scrap, doc: doc, cancel: true);
      } else
        toast('กระดาษแผ่นนี้ถูกเผาแล้ว');
    } else {
      var transac = await scrapAll.reference().child('$ref/$field').once();
      if (transac?.value != null) {
        cacheHistory.addHistory(scrap, doc, field: field, comments: comments);
        var mutableData = await defaultDb.reference().child(ref).once();

        var newPoint = field == 'like'
            ? mutableData.value['point'] - 2
            : mutableData.value['point'] - 3;
        defaultDb
            .reference()
            .child(ref)
            .update({'point': newPoint, field: transac.value - 1});
        scrapAll
            .reference()
            .child(ref)
            .update({field: transac.value - 1, 'point': newPoint});

        pushNotification(scrapId, writerUid,
            notiRate: mutableData.value['PPN'], currentPoint: newPoint);

        userDb.reference().child('users/$writerUid/att').once().then((data) =>
            userDb.reference().child('users/$writerUid').update(
                {'att': field == 'like' ? data.value + 2 : data.value + 3}));

        if (field == 'like')
          fcm.subscribeToTopic(scrapId);
        else
          pickScrap(context, scrap: scrap, doc: doc);
      } else
        toast('กระดาษแผ่นนี้ถูกเผาแล้ว');
    }
  }

  pickScrap(BuildContext context,
      {bool cancel = false, ScrapModel scrap, DocumentSnapshot doc}) async {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    final user = Provider.of<UserData>(context, listen: false);
    var userDb = FirebaseDatabase(app: db.userTransact);
    var ref = userDb.reference().child('users/${user.uid}');
    var trans = await ref.child('pick').once();
    var data = scrap != null ? scrap.toJSON : doc.data;
    var scrapId = scrap?.scrapId ?? doc.documentID;
    if (cancel) {
      fireStore
          .collection('Users/${user.region}/users/${user.uid}/scrapCollection')
          .document(scrapId)
          .delete();
      ref.update({'pick': trans.value - 1});
    } else {
      data['picker'] = user.uid;
      data['timeStamp'] = FieldValue.serverTimestamp();
      fireStore
          .collection('Users/${user.region}/users/${user.uid}/scrapCollection')
          .document(scrapId)
          .setData(data);
      ref.update({'pick': trans.value + 1});
    }
  }

  pushNotification(String scrapId, String writerUid,
      {@required int notiRate,
      @required dynamic currentPoint,
      bool isComment = false}) {
    var target = isComment ? 'CPN' : 'PPN';
    if (currentPoint <= notiRate) {
      fireStore.collection('ScrapNotification').document(scrapId).setData(
          {'id': scrapId, 'isComment': isComment, 'writer': writerUid});
      FirebaseDatabase.instance
          .reference()
          .child('scraps/$scrapId')
          .update({target: notiRate * 2});
    }
  }

  resetScrap(BuildContext context, {@required String uid}) async {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var userDb = FirebaseDatabase(app: db.userTransact);
    await userDb.reference().child('users/$uid').update({'papers': 10});
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
