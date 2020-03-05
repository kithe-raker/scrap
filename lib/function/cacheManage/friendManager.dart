import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrap/services/jsonConverter.dart';

class FriendManager {
  JsonConverter jsonConverter = JsonConverter();

  initFriend(String uid) async {
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document('friends')
        .get()
        .then((doc) async {
      await updateData(doc['friendList'] ?? []);
    });
  }

  updateData(List friends) async {
    List fID = [];
    for (String uid in friends) {
      await Firestore.instance
          .collection('Users')
          .document(uid)
          .get()
          .then((doc) async {
        await getInfo(fID, uid, doc.data['id']);
      });
    }
    await jsonConverter.writeContent(listm: fID);
  }

  getInfo(List list, String uid, String name) async {
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document(uid)
        .get()
        .then((doc) async {
      list.add(
          {'id': name, 'img': doc.data['img'], 'join': doc.data['createdDay']});
    });
  }
}
