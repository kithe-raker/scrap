import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/FriendsCache.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/provider/WriteScrapProvider.dart';

final db = FirebaseDatabase.instance;

class Scraps {
  PublishSubject<bool> loading = PublishSubject();
  final FirebaseMessaging fcm = FirebaseMessaging();

  throwTo(BuildContext context,
      {@required Map data,
      @required String thrownUID,
      @required String collRef}) async {
    loading.add(true);
    final db = Provider.of<RealtimeDB>(context, listen: false);
    final scrapData = Provider.of<WriteScrapProvider>(context, listen: false);
    final batch = fireStore.batch();
    var userDb = FirebaseDatabase(app: db.userTransact);
    final user = Provider.of<UserData>(context, listen: false);
    var refDb = userDb.reference().child('users/$thrownUID');
    bool allow = (await refDb.child('allowThrow').once()).value;
    if (allow ?? true) {
      var ref = fireStore.collection('$collRef/$thrownUID/thrownScraps');
      var scrap = {
        'uid': user.uid,
        'region': user.region,
        'thrown': thrownUID,
        'scrap': {
          'text': scrapData.text,
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
          .update({'papers': user.papers - 1});
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
      loading.add(false);
      toast('ปาสำเร็จแล้ว');
      nav.pop(context);
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
      var scrap = {
        'uid': user.uid,
        'region': user.region,
        'thrown': thrownUID,
        'scrap': {
          'text': scrapData.text,
          'writer': user.id,
          'timeStamp': FieldValue.serverTimestamp()
        }
      };
      var ref =
          fireStore.collection('Users/$region/users/$thrownUID/thrownScraps');
      var docId = ref.document().documentID;
      userDb
          .reference()
          .child('users/${user.uid}')
          .update({'papers': user.papers - 1});
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
      loading.add(false);
      toast('ปาสำเร็จแล้ว');
      nav.pop(context);
    } else {
      loading.add(false);
      toast('ผู้ใช้คนนี้พึ่งปิดการปาเมื่อไม่นานมานี้');
    }
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
    GeoFirePoint defaultPoint = Geoflutterfire().point(
        latitude: defaultLocation.latitude,
        longitude: defaultLocation.longitude);
    GeoFirePoint point = Geoflutterfire()
        .point(latitude: location.latitude, longitude: location.longitude);
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
        .update({'papers': user.papers - 1});
    await batch.commit();
    loading.add(false);
    toast('คุณโยนสแครปไปที่คุณเลือกแล้ว');
    Navigator.pop(context);
  }

  void updateScrapTrans(
      String field, DocumentSnapshot scrap, BuildContext context,
      {int comments}) async {
    Map<String, List> history = {};
    history['like'] = await cacheHistory.readOnlyId(field: 'like') ?? [];
    history['picked'] = await cacheHistory.readOnlyId(field: 'picked') ?? [];
    final user = Provider.of<UserData>(context, listen: false);
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    var defaultDb = FirebaseDatabase.instance;
    var userDb = FirebaseDatabase(app: db.userTransact);
    var ref = 'scraps/${scrap.documentID}';

    if (history[field].contains(scrap.documentID)) {
      cacheHistory.removeHistory(field, scrap.documentID);
      var mutableData = await scrapAll.reference().child(ref).once();
      if (mutableData?.value != null) {
        var newPoint = field == 'like'
            ? mutableData.value['point'] + 2
            : mutableData.value['point'] + 3;
        defaultDb.reference().child(ref).update({'point': newPoint});
        scrapAll
            .reference()
            .child(ref)
            .update({field: mutableData.value[field] + 1, 'point': newPoint});

        userDb.reference().child('users/${scrap['uid']}/att').once().then(
            (data) => userDb.reference().child('users/${scrap['uid']}').update(
                {'att': field == 'like' ? data.value - 1 : data.value - 3}));

        if (field == 'like')
          fcm.unsubscribeFromTopic(scrap.documentID);
        else
          pickScrap(scrap.data, user.uid, context, cancel: true);
      } else
        toast('กระดาษแผ่นนี้ถูกเผาแล้ว');
    } else {
      var transac = await scrapAll.reference().child('$ref/$field').once();
      if (transac?.value != null) {
        cacheHistory.addHistory(scrap, field: field, comments: comments);
        var mutableData = await defaultDb.reference().child(ref).once();

        var newPoint = field == 'like'
            ? mutableData.value['point'] - 2
            : mutableData.value['point'] - 3;
        defaultDb.reference().child(ref).update({'point': newPoint});
        scrapAll
            .reference()
            .child(ref)
            .update({field: transac.value - 1, 'point': newPoint});

        pushNotification(scrap,
            notiRate: mutableData.value['PPN'], currentPoint: newPoint);

        userDb.reference().child('users/${scrap['uid']}/att').once().then(
            (data) => userDb.reference().child('users/${scrap['uid']}').update(
                {'att': field == 'like' ? data.value + 2 : data.value + 3}));

        if (field == 'like')
          fcm.subscribeToTopic(scrap.documentID);
        else
          pickScrap(scrap.data, user.uid, context);
      } else
        toast('กระดาษแผ่นนี้ถูกเผาแล้ว');
    }
  }

  pickScrap(Map scrap, String uid, BuildContext context,
      {bool cancel = false}) async {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var userDb = FirebaseDatabase(app: db.userTransact);
    var ref = userDb.reference().child('users/$uid');
    final user = Provider.of<UserData>(context, listen: false);
    var trans = await ref.child('pick').once();
    if (cancel) {
      fireStore
          .collection('Users/${user.region}/users/${user.uid}/scrapCollection')
          .document(scrap['id'])
          .delete();
      ref.update({'pick': trans.value - 1});
    } else {
      scrap['picker'] = uid;
      scrap['timeStamp'] = FieldValue.serverTimestamp();
      fireStore
          .collection('Users/${user.region}/users/${user.uid}/scrapCollection')
          .document(scrap['id'])
          .setData(scrap);
      ref.update({'pick': trans.value + 1});
    }
  }

  pushNotification(DocumentSnapshot scrap,
      {@required int notiRate,
      @required dynamic currentPoint,
      bool isComment = false}) {
    var target = isComment ? 'CPN' : 'PPN';
    if (currentPoint <= notiRate) {
      fireStore
          .collection('ScrapNotification')
          .document(scrap.documentID)
          .setData({
        'id': scrap.documentID,
        'isComment': isComment,
        'writer': scrap['uid']
      });
      FirebaseDatabase.instance
          .reference()
          .child('scraps/${scrap.documentID}')
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
