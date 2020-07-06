import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScrapModel extends Equatable {
  final String text;
  final int textureIndex;
  final String writer;
  final DateTime litteredTime;
  final String placeName;
  final LatLng position;
  final String geoHash;
  final String writerUid;
  final String scrapId;
  final String scrapRegion;
  final ScrapTransaction transaction;

  ScrapModel(
      {this.text,
      this.litteredTime,
      this.textureIndex,
      this.placeName,
      this.position,
      this.geoHash,
      this.scrapId,
      this.scrapRegion,
      this.writer,
      this.writerUid,
      this.transaction});

  @override
  List<Object> get props => [
        text,
        litteredTime,
        textureIndex,
        position,
        scrapId,
        scrapRegion,
        writer,
        writerUid,
        placeName,
        transaction
      ];

  Map<String, dynamic> get toJSON {
    var location = {
      'geohash': this.geoHash,
      'geopoint': GeoPoint(this.position.latitude, this.position.longitude)
    };
    var scrap = {
      'text': this.text,
      'writer': this.writer,
      'timeStamp': this.litteredTime,
      'texture': this.textureIndex
    };
    return {
      'id': this.scrapId,
      'region': this.scrapRegion,
      'uid': this.writerUid,
      'placeName': this.placeName,
      'scrap': scrap,
      'position': location
    };
  }

  factory ScrapModel.fromJSON(Map<String, dynamic> json,
      {@required ScrapTransaction transaction}) {
    var scrap = json['scrap'];
    var position =
        json['position'] != null ? json['position']['geopoint'] : null;
    return ScrapModel(
        text: scrap['text'],
        writer: scrap['writer'],
        litteredTime: scrap['timeStamp'].toDate(),
        scrapId: json['id'],
        textureIndex: scrap['texture'] ?? 0,
        writerUid: json['uid'],
        placeName: json['placeName'],
        scrapRegion: json['region'],
        transaction: transaction,
        geoHash: position != null ? json['position']['geohash'] : null,
        position: position != null
            ? LatLng(position.latitude, position.longitude)
            : null);
  }
}

class ScrapTransaction {
  int like;
  int picked;
  int comment;
  double point;

  ScrapTransaction({this.comment, this.like, this.picked, this.point});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScrapTransaction &&
          runtimeType == other.runtimeType &&
          like == other.like &&
          picked == other.picked &&
          comment == other.comment &&
          point == other.point;

  @override
  int get hashCode =>
      like.hashCode ^ picked.hashCode ^ comment.hashCode ^ point.hashCode;

  factory ScrapTransaction.fromJSON(Map<dynamic, dynamic> json) =>
      ScrapTransaction(
          like: json['like'] ?? 0,
          picked: json['picked'] ?? 0,
          comment: json['comment'] ?? 0,
          point: json['point']?.toDouble() ?? 0.0);
}
