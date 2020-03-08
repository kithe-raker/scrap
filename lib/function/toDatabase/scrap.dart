import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Scraps {
  throwTo(
      {@required String uid,
      @required String writer,
      @required String thrownID,
      @required String text,
      @required bool public}) async {
    DateTime now = DateTime.now();
    String time = DateFormat('Hm').format(now);
    String date = DateFormat('d/M/y').format(now);
    await Firestore.instance
        .collection('Users')
        .document(thrownID)
        .collection('scraps')
        .document('recently')
        .setData({
      'id': FieldValue.arrayUnion([uid]),
      'scraps': {
        uid: FieldValue.arrayUnion([
          {
            'text': text,
            'writer': public ?? false ? writer : 'ไม่ระบุตัวตน',
            'time': '$time $date'
          }
        ])
      }
    }, merge: true);
    await notifaication(thrownID, date, time, public, writer);
    await updateHistory(uid, thrownID);
    await increaseTransaction(uid, 'written');
    await increaseTransaction(thrownID, 'threw');
  }

  updateHistory(String uid, String thrown) async {
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document('searchHist')
        .updateData({
      'history': FieldValue.arrayUnion([thrown])
    });
  }

  notifaication(
      String who, String date, String time, bool public, String writer) async {
    await Firestore.instance.collection('Notifications').add({'uid': who});
    await Firestore.instance
        .collection('Users')
        .document(who)
        .collection('notification')
        .add({
      'writer': public ?? false ? writer : 'ไม่ระบุตัวตน',
      'date': date,
      'time': time
    });
  }

  increaseTransaction(String uid, String key) async {
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document(uid)
        .get()
        .then((value) => Firestore.instance
            .collection('Users')
            .document(uid)
            .collection('info')
            .document(uid)
            .updateData(
                {key: value?.data[key] == null ? 1 : ++value.data[key]}));
  }

  // toHistory(String uid)async{
  //   await Firestore.instance.collection('Users').document(uid).collection('history').document()
  // }
}
