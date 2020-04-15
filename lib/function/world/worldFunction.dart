import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrap/Page/createworld/ConfigWorld.dart';
import 'package:scrap/function/others/resizeImage.dart';

class WorldFunction {
  Future<bool> nameUnused(String name) async {
    var doc = await Firestore.instance
        .collection('World')
        .where('name', isEqualTo: name)
        .limit(1)
        .getDocuments();
    return doc.documents.length < 1;
  }

  toConfigWorld(String descript, String worldName, File image,
      BuildContext context) async {
    if (await nameUnused(worldName)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfigWorld(
              descript: descript, worldName: worldName, image: image),
        ),
      );
    } else {
      print('name already use');
    }
  }

  createWorld(String descript, String worldName, File image, String theme,
      int permission, List writer) async {
    File resizeImage = await resize.resize(image: image);
    var user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    var batch = Firestore.instance.batch();
    writer.add(uid);
    var id = Firestore.instance.collection('World').document().documentID;
    batch.setData(Firestore.instance.collection('World').document(id), {
      'name': worldName,
      'description': descript,
      'theme': theme,
      'img': '',
      'permission': permission,
      'writer': writer,
      'owner': uid
    });
    batch.updateData(
        Firestore.instance
            .collection('User')
            .document('th')
            .collection('users')
            .document(uid),
        {
          'worldOwn': FieldValue.arrayUnion([id])
        });
  }
}

final worldFunction = WorldFunction();
