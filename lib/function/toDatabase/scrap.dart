import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';

class Scraps {
  throwTo(BuildContext context,
      {@required String uid,
      @required String writer,
      @required String thrownUID,
      @required String text}) {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var userDb = FirebaseDatabase(app: db.userTransact);
    final user = Provider.of<UserData>(context, listen: false);
    DateTime now = DateTime.now();
    String time = DateFormat('Hm').format(now);
    String date = DateFormat('d/M/y').format(now);
    Firestore.instance
        .collection('Users')
        .document(thrownUID)
        .collection('scraps')
        .document('recently')
        .setData({
      'id': FieldValue.arrayUnion([uid]),
      'scraps': {
        uid: FieldValue.arrayUnion([
          {'text': text, 'writer': writer, 'time': now}
        ])
      }
    }, merge: true);
    userDb.reference().child('users/$uid').update({'papers': user.papers - 1});
    notifaication(thrownUID, date, time, writer);
    updateHistory(uid, thrownUID);
    increaseTransaction(uid, 'written');
    increaseTransaction(thrownUID, 'threw');
  }

  updateHistory(String uid, String thrown) {
    Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document('searchHist')
        .updateData({
      'history': FieldValue.arrayUnion([thrown])
    });
  }

  notifaication(String who, String date, String time, String writer) {
    Firestore.instance.collection('Notifications').add({'uid': who});
    Firestore.instance
        .collection('Users')
        .document(who)
        .collection('notification')
        .add({
      'writer': writer,
      'date': date,
      'time': time,
      'timeStamp': FieldValue.serverTimestamp()
    });
  }

  increaseTransaction(String uid, String key) {
    // Firestore.instance
    //     .collection('Users')
    //     .document(uid)
    //     .collection('info')
    //     .document(uid)
    //     .updateData({key: FieldValue.increment(1)});
    //chage this fucking function too
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

  toHistory(String uid, String docID, String text) {
    DateTime now = DateTime.now();
    String date = DateFormat('y,M,d').format(now);
    String dateRef = DateFormat('yyyyMMdd').format(now);
    Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('history')
        .document(date)
        .setData({
      'scrapID': FieldValue.arrayUnion([docID]),
      docID: 0,
      'date': dateRef,
      'Scraps': {
        docID: {'text': text, 'time': now}
      }
    }, merge: true);
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
