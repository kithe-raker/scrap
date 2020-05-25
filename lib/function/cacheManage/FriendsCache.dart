import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FriendsCache {
  final random = Random();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/friends.txt');
  }

  Future<void> intitFile() async {
    final file = await _localFile;
    Map userData = {'following': [], 'recently': []};
    await file.writeAsString(json.encode(userData));
  }

  Future<bool> exist() async {
    final file = await _localFile;
    return file.exists();
  }

  Future<Map> read() async {
    final file = await _localFile;
    var data = json.decode(await file.readAsString());
    return data;
  }

  Future<void> addFollowing({@required List following}) async {
    final file = await _localFile;
    var data = await read();
    data['following'].addAll(following);
    await file.writeAsString(json.encode(data));
  }

  Future<List> getRecently() async {
    var list = await read();
    return list['recently'];
  }

  Future<List> getFollowing() async {
    var list = await read();
    return list['following'];
  }

  Future<List> getRandomFollowing() async {
    var list = await getFollowing();
    List randomList = [];
    if (list.length > 0) {
      for (var i = 0; i < 3; i++) {
        var index = random.nextInt(list.length);
        randomList.add(list[index]);
        list.remove(list[index]);
      }
    }
    return randomList;
  }
}

final cacheFriends = FriendsCache();
