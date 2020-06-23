import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/services/Geopoint.dart' as geo;
import 'package:scrap/services/Util.dart';

class QueryMethods {
  Future<List<DocumentSnapshot>> getDocsInRadius(
      {@required double radius, @required geo.GeoPoint center}) async {
    int precision = Util.setPrecision(radius);
    List<DocumentSnapshot> docs = [];
    String centerHash = center.hash.substring(0, precision);
    List<String> area = geo.GeoPoint.neighborsOf(hash: centerHash)
      ..add(centerHash);
    await Future.forEach(area, (hash) async {
      Query tempQuery = _queryPoint(hash, 'position');
      var docsInR = await tempQuery.getDocuments();
      docs.addAll(docsInR.documents);
    });
    docs.removeWhere((scrap) {
      GeoPoint geoPoint = scrap.data['position']['geopoint'];
      var distances =
          center.distance(lat: geoPoint.latitude, lng: geoPoint.longitude);
      return distances > radius * 1.02;
    });
    return docs;
  }

  Query _queryPoint(String geoHash, String field) {
    String end = '$geoHash~';
    return fireStore
        .collectionGroup('ScrapDailys-th')
        .orderBy('$field.geohash')
        .startAt([geoHash]).endAt([end]);
  }
}
