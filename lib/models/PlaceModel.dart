import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scrap/services/GeoLocation.dart';

class PlaceModel extends Equatable {
  final String name;
  final String placeId;
  final String description;
  final LatLng location;
  final String categoryId;
  PlaceModel(
      {this.name,
      this.description,
      this.location,
      this.categoryId,
      this.placeId});

  @override
  List<Object> get props =>
      [name, description, location, categoryId, placeId];

  factory PlaceModel.fromJSON(Map<String, dynamic> json) => PlaceModel(
      name: json['title'],
      description: json['address']['label'],
      placeId: json['id'].split(':')[3].split('-')[1],
      categoryId: json['categories'][0]['id'],
      location: LatLng(json['position']['lat'], json['position']['lng']));

  Map<String, dynamic> get toJSON => {
        'id': this.placeId,
        'name': this.name,
        'position': this.geoPoint.data,
        'desc': this.description,
        'category': this.categoryId
      };

  GeoLocation get geoPoint =>
      GeoLocation(this.location.latitude, this.location.longitude);
}
