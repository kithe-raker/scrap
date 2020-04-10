import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';


class CacheUserInfo {
  File jsonFile;
  String fileName = "userInfo";
  bool fileExists = false;
  Map<String, String > fileContent;

  hasFile(String uid) async {
  Directory _directory = await getApplicationDocumentsDirectory();
  jsonFile = File(_directory.path + "/" + fileName);
  fileExists = jsonFile.existsSync();
  return fileExists;
  }

  getUserInfo()async{
    Directory _directory = await getApplicationDocumentsDirectory();
    jsonFile = File(_directory.path + "/" + fileName);
    fileContent = jsonDecode(jsonFile.readAsStringSync());
    return fileContent;
  }


  newFileUserInfo(String uid) async {
  
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

    Directory _directory = await getApplicationDocumentsDirectory();
    jsonFile = File(_directory.path + "/" + fileName);
    jsonFile.createSync();
    jsonFile.writeAsStringSync(jsonEncode(_content));
  }

  //first call func---------------------------
  userInfo(String uid){
      newFileUserInfo(uid);
      getUserInfo();
  }
  //------------------------------------------

}