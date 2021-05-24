part of amap_view_muka;

class CameraPosition {
  final LatLng latLng;

  /// 缩放等级
  final double zoom;

  /// 俯仰角0°~45°（垂直与地图时为0
  final double tilt;

  /// 偏航角 0~360° (正北方为0)
  final double bearing;

  /// 动画时间 不填写没有动画
  final int? duration;

  const CameraPosition(
    this.latLng,
    this.zoom,
    this.tilt,
    this.bearing, {
    this.duration,
  });

  Map<String, dynamic> toJson() => {
        'latLng': latLng.toJson(),
        'zoom': zoom,
        'bearing': bearing,
        'tilt': tilt,
        'duration': duration,
      };
  CameraPosition copyWith({
    LatLng? latLngParams,
    double? zoomParams,
    double? tiltParams,
    double? bearingParams,
    int? durationParams,
  }) {
    return CameraPosition(latLngParams ?? latLng, zoomParams ?? zoom, tiltParams ?? tilt, bearingParams ?? bearing,
        duration: durationParams ?? duration);
  }

  factory CameraPosition.fromJson(Map<dynamic, dynamic> json) =>
      CameraPosition(LatLng.fromJson(json['latLng']), json['zoom'], json['tilt'], json['bearing'], duration: json['duration']);
}
