import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrap/function/authServices/authService.dart';

class CacheUserInfo {
  File jsonFile;
  Directory dir;
  String fileName = "userInfo";
  bool fileExists = false;
  var fileContent;

  Future<bool> hasFile() async {
    Directory _directory = await getApplicationDocumentsDirectory();
    jsonFile = File(_directory.path + "/" + fileName);
    fileExists = jsonFile.existsSync();
    return fileExists;
  }

  Future<bool> userDataExist(String uid) async {
    bool fileExist = await hasFile();
    Map data = {'uid': ''};
    if (fileExist) data = await getUserInfo();
    return fileExist && data['uid'] == uid;
  }

  getUserInfo() async {
    Directory _directory = await getApplicationDocumentsDirectory();
    jsonFile = File(_directory.path + "/" + fileName);
    fileContent = jsonDecode(jsonFile.readAsStringSync());
    return fileContent;
  }

  newFileUserInfo(String uid, {Map info}) async {
    Directory _directory = await getApplicationDocumentsDirectory();
    jsonFile = File(_directory.path + "/" + fileName);
    Map _content;
    info == null
        ? await Firestore.instance
            .collection("User")
            .document("th")
            .collection("users")
            .document(uid)
            .get()
            .then((value) {
            _content = {
              "uid": uid,
              "pName": value['pName'],
              "img": value['img'],
              "birthday": value['birthday'],
              "gender": value['gender'].toString(),
              'region': value['region']
            };
          })
        : _content = info;

    jsonFile.createSync();
    jsonFile.writeAsStringSync(jsonEncode(_content));
  }

  Future<bool> documentExist(String uid, {String region}) async {
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
        await newFileUserInfo(uid, info: {
          "uid": uid,
          "pName": doc['pName'],
          "img": doc['img'],
          "birthday": doc['birthday'].toString(),
          "gender": doc['gender'],
          'region': doc['region']
        });
    }
    return (doc?.exists ?? false) && reg != '' && reg != null;
  }

  //first call func---------------------------
  userInfo(String uid, {Map info}) async {
    bool _hasFile = await hasFile();
    if (_hasFile == false)
      newFileUserInfo(uid, info: info);
    else
      getUserInfo();
  }
  //------------------------------------------

}