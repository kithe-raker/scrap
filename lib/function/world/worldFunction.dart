import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:scrap/Page/createworld/ConfigWorld.dart';
import 'package:scrap/function/authServices/authService.dart';
import 'package:scrap/function/others/resizeImage.dart';

class WorldFunction {
  ///[load] is varieble that use for tell the widget whether
  ///current function is in process or not
  PublishSubject<bool> load = PublishSubject();

  ///Check if the world's name has been used, By pass
  ///world'name is [name]
  Future<bool> nameUnused(String name) async {
    var doc = await Firestore.instance
        .collection('World')
        .where('name', isEqualTo: name)
        .limit(1)
        .getDocuments();
    return doc.documents.length < 1;
  }

  ///Validate world's name before push to Config world
  toConfigWorld(String descript, String worldName, File image,
      BuildContext context) async {
    load.add(true);
    if (await nameUnused(worldName)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfigWorld(
              descript: descript, worldName: worldName, image: image),
        ),
      );
      load.add(false);
    } else {
      warn('มีโลกใบอื่นใช้ชื่อแล้ว', context);
    }
  }

  ///Create World by pass value of [permission] is the permission for allow writer
  ///
  ///[theme] is which map's theme owner wanted
  ///
  ///[writer] who allow to write
  createWorld(String descript, String worldName, File image,
      {@required String theme,
      @required int permission,
      @required List writer}) async {
    load.add(true);
    var uid = await authService.getuid();
    var batch = fireStore.batch();
    var id = Firestore.instance.collection('World').document().documentID;
    File resizeImage = await resize.resize(image: image);
    String picUrl =
        await resize.uploadImg(img: resizeImage, imageName: id + '_world');
    writer.add(uid);
    batch.setData(fireStore.collection('World').document(id), {
      'name': worldName,
      'description': descript,
      'theme': theme,
      'img': picUrl,
      'permission': permission,
      'writer': FieldValue.arrayUnion(writer),
      'owner': uid
    });
    batch.updateData(
        fireStore
            .collection('User')
            .document('th')
            .collection('users')
            .document(uid),
        {
          'worldOwn': FieldValue.arrayUnion([id])
        });
    await batch.commit();
    load.add(false);
  }

  ///warning dialog auto set [load] to false ,When was called
  warn(String warning, BuildContext context) {
    load.add(false);
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(warning),
                  RaisedButton(
                      child: Text('ok'),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          );
        });
  }
}

final worldFunction = WorldFunction();
