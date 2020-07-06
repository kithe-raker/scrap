import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scrap/method/Globalkey.dart';

class RealtimeDBProvider extends ChangeNotifier {
  FirebaseApp _scrapAll;
  FirebaseApp _userTransact;
  FirebaseApp _placeAll;

  FirebaseApp get scrapAll => _scrapAll;
  FirebaseApp get userTransact => _userTransact;
  FirebaseApp get placeAll => _placeAll;

  set scrapAll(FirebaseApp val) {
    _scrapAll = val;
    notifyListeners();
  }

  set userTransact(FirebaseApp val) {
    _userTransact = val;
    notifyListeners();
  }

  set placeAll(FirebaseApp val) {
    _placeAll = val;
    notifyListeners();
  }
}

class RealtimeDB {
  final globalContext = myGlobals.scaffoldKey.currentContext;

  DatabaseReference get scrapAll {
    final db = Provider.of<RealtimeDBProvider>(globalContext, listen: false);
    return FirebaseDatabase(app: db.scrapAll).reference();
  }

  DatabaseReference get userTransact {
    final db = Provider.of<RealtimeDBProvider>(globalContext, listen: false);
    return FirebaseDatabase(app: db.userTransact).reference();
  }

  DatabaseReference get placeAll {
    final db = Provider.of<RealtimeDBProvider>(globalContext, listen: false);
    return FirebaseDatabase(app: db.placeAll).reference();
  }
}

final dbRef = RealtimeDB();
