import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:scrap/function/authServices/authService.dart';
import 'package:scrap/provider/authen_provider.dart';

class CacheUserInfo {
  File jsonFile;
  Directory dir;
  String fileName = "userInfo";
  bool fileExists = false;
  var fileContent;

  ///Check if there is userInfo.json in directory?
  Future<bool> hasFile() async {
    Directory _directory = await getApplicationDocumentsDirectory();
    jsonFile = File(_directory.path + "/" + fileName);
    fileExists = jsonFile.existsSync();
    return fileExists;
  }

  Future<void> deleteFile() async {
    Directory _directory = await getApplicationDocumentsDirectory();
    jsonFile = File(_directory.path + "/" + fileName);
    jsonFile.delete();
  }

  ///Check if there are user's data in userInfo.json return file.exist && uid.exist
  Future<bool> hasUserData(BuildContext context, {@required String uid}) async {
    bool fileExist = await hasFile();
    Map data = {'uid': ''};
    if (fileExist) data = await getUserInfo(context);
    return fileExist && data['uid'] == uid;
  }

  ///Get user's info from cache file return Map
  getUserInfo(BuildContext context) async {
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    Directory _directory = await getApplicationDocumentsDirectory();
    jsonFile = File(_directory.path + "/" + fileName);
    fileContent = jsonDecode(jsonFile.readAsStringSync());
    authenInfo.initUserInfo(fileContent);
    return fileContent;
  }

  ///Create new cache file
  newFileUserInfo(String uid, BuildContext context,
      {@required Map info}) async {
    Directory _directory = await getApplicationDocumentsDirectory();
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    jsonFile = File(_directory.path + "/" + fileName);
    authenInfo.initUserInfo(info);
    jsonFile.createSync();
    jsonFile.writeAsStringSync(jsonEncode(info));
  }

  ///if document exists then create new file Return doc.exists
  Future<bool> docExistsThenNewFile(String uid, BuildContext context,
      {String region}) async {
    String reg = region ?? await authService.getRegion(uid);
    var doc;
    if (reg != '' && reg != null) {
      doc = await Firestore.instance
          .collection("User")
          .document(reg)
          .collection("users")
          .document(uid)
          .get();
      if (doc.exists)
        await newFileUserInfo(uid, context, info: {
          "uid": uid,
          "pName": doc['pName'],
          "img": doc['img'],
          "birthday": doc['birthday'].toDate().toString(),
          "gender": doc['gender'],
          'region': doc['region']
        });
    }
    return (doc?.exists ?? false) && reg != '' && reg != null;
  }
}
