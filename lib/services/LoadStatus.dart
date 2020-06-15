import 'package:rxdart/rxdart.dart';

class LoadStatus {
  final feedStatus = BehaviorSubject<bool>();
}

final loadStatus = LoadStatus();
