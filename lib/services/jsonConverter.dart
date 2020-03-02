import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class JsonConverter {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/friends.txt');
  }

  Future<File> writeContent({@required List listm}) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString(json.encode(listm));
  }

  Future<List> searchContents({@required String id}) async {
    try {
      final file = await _localFile;
      List<Map> listm = [];
      // Read the fil
      String contents = await file.readAsString();
      json
          .decode(contents)
          .forEach((map) => map['id'].contains(id) ? listm.add(map) : null);
      return listm;
    } catch (e) {
      // If there is an error reading, return a default String
      return [];
    }
  }

  Future<List> readContents() async {
    try {
      final file = await _localFile;
      List<Map> listm = [];
      // Read the fil
      String contents = await file.readAsString();
      json.decode(contents).forEach((map) => listm.add(map));
      return listm;
    } catch (e) {
      // If there is an error reading, return a default String
      return [];
    }
  }

  Future<List> addContent({String id, String uid}) async {
    try {
      List<Map> list = await readContents();
      list.add({'uid': uid, 'id': id});
      writeContent(listm: list);
      return list;
    } catch (e) {
      return [];
    }
  }

  Future<List> removeContent({String key, String where}) async {
    try {
      List<Map> list = await readContents();
      list.removeWhere((data) => data[key] == where);
      writeContent(listm: list);
      return list;
    } catch (e) {
      return [];
    }
  }
}
