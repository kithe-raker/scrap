import 'package:flutter/widgets.dart';

class UserData extends ChangeNotifier {
  int _papers;

  int get papers => _papers;

  set papers(int val) {
    _papers = val;
    notifyListeners();
  }
}
