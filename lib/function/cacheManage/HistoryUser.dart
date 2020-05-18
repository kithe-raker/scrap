import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<void> initHistory() async {
    final file = await _localFile;
    Map userData = {'like': [], 'picked': [], 'comment': []};
    await file.writeAsString(json.encode(userData));
  }

  Future<Map> read() async {
    final file = await _localFile;
    Map data = await json.decode(await file.readAsString());
    return data;
  }

  Future<List> readHistory({@required String field}) async {
    var now = DateTime.now();
    Map data = await read();
    List histList = data['$field'] ?? [];
    if (histList.length > 0)
      histList.removeWhere((hist) =>
          now.difference(DateTime.parse(hist['timeStamp'])).inHours > 24);
    return histList;
  }

  Future<List> readOnlyId({@required String field}) async {
    List listId = [];
    List data = await readHistory(field: field);
    data.forEach((element) => listId.add(element['id']));
    return listId;
  }

  Future<void> addHistory(DocumentSnapshot doc,
      {@required String field, int comments}) async {
    final file = await _localFile;
    var map = await read();
    var cache = comments != null
        ? {
            'id': doc.documentID,
            'comments': comments,
            'text': doc['scrap']['text'],
            'writer': doc['scrap']['writer'],
            'when': DateFormat('yyyyMMdd HH:mm:ss').format(DateTime.now()),
            'timeStamp': DateFormat('yyyyMMdd HH:mm:ss')
                .format(doc['scrap']['time'].toDate())
          }
        : {
            'id': doc.documentID,
            'timeStamp': DateFormat('yyyyMMdd HH:mm:ss')
                .format(doc['scrap']['time'].toDate())
          };
    map[field].add(cache);
    await file.writeAsString(json.encode(map));
  }

  updateFollowingScrap(String id, int comments) async {
    final file = await _localFile;
    var map = await read();
    var following = await readHistory(field: 'like');
    var scrap = following.firstWhere((scp) => scp['id'] == id);
    following.removeWhere((scp) => scp['id'] == id);
    scrap['comments'] = comments;
    following.add(scrap);
    map['like'] = following;
    await file.writeAsString(json.encode(map));
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
}

final cacheHistory = HistoryUser();
