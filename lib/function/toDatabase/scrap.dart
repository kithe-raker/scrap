import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/services/provider.dart' as prov;

class Scraps {
  final FirebaseMessaging fcm = FirebaseMessaging();

  throwTo(BuildContext context,
      {@required String uid,
      @required String writer,
      @required String thrownUID,
      @required bool public,
      @required String text}) {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var userDb = FirebaseDatabase(app: db.userTransact);
    final user = Provider.of<UserData>(context, listen: false);
    var ref = Firestore.instance
        .collection('Users')
        .document(thrownUID)
        .collection('scrapCrate');
    var docId = ref.document().documentID;
    ref.document(docId).setData({
      'uid': uid,
      'scrap': {
        'text': text,
        'writer': public ?? false ? writer : 'ไม่ระบุตัวตน',
        'timeStamp': FieldValue.serverTimestamp()
      }
    });
    userDb.reference().child('users/$uid').update({'papers': user.papers - 1});
    userDb.reference().child('users/$thrownUID/thrown').once().then((data) =>
        userDb
            .reference()
            .child('users/$thrownUID')
            .update({'thrown': data.value + 1}));
  }

  binScrap(DocumentSnapshot doc, BuildContext context,
      {@required String text, @required bool public}) async {
    final user = Provider.of<UserData>(context, listen: false);
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var allScrap = FirebaseDatabase(app: db.scrapAll);
    var userDb = FirebaseDatabase(app: db.userTransact);
    var now = DateTime.now();
    var batch = Firestore.instance.batch();
    var location = await Geolocator().getCurrentPosition();
    GeoFirePoint point = Geoflutterfire()
        .point(latitude: location.latitude, longitude: location.longitude);
    var ref = Firestore.instance.collection(
        'Scraps/th/${DateFormat('yyyyMMdd').format(now)}/${now.hour}/ScrapDailys-th');
    var docId = ref.document().documentID;
    var trans = {'comment': 0, 'like': 0, 'picked': 0, 'id': docId, 'point': 0};
    Map scrap = {
      'id': docId,
      'uid': doc['uid'],
      'scrap': {
        'text': text,
        'writer': public ?? false ? doc['id'] : 'ไม่ระบุตัวตน',
        'timeStamp': FieldValue.serverTimestamp(),
      },
      'position': point.data
    };
    batch.setData(ref.document(docId), scrap);
    batch.setData(
        Firestore.instance
            .collection('Users/${doc['uid']}/history')
            .document(docId),
        scrap);
    batch.commit();
    FirebaseDatabase.instance.reference().child('scraps/$docId').set(trans);
    allScrap.reference().child('scraps/$docId').set(trans);
    userDb
        .reference()
        .child('users/${doc['uid']}')
        .update({'papers': user.papers - 1});
    // increaseTransaction(doc['uid'], 'written');
  }

  void updateScrapTrans(
      String field, DocumentSnapshot scrap, BuildContext context,
      {int comments}) async {
    Map<String, List> history = {};
    history['like'] = await cacheHistory.readOnlyId(field: 'like') ?? [];
    history['picked'] = await cacheHistory.readOnlyId(field: 'picked') ?? [];
    final uid = await prov.Provider.of(context).auth.currentUser();
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    var defaultDb = FirebaseDatabase.instance;
    var userDb = FirebaseDatabase(app: db.userTransact);
    var ref = 'scraps/${scrap.documentID}';

    if (history[field].contains(scrap.documentID)) {
      cacheHistory.removeHistory(field, scrap.documentID);
      scrapAll.reference().child(ref).once().then((mutableData) {
        defaultDb.reference().child(ref).update({
          field: mutableData.value[field] + 1,
          'point': field == 'like'
              ? mutableData.value['point'] + 1
              : mutableData.value['point'] + 3
        });
        scrapAll.reference().child(ref).update({
          field: mutableData.value[field] + 1,
          'point': field == 'like'
              ? mutableData.value['point'] + 1
              : mutableData.value['point'] + 3
        });
      });

      userDb.reference().child('users/${scrap['uid']}/att').once().then(
          (data) => userDb
              .reference()
              .child('users/${scrap['uid']}/att')
              .update(
                  {'att': field == 'like' ? data.value - 1 : data.value - 3}));

      if (field == 'like')
        fcm.unsubscribeFromTopic(scrap.documentID);
      else
        pickScrap(scrap.data, uid, cancel: true);
    } else {
      cacheHistory.addHistory(scrap, field: field, comments: comments);
      defaultDb.reference().child(ref).once().then((mutableData) {
        defaultDb.reference().child(ref).update({
          field: mutableData.value[field] - 1,
          'point': field == 'like'
              ? mutableData.value['point'] - 1
              : mutableData.value['point'] - 3
        });
        scrapAll.reference().child(ref).update({
          field: mutableData.value[field] - 1,
          'point': field == 'like'
              ? mutableData.value['point'] - 1
              : mutableData.value['point'] - 3
        });
      });
      userDb.reference().child('users/${scrap['uid']}/att').once().then(
          (data) => userDb
              .reference()
              .child('users/${scrap['uid']}/att')
              .update(
                  {'att': field == 'like' ? data.value + 1 : data.value + 3}));

      if (field == 'like')
        fcm.subscribeToTopic(scrap.documentID);
      else
        pickScrap(scrap.data, uid);
    }
    // } else {
    //   toast('แสครปนี้ย่อยสลายแล้ว');
    // }
  }

  pickScrap(Map scrap, String uid, {bool cancel = false}) {
    if (cancel) {
      Firestore.instance
          .collection('Users')
          .document(uid)
          .collection('scrapCollection')
          .document(scrap['id'])
          .delete();
    } else {
      scrap['picker'] = uid;
      scrap['timeStamp'] = FieldValue.serverTimestamp();
      Firestore.instance
          .collection('Users')
          .document(uid)
          .collection('scrapCollection')
          .document(scrap['id'])
          .setData(scrap);
    }
  }

  resetScrap(BuildContext context, {@required String uid}) async {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var userDb = FirebaseDatabase(app: db.userTransact);
    await userDb.reference().child('users/$uid').update({'papers': 15});
    toast('คุณได้รับกระดาษเพิ่มแล้ว');
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
        timeInSecForIos: 1,
        backgroundColor: Colors.white60,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}

final scrap = Scraps();
