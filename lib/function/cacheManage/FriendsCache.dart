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
    Map userData = {'following': [], 'recently': [], 'blockedUsers': []};
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

  Future<void> addBlockUsers({@required List blocked}) async {
    final file = await _localFile;
    var data = await read();
    data['blockedUsers'].addAll(blocked);
    await file.writeAsString(json.encode(data));
  }

  Future unBlock({@required String uid}) async {
    final file = await _localFile;
    var data = await read();
    data['blockedUsers'].remove(uid);
    await file.writeAsString(json.encode(data));
  }

  Future<void> addFollowing({@required List following}) async {
    final file = await _localFile;
    var data = await read();
    data['following'].addAll(following);
    await file.writeAsString(json.encode(data));
  }

  Future<void> unFollowing({@required String unFollowUid}) async {
    final file = await _localFile;
    var data = await read();
    data['following'].removeWhere((uid) => uid == unFollowUid);
    await file.writeAsString(json.encode(data));
  }

  Future<void> addRecently(
      {@required String id,
      @required String img,
      @required String status,
      @required String thrownUid,
      @required String ref}) async {
    final file = await _localFile;
    var data = await read();
    List recently = data['recently'];
    if (recently.length > 3) recently.remove(recently.first);
    var sameUid = recently.where((user) => user['uid'] == thrownUid).toList();
    if (sameUid.length < 1)
      recently.add({
        'id': id,
        'img': img,
        'status': status,
        'uid': thrownUid,
        'ref': ref
      });
    data['recently'] = recently;
    await file.writeAsString(json.encode(data));
  }

  Future<List> getBlockedUser() async {
    var list = await read();
    return list['blockedUsers'];
  }

  Future<List> getRecently() async {
    var list = await read();
    return list['recently'];
  }

  Future<List> getFollowing() async {
    var list = await read();
    return list['following'] ?? [];
  }

  Future<List> getRandomFollowing() async {
    var list = await getFollowing();
    List randomList = [];
    if (list.length > 3) {
      for (var i = 0; i < 3; i++) {
        var index = random.nextInt(list.length);
        randomList.add(list[index]);
        list.remove(list[index]);
      }
    } else {
      randomList.addAll(list);
    }
    return randomList;
  }

  Future<bool> isBlocking(String uid) async {
    var list = await getBlockedUser();
    return list.contains(uid);
  }

  Future<void> deleteFile() async {
    final file = await _localFile;
    await file.delete();
  }
}

final cacheFriends = FriendsCache();
