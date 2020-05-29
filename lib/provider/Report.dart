import 'package:flutter/widgets.dart';

class Report extends ChangeNotifier {
  String _text, _targetId;
  String _scrapId, _scrapRef;
  String _topic = 'กล่าวอ้างถึงบุคคลที่สามในทางเสียหาย  ';

  String get reportText => _text;
  String get targetId => _targetId;
  String get scrapRef => _scrapRef;
  String get scrapId => _scrapId;
  String get topic => _topic;

  set reportText(String val) {
    _text = val;
    notifyListeners();
  }

  set scrapRef(String val) {
    _scrapRef = val;
    notifyListeners();
  }

  set scrapId(String val) {
    _scrapId = val;
    notifyListeners();
  }

  set topic(String val) {
    _topic = val;
    notifyListeners();
  }

  set targetId(String val) {
    _targetId = val;
    notifyListeners();
  }
}
