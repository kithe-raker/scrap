import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../provider/authen_provider.dart';

class CacheUserInfo {
  File jsonFile;
  Directory dir;
  String fileName = "userInfo";
  bool fileExists = false;
  Map<String, String > fileContent;

  hasFile(String uid) async {
  Directory _directory = await getApplicationDocumentsDirectory();
  jsonFile = File(_directory.path + "/" + fileName + "_" + uid);
  fileExists = jsonFile.existsSync();
  return fileExists;
  }

  getUserInfo(){
    fileContent = jsonDecode(jsonFile.readAsStringSync());
    return fileContent;
  }


  newFileUserInfo(String uid){
    Map<String,String> _content;
    Firestore.instance
    .collection("User")
    .document("th")
    .collection("users")
    .document(uid)
    .get()
    .then((value){
      _content = {
        "uid": uid,
        "pName": value['pName'],
        "img": value['img'],
        "birthday": value['birthday'],
        "gender": value['gender']
      };
    });
    
    jsonFile.createSync();
    jsonFile.writeAsStringSync(jsonEncode(_content));
    getUserInfo();
  }

  //first call func---------------------------
  userInfo(String uid){
    bool _hasFile = hasFile(uid);
    if(_hasFile == false)
      newFileUserInfo(uid);
    else
      getUserInfo();
  }
  //------------------------------------------

}