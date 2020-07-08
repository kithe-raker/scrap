class CacheQuery {
  double lessPoint;
  String lessPointId;
  int recentTime;
  String recentScrapId;

  CacheQuery(
      {this.recentTime, this.lessPoint, this.lessPointId, this.recentScrapId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheQuery &&
          runtimeType == other.runtimeType &&
          lessPoint == other.lessPoint &&
          lessPointId == other.lessPointId &&
          recentTime == other.recentTime &&
          recentScrapId == other.recentScrapId;

  @override
  int get hashCode =>
      lessPoint.hashCode ^
      lessPointId.hashCode ^
      recentTime.hashCode ^
      recentScrapId.hashCode;

  factory CacheQuery.fromJSON(Map<dynamic, dynamic> json) => CacheQuery(
      lessPoint: json['point']?.toDouble(),
      lessPointId: json['id'],
      recentTime: json['recentTime'] ??
          DateTime.now().subtract(Duration(hours: 48)).millisecondsSinceEpoch,
      recentScrapId: json['recentScrapId']);
}
