import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class UserInfo {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/userInfo.txt');
  }

  Future<void> writeContent({@required DocumentSnapshot doc}) async {
    final file = await _localFile;
    Map userData = {'img': doc.data['img']};
    await file.writeAsString(json.encode(userData));
  }

  Future<Map> readContents() async {
    final file = await _localFile;
    Map data = json.decode(await file.readAsString());
    return data;
  }
}

final userinfo = UserInfo();
