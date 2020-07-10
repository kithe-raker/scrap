import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class OtherCache {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/other.txt');
  }

  Future<void> initFile() async {
    final file = await _localFile;
    var now = DateTime.now();
    var cache = {'point': null, 'day': now.day, 'introduce': false};
    await file.writeAsString(json.encode(cache));
  }

  Future<bool> isNotIntroduce() async {
    final file = await _localFile;
    var isIntroduce;
    if (await file.exists()) {
      try {
        var cache = await json.decode(await file.readAsString());
        isIntroduce = cache['introduce'];
      } catch (e) {
        await file.delete();
        await initFile();
      }
    } else
      await initFile();
    return isIntroduce == null || !isIntroduce;
  }

  Future<void> finishIntroduce() async {
    final file = await _localFile;
    var cache = await json.decode(await file.readAsString());
    cache['introduce'] = true;
    await file.writeAsString(json.encode(cache));
  }

  Future<Map> readFile() async {
    final file = await _localFile;
    Map data = await json.decode(await file.readAsString());
    if (data == null) initFile();
    return data;
  }

  Future<bool> exist() async {
    final file = await _localFile;
    return file.exists();
  }

  Future<Map<String, dynamic>> recentlyPoint() async {
    final file = await _localFile;
    var map;
    var now = DateTime.now();
    if (await exist()) {
      Map data = await json.decode(await file.readAsString());
      if (data['day'] == now.day) map = data;
    } else
      await initFile();
    return map;
  }

  Future<void> updateHot({@required double point, @required String id}) async {
    final file = await _localFile;
    var cache = await readFile();
    var now = DateTime.now();
    cache['point'] = point;
    cache['id'] = id;
    cache['day'] = now.day;
    await file.writeAsString(json.encode(cache));
  }

  Future<void> updateRecent({@required int time, @required String id}) async {
    final file = await _localFile;
    var cache = await readFile();
    var now = DateTime.now();
    cache['recentTime'] = time;
    cache['recentScrapId'] = id;
    cache['day'] = now.day;
    await file.writeAsString(json.encode(cache));
  }
}

final cacheOther = OtherCache();
