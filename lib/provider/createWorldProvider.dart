import 'dart:io';

import 'package:flutter/widgets.dart';

class CreateWorldProvider extends ChangeNotifier {
  String _descript, _worldName;
  File _image;

  String get descript => _descript;
  String get worldName => _worldName;
  File get image => _image;

  set descript(String val) {
    _descript = val;
    notifyListeners();
  }

  set worldName(String val) {
    _worldName = val;
    notifyListeners();
  }

  set image(File val) {
    _image = val;
    notifyListeners();
  }
}
