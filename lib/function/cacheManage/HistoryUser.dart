import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrap/models/ScrapModel.dart';

class HistoryUser {
  // For your reference print the AppDoc directory
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/userHistory.txt');
  }

  Future<File> get localFile async {
    final path = await _localPath;
    return File('$path/userHistory.txt');
  }

  Future<void> initHistory() async {
    final file = await _localFile;
    Map userData = {
      'like': [],
      'picked': [],
      'comment': [],
      'read': [],
      'burn': [],
      'commentId': {}
    };
    await file.writeAsString(json.encode(userData));
  }

  Future<Map> read() async {
    final file = await _localFile;
    Map data = await json.decode(await file.readAsString());
    return data;
  }

  Future<List> readHistory({@required String field}) async {
    Map data = await read();
    List histList = data['$field'] ?? [];
    return histList;
  }

  Future<List> readOnlyId({@required String field}) async {
    List listId = [];
    List data = await readHistory(field: field);
    data.forEach((element) => listId.add(element['id']));
    return listId;
  }

  Future<Map> getCommented() async {
    var data = await read();
    Map cache = data['commentId'] ?? {};
    return cache;
  }

  Future<void> addBurn({@required String id}) async {
    final file = await _localFile;
    var now = DateTime.now();
    Map data = await read();
    List histList = data['burn'] ?? [];
    if (histList.length > 0) {
      histList.removeWhere((hist) =>
          now.difference(DateTime.parse(hist['timeStamp'])).inHours > 24);
    }
    histList.add({
      'id': id,
      'timeStamp': DateFormat('yyyyMMdd HH:mm:ss').format(DateTime.now())
    });
    data['burn'] = histList;
    await file.writeAsString(json.encode(data));
  }

  Future<void> addHistory(ScrapModel scrap, DocumentSnapshot doc,
      {@required String field, int comments}) async {
    final file = await _localFile;
    var map = await read();
    var scrapId = scrap?.scrapId ?? doc.documentID;
    var timeStamp = scrap?.litteredTime ?? doc['scrap']['timeStamp'].toDate();
    var cache = comments != null
        ? {
            'id': scrapId,
            'timeStamp': DateFormat('yyyyMMdd HH:mm:ss').format(timeStamp),
            'when': DateFormat('yyyyMMdd HH:mm:ss').format(DateTime.now()),
            'comments': comments
          }
        : {
            'id': scrapId,
            'timeStamp': DateFormat('yyyyMMdd HH:mm:ss').format(timeStamp)
          };
    map[field].add(cache);
    await file.writeAsString(json.encode(map));
  }

  Future<void> addReadScrap(DocumentSnapshot doc) async {
    final file = await _localFile;
    var now = DateTime.now();
    var cache = await read();
    List readScrap = cache['read'];
    readScrap.removeWhere((scrap) =>
        now.difference(DateTime.parse(scrap['timeStamp'])).inHours > 24);
    readScrap.add({
      'id': doc.documentID,
      'timeStamp': DateFormat('yyyyMMdd HH:mm:ss')
          .format(doc['scrap']['timeStamp'].toDate())
    });
    cache['read'] = readScrap;
    await file.writeAsString(json.encode(cache));
  }

  Future<void> addCommentedScrap(String scrapId, {@required String id}) async {
    final file = await _localFile;
    var data = await read();
    Map cache = data['commentId'] ?? {};
    cache[scrapId] = id;
    data['commentId'] = cache;
    await file.writeAsString(json.encode(data));
  }

  Future<List> getReadScrap() async {
    List scraps = [];
    var cache = await read();
    List readCache = cache['read'];
    if (readCache.length > 0)
      readCache.forEach((data) => scraps.add(data['id']));
    return scraps;
  }

  updateFollowingScrap(String id, int comments, DateTime scrapTime) async {
    final file = await _localFile;
    var map = await read();
    var following = await readHistory(field: 'picked');
    var scraps = following.where((scp) => scp['id'] == id).toList();
    if (scraps.length > 0) {
      var scrap = scraps[0];
      following.removeWhere((scp) => scp['id'] == id);
      scrap['comments'] = comments;
      following.add(scrap);
      map['picked'] = following;
      await file.writeAsString(json.encode(map));
    } else {
      following.add({
        'id': id,
        'timeStamp': DateFormat('yyyyMMdd HH:mm:ss').format(scrapTime),
        'when': DateFormat('yyyyMMdd HH:mm:ss').format(DateTime.now()),
        'comments': comments
      });
      map['picked'] = following;
      await file.writeAsString(json.encode(map));
    }
  }

  Future removeHistory(String field, String id) async {
    final file = await _localFile;
    var data = await read();
    data[field].removeWhere((hist) => hist['id'] == id);
    await file.writeAsString(json.encode(data));
  }

  Future<bool> checkContain(String id, {@required String field}) async {
    List data = await readHistory(field: field);
    var match = data.where((map) => map['id'] == id).toList();
    return match.length < 0;
  }

  Future<void> deleteFile() async {
    final file = await _localFile;
    await file.delete();
  }
}

final cacheHistory = HistoryUser();
