import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

class RealtimeDB extends ChangeNotifier {
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
