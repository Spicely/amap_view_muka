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
    LatLng? latLng,
    double? zoom,
    double? tilt,
    double? bearing,
    int? duration,
  }) {
    return CameraPosition(latLng ?? this.latLng, zoom ?? this.zoom, tilt ?? this.tilt, bearing ?? this.bearing,
        duration: duration ?? this.duration);
  }

  factory CameraPosition.fromJson(Map<dynamic, dynamic> json) =>
      CameraPosition(LatLng.fromJson(Map<String, dynamic>.from(json['latLng'])), json['zoom'], json['tilt'], json['bearing'],
          duration: json['duration']);
}
