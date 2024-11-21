part of '../../amap_view_muka.dart';

class AMapNaviLocation {
  final double? accuracy;
  final double? altitude;
  final double? bearing;
  final double? roadBearing;
  final double? speed;
  final int? time;
  final int? matchStatus;
  final LatLng? coord;
  final int? locationType;
  final int? curStepIndex;
  final int? curLinkIndex;
  final int? curPointIndex;

  AMapNaviLocation({
    this.accuracy,
    this.altitude,
    this.bearing,
    this.roadBearing,
    this.speed,
    this.time,
    this.matchStatus,
    this.coord,
    this.locationType,
    this.curStepIndex,
    this.curLinkIndex,
    this.curPointIndex,
  });

  factory AMapNaviLocation.fromJson(Map<String, dynamic> json) {
    return AMapNaviLocation(
      accuracy: json['accuracy'],
      altitude: json['altitude'],
      bearing: json['bearing'],
      roadBearing: json['roadBearing'],
      speed: json['speed'],
      time: json['time'],
      matchStatus: json['matchStatus'],
      coord: LatLng.fromJson(json['coord']),
      locationType: json['locationType'],
      curStepIndex: json['curStepIndex'],
      curLinkIndex: json['curLinkIndex'],
      curPointIndex: json['curPointIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accuracy': accuracy,
      'altitude': altitude,
      'bearing': bearing,
      'roadBearing': roadBearing,
      'speed': speed,
      'time': time,
      'matchStatus': matchStatus,
      'coord': coord?.toJson(),
      'locationType': locationType,
      'curStepIndex': curStepIndex,
      'curLinkIndex': curLinkIndex,
      'curPointIndex': curPointIndex,
    };
  }
}
