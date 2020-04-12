
import 'package:cloud_firestore/cloud_firestore.dart';
class UserGetWorld{
  
  getWorldList(String uid){
    List<String> _worldList;
    int _i=0;
    Firestore.instance
    .collection("Users")
    .document(uid)
    .collection("World")
    .snapshots()
    .listen((data){
      data.documents.forEach((doc) { 
         _worldList[_i] =doc.documentID;
         _i++;
      });
    });
    return _worldList;
  }

  worldListFetch(List<String> _worldList){
    List<Map<String, String>> _worldPropertiesList;
    int _i = 0;
    _worldList.forEach((element) {
      Firestore.instance
      .collection("World")
      .document(element)
      .get()
      .then((value){
        _worldPropertiesList[_i] = {
          "world_id":element,
          "name": value['name'],
          "type": value['type'],
          "about": value['about']
        };
        _i++;
      });
    });

    return _worldPropertiesList;

  }

  //first call function ---------------
  getUserWorld(String uid){
    List<String> _worldList = getWorldList(uid);
    List<Map<String, String>> _worldPropertiesList = worldListFetch(_worldList);
    return _worldPropertiesList;
  }
  //----------------------------------

}