import 'package:flutter/widgets.dart';

class UserData extends ChangeNotifier {
  String _id;
  String _uid;
  String _img;
  int _papers;

  String get id => _id;
  String get uid => _uid;
  String get img => _img;
  int get papers => _papers;

  set img(String val) {
    _img = val;
    notifyListeners();
  }

  set papers(int val) {
    _papers = val;
    notifyListeners();
  }

  set id(String val) {
    _id = val;
    notifyListeners();
  }

  set uid(String val) {
    _uid = val;
    notifyListeners();
  }
}
