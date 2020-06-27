import 'dart:convert';
import 'dart:io';

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
      var cache = await json.decode(await file.readAsString());
      isIntroduce = cache['introduce'];
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

  Future<double> recentlyPoint() async {
    final file = await _localFile;
    double point;
    var now = DateTime.now();
    if (await exist()) {
      Map data = await json.decode(await file.readAsString());
      if (data['day'] == now.day) point = data['point'];
    } else
      await initFile();
    return point;
  }

  Future<void> update(double point) async {
    final file = await _localFile;
    var cache = await readFile();
    var now = DateTime.now();
    cache['point'] = point;
    cache['day'] = now.day;
    await file.writeAsString(json.encode(cache));
  }
}

final cacheOther = OtherCache();
