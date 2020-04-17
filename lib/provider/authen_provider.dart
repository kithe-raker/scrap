import 'package:flutter/widgets.dart';

class AuthenProvider extends ChangeNotifier {
  String _verificationID,
      _phone,
      _password,
      _pName,
      _region,
      _gender,
      _uid,
      _email;
  dynamic _img;
  DateTime _birthday;

  String get verificationID => _verificationID;
  String get phone => _phone;
  String get password => _password;
  String get pName => _pName;
  String get region => _region;
  String get gender => _gender;
  dynamic get img => _img;
  DateTime get birthday => _birthday;
  String get uid => _uid;
  String get email => _email;

  set verificationID(String val) {
    _verificationID = val;
    notifyListeners();
  }

  set phone(String val) {
    _phone = val;
    notifyListeners();
  }

  set password(String val) {
    _password = val;
    notifyListeners();
  }

  set pName(String val) {
    _pName = val;
    notifyListeners();
  }

  set region(String val) {
    _region = val;
    notifyListeners();
  }

  set gender(String val) {
    _gender = val;
    notifyListeners();
  }

  set img(dynamic val) {
    _img = val;
    notifyListeners();
  }

  set birthday(dynamic val) {
    _birthday = val;
    notifyListeners();
  }

  set uid(String val) {
    _uid = val;
    notifyListeners();
  }

  set email(String val) {
    _email = val;
    notifyListeners();
  }
}
