import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';

class SettingFunction {
  setAllowThrow(BuildContext context, bool value) {
    final user = Provider.of<UserData>(context, listen: false);
    final db = Provider.of<RealtimeDB>(context, listen: false);
    final userDB = FirebaseDatabase(app: db.userTransact);
    userDB.reference().child('users/${user.uid}').update({'allowThrow': value});
  }
}

final setting = SettingFunction();
