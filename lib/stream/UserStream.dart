import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';

class UserStream {
  BehaviorSubject<int> paperSubject = BehaviorSubject<int>();
  BehaviorSubject<int> pickSubject = BehaviorSubject<int>();
  BehaviorSubject<double> attSubject = BehaviorSubject<double>();
  BehaviorSubject<int> thrownSubject = BehaviorSubject<int>();

  int get papers => paperSubject.value;
  int get pick => pickSubject.value;
  double get att => attSubject.value;
  int get thrown => thrownSubject.value;

  void initTransactionStream(BuildContext context) {
    final user = Provider.of<UserData>(context, listen: false);
    final db = Provider.of<RealtimeDBProvider>(context, listen: false);
    var userDb = FirebaseDatabase(app: db.userTransact);
    var ref = userDb.reference().child('users/${user.uid}');
    ref
        .child('papers')
        .onValue
        .listen((event) => paperSubject.add(event.snapshot.value));
    ref
        .child('pick')
        .onValue
        .listen((event) => pickSubject.add(event.snapshot.value));
    ref
        .child('thrown')
        .onValue
        .listen((event) => thrownSubject.add(event.snapshot.value));
    ref
        .child('att')
        .onValue
        .listen((event) => attSubject.add(event.snapshot.value.toDouble()));
  }
}

final userStream = UserStream();
