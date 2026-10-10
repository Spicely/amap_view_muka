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

  LatLng get target => latLng;

  const CameraPosition({
    LatLng? target,
    LatLng? latLng,
    this.zoom = 10.0,
    this.tilt = 0.0,
    this.bearing = 0.0,
    this.duration,
  }) : latLng = target ?? latLng ?? const LatLng(0, 0);

  const CameraPosition.position(
    this.latLng, [
    this.zoom = 10.0,
    this.tilt = 0.0,
    this.bearing = 0.0,
    this.duration,
  ]);

  Map<String, dynamic> toJson() => {
        'latLng': latLng.toJson(),
        'zoom': zoom,
        'bearing': bearing,
        'tilt': tilt,
        'duration': duration,
      };
  CameraPosition copyWith({
    LatLng? latLng,
    LatLng? target,
    double? zoom,
    double? tilt,
    double? bearing,
    int? duration,
  }) {
    return CameraPosition(
      latLng: latLng ?? target ?? this.latLng,
      zoom: zoom ?? this.zoom,
      tilt: tilt ?? this.tilt,
      bearing: bearing ?? this.bearing,
      duration: duration ?? this.duration,
    );
  }

  factory CameraPosition.fromJson(Map<dynamic, dynamic> json) => CameraPosition(
        latLng: LatLng.fromJson(Map<String, dynamic>.from(json['latLng'])),
        zoom: (json['zoom'] as num).toDouble(),
        tilt: (json['tilt'] as num).toDouble(),
        bearing: (json['bearing'] as num).toDouble(),
        duration: json['duration'],
      );
}

