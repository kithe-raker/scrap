import 'package:flutter/widgets.dart';

class WriteScrapProvider extends ChangeNotifier {
  String _text;
  int _textureIndex;
  bool _private;

  String get text => _text;
  int get textureIndex => _textureIndex;
  bool get private => _private;

  set text(String val) {
    _text = val;
    notifyListeners();
  }

  set private(bool val) {
    _private = val;
    notifyListeners();
  }

  set textureIndex(int val) {
    _textureIndex = val;
    notifyListeners();
  }

  void clearData() {
    text = null;
    textureIndex = null;
    private = null;
  }
}
