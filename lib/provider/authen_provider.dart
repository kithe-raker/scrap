
import 'package:flutter/widgets.dart';

class AuthenProvider extends ChangeNotifier{
  String _verificationID = "";

  String _phone = "";
  String _password = "";
  String _pName = "";
  String _region = "";
  String _otp = "";

  String get verificationID => _verificationID;
  String get phone => _phone;
  String get password => _password;
  String get pName => _pName;
  String get region => _region;
  String get otp => _otp;

  set verificationID(String val){
    _verificationID = val;
    notifyListeners();
  }

  set phone(String val){
    _phone = val;
    notifyListeners();
  }

  set password(String val){
    _password = val;
    notifyListeners();
  }

  set pName(String val){
    _pName = val;
    notifyListeners();
  }

  set region(String val){
    _region = val;
    notifyListeners();
  }

  set otp(String val){
    _otp = val;
    notifyListeners();
  }


}