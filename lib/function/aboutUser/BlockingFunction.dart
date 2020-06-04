import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/FriendsCache.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/widget/Toast.dart';

class BlockingFunction {
  Future<void> blockUser(BuildContext context,
      {@required String otherUid,
      @required bool public,
      DocumentSnapshot scrap}) async {
    final user = Provider.of<UserData>(context, listen: false);
    final batch = fireStore.batch();
    if (public) {
      if (await cacheFriends.isBlocking(otherUid)) {
        toast.toast('คุณปิดกั้นการปาผู้ใช้รายนี้แล้ว');
      } else {
        cacheFriends.addBlockUsers(blocked: [otherUid]);
        await fireStore
            .document(
                'Users/${user.region}/users/${user.uid}/blocks/blockedUsers')
            .setData({
          'list': FieldValue.arrayUnion([otherUid])
        }, merge: true);
        toast.toast('ปิดกั้นการปาจากผู้ใช้รายนี้แล้ว');
      }
    } else {
      batch.setData(
          fireStore.document(
              'Users/${user.region}/users/${user.uid}/blocks/blockedScraps'),
          {
            'list': FieldValue.arrayUnion([otherUid])
          },
          merge: true);
      batch.setData(
          fireStore
              .collection(
                  'Users/${user.region}/users/${user.uid}/blockedScraps')
              .document(otherUid),
          scrap.data);
      await batch.commit();
      toast.toast('ปิดกั้นการปาจากผู้ใช้รายนี้แล้ว');
    }
  }

  Future<void> unBlockUser(BuildContext context,
      {@required String otherUid, @required bool public}) async {
    final user = Provider.of<UserData>(context, listen: false);
    final batch = fireStore.batch();
    if (public) {
      cacheFriends.unBlock(uid: otherUid);
      await fireStore
          .document(
              'Users/${user.region}/users/${user.uid}/blocks/blockedUsers')
          .setData({
        'list': FieldValue.arrayRemove([otherUid])
      }, merge: true);
      toast.toast('ยกเลิกการปิดกั้นการปาจากผู้ใช้รายนี้แล้ว');
    } else {
      batch.setData(
          fireStore.document(
              'Users/${user.region}/users/${user.uid}/blocks/blockedScraps'),
          {
            'list': FieldValue.arrayRemove([otherUid])
          },
          merge: true);
      batch.delete(fireStore
          .collection('Users/${user.region}/users/${user.uid}/blockedScraps')
          .document(otherUid));
      await batch.commit();
      toast.toast('ยกเลิกการปิดกั้นการปาแล้ว');
    }
  }
}

final blocking = BlockingFunction();
