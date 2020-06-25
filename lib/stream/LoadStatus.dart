import 'package:rxdart/rxdart.dart';

class LoadStatus {
  final feedStatus = BehaviorSubject<bool>();
  final followFeedStatus = BehaviorSubject<bool>();
  final searchStatus = BehaviorSubject<bool>();
  final nearbyStatus = BehaviorSubject<bool>();
}

final loadStatus = LoadStatus();
