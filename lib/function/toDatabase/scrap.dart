import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class Scraps {
  throwTo(
      {@required String uid,
      @required String writer,
      @required String thrownUID,
      @required String text}) {
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
    update(now.millisecondsSinceEpoch, uid);
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
    Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document(uid)
        .updateData({key: FieldValue.increment(1)});
  }

  binScrap(String text, bool public, DocumentSnapshot doc) async {
    GeoFirePoint point;
    await Geolocator().getCurrentPosition().then((value) => point =
        Geoflutterfire()
            .point(latitude: value.latitude, longitude: value.longitude));
    Firestore.instance
        .collection('Scraps')
        .document('hatyai')
        .collection('scrapsPosition')
        .add({}).then((value) {
      Firestore.instance
          .collection('Scraps')
          .document('hatyai')
          .collection('scrapsPosition')
          .document(value.documentID)
          .updateData({
        'id': value.documentID,
        'uid': doc['uid'],
        'scrap': {
          'text': text,
          'user': public ?? false ? doc['id'] : 'ไม่ระบุตัวตน',
          'timeStamp': FieldValue.serverTimestamp(),
        },
        'position': point.data
      });
      update(value.documentID, doc['uid']);
      toHistory(doc['uid'], value.documentID, text);
    });
    increaseTransaction(doc['uid'], 'written');
  }

  update(dynamic id, String uid) {
    Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document(uid)
        .updateData({
      'scraps': FieldValue.arrayUnion([id])
    });
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

  resetScrap(String uid) async {
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document(uid)
        .updateData({'scraps': []});
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
