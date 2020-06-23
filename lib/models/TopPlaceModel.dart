import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TopPlaceModel extends Equatable {
  final String name;
  final String id;
  final String description;
  final LatLng location;
  final String categoryId;
  final List<RecentScrap> recentScraps;
  TopPlaceModel(
      {this.name,
      this.id,
      this.description,
      this.location,
      this.categoryId,
      this.recentScraps});

  @override
  List<Object> get props =>
      [name, id, description, location, categoryId, recentScraps];

  factory TopPlaceModel.fromJSON(Map<String, dynamic> json) {
    var position = json['position']['geopoint'];
    var recently = json['recently'] ?? [];
    List<RecentScrap> scraps = [];
    if (recently.length > 0)
      recently.forEach((scrap) => scraps.add(RecentScrap.fromJSON(scrap)));
    return TopPlaceModel(
        name: json['name'],
        id: json['id'],
        description: json['desc'],
        categoryId: json['category'],
        recentScraps: scraps,
        location: LatLng(position.latitude, position.longitude));
  }
}

class RecentScrap extends Equatable {
  final String text;
  final int textureIndex;
  final DateTime timeStamp;
  final String region;
  final String id;
  RecentScrap(
      {this.id, this.text, this.textureIndex, this.timeStamp, this.region});

  @override
  List<Object> get props => [text, textureIndex, id, timeStamp, region];

  factory RecentScrap.fromJSON(Map<String, dynamic> json) => RecentScrap(
      text: json['text'],
      textureIndex: json['texture'],
      timeStamp: json['timeStamp'].toDate(),
      id: json['id'],
      region: json['region']);
}
