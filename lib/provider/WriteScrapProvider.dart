import 'package:flutter/widgets.dart';

class WriteScrapProvider extends ChangeNotifier {
  String _text;
  bool _private;

  String get text => _text;
  bool get private => _private;

  set text(String val) {
    _text = val;
    notifyListeners();
  }

  set private(bool val) {
    _private = val;
    notifyListeners();
  }
}
