import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:scrap/Page/createworld/ConfigWorld.dart';
import 'package:scrap/function/authServices/authService.dart';
import 'package:scrap/function/others/resizeImage.dart';
import 'package:scrap/method/Navigator.dart';
import 'package:scrap/provider/createWorldProvider.dart';

class WorldFunction {
  final nav = Nav();

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
  toConfigWorld(BuildContext context) async {
    load.add(true);
    final worldInfo = Provider.of<CreateWorldProvider>(context, listen: false);
    if (await nameUnused(worldInfo.worldName) && worldInfo?.image != null) {
      nav.push(context, ConfigWorld());
      load.add(false);
    } else {
      worldInfo?.image == null
          ? warn('เลือกรูปสำหรับโลกของคุณ', context)
          : warn('มีโลกใบอื่นใช้ชื่อแล้ว', context);
    }
  }

  ///Create World by pass value of [permission] is the permission for allow writer
  ///
  ///[theme] is which map's theme owner wanted
  ///
  ///[writer] who allow to write
  createWorld(BuildContext context,
      {@required String theme,
      @required int permission,
      @required List writer}) async {
    load.add(true);
    final worldInfo = Provider.of<CreateWorldProvider>(context, listen: false);
    var uid = await authService.getuid();
    var batch = fireStore.batch();
    var id = Firestore.instance.collection('World').document().documentID;
    File resizeImage = await resize.resize(image: worldInfo.image);
    String picUrl =
        await resize.uploadImg(img: resizeImage, imageName: id + '_world');
    writer.add(uid);
    batch.setData(fireStore.collection('World').document(id), {
      'name': worldInfo.worldName,
      'description': worldInfo.descript,
      'theme': theme,
      'img': picUrl,
      'permission': permission,
      'owner': uid
    });
    batch.setData(
        fireStore
            .collection('World')
            .document(id)
            .collection('config')
            .document('writers'),
        {'writer': FieldValue.arrayUnion(writer), 'owner': uid, 'id': id});
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
