import 'package:flutter/widgets.dart';

class UserData extends ChangeNotifier {
  String _id, _uid, _token, _region, _imgUrl;
  String _phone, _verifiedId, _password;
  dynamic _img;
  bool _promise;
  int _papers;

  String get id => _id;
  String get uid => _uid;
  dynamic get img => _img;
  bool get promise => _promise;
  String get imgUrl => _imgUrl;
  String get phone => _phone;
  String get verifiedId => _verifiedId;
  String get password => _password;
  String get token => _token;
  String get region => _region;
  int get papers => _papers;

  set img(dynamic val) {
    _img = val;
    notifyListeners();
  }

  set imgUrl(String val) {
    _imgUrl = val;
    notifyListeners();
  }

  set promise(bool val) {
    _promise = val;
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

  set phone(String val) {
    _phone = val;
    notifyListeners();
  }

  set verifiedId(String val) {
    _verifiedId = val;
    notifyListeners();
  }

  set password(String val) {
    _password = val;
    notifyListeners();
  }

  set token(String val) {
    _token = val;
    notifyListeners();
  }

  set region(String val) {
    _region = val;
    notifyListeners();
  }
}
