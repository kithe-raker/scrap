import 'package:flutter/cupertino.dart';

class MyGlobals {
  GlobalKey _scaffoldKey;
  MyGlobals() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
}

final myGlobals = MyGlobals();
