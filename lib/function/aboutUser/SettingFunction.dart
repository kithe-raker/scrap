import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:scrap/Page/mainstream.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/function/others/ResizeImage.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';

class SettingFunction {
  PublishSubject<bool> loading = PublishSubject();
  setAllowThrow(BuildContext context, bool value) {
    final user = Provider.of<UserData>(context, listen: false);
    final db = Provider.of<RealtimeDB>(context, listen: false);
    final userDB = FirebaseDatabase(app: db.userTransact);
    userDB.reference().child('users/${user.uid}').update({'allowThrow': value});
  }

  updateProfile(BuildContext context,
      {@required String id, @required status, File image}) async {
    loading.add(true);
    final user = Provider.of<UserData>(context, listen: false);
    var batch = fireStore.batch();
    var now = DateTime.now().millisecondsSinceEpoch;
    var ref = fireStore
        .collection('Users/${user.region}/users/${user.uid}/info')
        .document(user.uid);
    if (image != null) {
      await File(user.img).delete();
      var resized = await resize.resize(image: image);
      var url = await resize.uploadImg(
          img: resized, imageName: '${user.uid}/${user.uid}_$now');
      batch.updateData(ref, {
        'imgList': FieldValue.arrayUnion([url])
      });
      batch.updateData(
          fireStore.collection('Users/${user.region}/users').document(user.uid),
          {'img': url, 'id': id, 'status': status});
      var path = await userinfo.storeImage(url);
      await userinfo
          .updateInfo({'id': id, 'status': status, 'img': path, 'imgUrl': url});
    } else {
      batch.updateData(
          fireStore.collection('Users/${user.region}/users').document(user.uid),
          {'id': id, 'status': status});
      await userinfo.updateInfo({'id': id, 'status': status});
    }
    batch.updateData(
        fireStore.collection('Account').document(user.uid), {'id': id});
    await batch.commit();
    loading.add(false);
    nav.pushReplacement(context, MainStream(initPage: 3));
  }
}

final setting = SettingFunction();
