import 'package:flutter/widgets.dart';

class AdsCounterProvider extends ChangeNotifier {
  int _count;

  int get count => _count;

  set count(int val) {
    _count = val;
    notifyListeners();
  }
}
