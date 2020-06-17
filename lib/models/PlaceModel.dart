import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel extends Equatable {
  final String name;
  final String description;
  final LatLng location;
  PlaceModel({this.name, this.description, this.location});

  @override
  List<Object> get props => [name, description, location];

  factory PlaceModel.fromJSON(Map<String, dynamic> json) => PlaceModel(
      name: json['title'],
      description: json['address']['label'],
      location: LatLng(json['position']['lat'], json['position']['lng']));
}
