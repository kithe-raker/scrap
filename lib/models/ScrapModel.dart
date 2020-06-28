import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:scrap/function/authentication/AuthenService.dart';

class ScrapModel extends Equatable {
  final String text;
  final int textureIndex;
  final String writer;
  final DateTime litteredTime;
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
        transaction
      ];

  DocumentReference get path {
    var date = DateFormat('yyyyMMdd').format(this.litteredTime);
    var docPath =
        'Scraps/${this.scrapRegion}/$date/${this.litteredTime.hour}/ScrapDailys-${this.scrapRegion}/${this.scrapId}';
    return fireStore.document(docPath);
  }

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
        scrapRegion: json['region'],
        transaction: transaction,
        geoHash: position != null ? json['position']['geohash'] : null,
        position: position != null
            ? LatLng(position.latitude, position.longitude)
            : null);
  }
}

class ScrapTransaction extends Equatable {
  final int like;
  final int picked;
  final int comment;
  final double point;

  ScrapTransaction({this.comment, this.like, this.picked, this.point});

  @override
  List<Object> get props => [like, picked, comment, point];

  factory ScrapTransaction.fromJSON(Map<dynamic, dynamic> json) =>
      ScrapTransaction(
          like: json['like'] ?? 0,
          picked: json['picked'] ?? 0,
          comment: json['comment'] ?? 0,
          point: json['point']?.toDouble() ?? 0.0);
}
