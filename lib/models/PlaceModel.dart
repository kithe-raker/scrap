import 'package:equatable/equatable.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel extends Equatable {
  final String name;
  final String herePlaceId;
  final String description;
  final LatLng location;
  final String categoryId;
  PlaceModel(
      {this.name,
      this.description,
      this.location,
      this.categoryId,
      this.herePlaceId});

  @override
  List<Object> get props =>
      [name, description, location, categoryId, herePlaceId];

  factory PlaceModel.fromJSON(Map<String, dynamic> json) => PlaceModel(
      name: json['title'],
      description: json['address']['label'],
      herePlaceId: json['id'],
      categoryId: json['categories'][0]['id'],
      location: LatLng(json['position']['lat'], json['position']['lng']));

  Map<String, dynamic> get toJSON => {
        'id': this.placeId,
        'name': this.name,
        'position': this.geoPoint.data,
        'desc': this.description,
        'category': this.categoryId
      };

  GeoFirePoint get geoPoint => Geoflutterfire().point(
      latitude: this.location.latitude, longitude: this.location.longitude);

  String get placeId => this.herePlaceId.split(':')[3].split('-')[1];
}
