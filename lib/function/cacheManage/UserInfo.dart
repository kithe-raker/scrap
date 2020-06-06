import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class UserInfo {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/userInfo.txt');
  }

  Future<bool> fileExist() async {
    final file = await _localFile;
    return file.exists();
  }

  Future<void> initSignIn(
      {@required String region, @required String phone}) async {
    final file = await _localFile;
    Map userData = {'region': region, 'phone': phone};
    await file.writeAsString(json.encode(userData));
  }

  Future<void> initUserInfo({@required Map doc}) async {
    final file = await _localFile;
    String immPath = await storeImage(doc['img']);
    Map userData = {
      'img': immPath,
      'imgUrl': doc['img'],
      'id': doc['id'],
      'phone': doc['phone'],
      'status': doc['status'],
      'region': doc['region'],
      'promise': false,
      'first': true
    };
    await file.writeAsString(json.encode(userData));
  }

  Future<void> promiseUser() async {
    final file = await _localFile;
    var data = await readContents();
    data['promise'] = true;
    await file.writeAsString(json.encode(data));
  }

  updateFirstStatus() async {
    final file = await _localFile;
    var data = await readContents();
    data['first'] = false;
    await file.writeAsString(json.encode(data));
  }

  Future<void> updateInfo(Map data) async {
    final file = await _localFile;
    var cache = await readContents();
    data.forEach((key, value) => cache[key] = value);
    await file.writeAsString(json.encode(cache));
  }

  Future<Map> readContents() async {
    final file = await _localFile;
    Map data = json.decode(await file.readAsString());
    return data;
  }

  Future<void> editProImage(String newUrl) async {
    final file = await _localFile;
    var data = await readContents();
    data['img'] = newUrl;
    await file.writeAsString(json.encode(data));
  }

  Future<String> storeImage(String url) async {
    var response = await get(url);
    var now = DateTime.now().toIso8601String();
    var documentDirectory = await _localPath;
    var filePathAndName = documentDirectory + '/$now.jpg';
    File file2 = new File(filePathAndName);
    file2.writeAsBytesSync(response.bodyBytes);
    return file2.uri.path;
  }

  Future<void> deleteFile() async {
    final file = await _localFile;
    var data = await readContents();
    await File(data['img']).delete();
    await file.delete();
  }
}

final userinfo = UserInfo();
