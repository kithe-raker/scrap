import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scrap/services/config.dart';

class PlaceModel extends Equatable {
  final String name;
  final String description;
  PlaceModel({this.name, this.description});

  @override
  List<Object> get props => [name, description];

  factory PlaceModel.fromJSON(Map<String, dynamic> json) => PlaceModel(
      name: json['structured_formatting']['main_text'],
      description: json['description']);

  Future<LatLng> getLocation() async {
    final dio = Dio();
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json';
    String request =
        '$baseURL?input=${this.name}&inputtype=textquery&fields=geometry&region=th&key=$ApiKey';
    Response response = await dio.get(request);
    var list = response.data['candidates'];
    var location = list.first['geometry']['location'];
    return LatLng(location['lat'], location['lng']);
  }
}
