part of amap_view_muka;

class CameraPosition {
  final LatLng latLng;

  /// 缩放等级
  final double level;

  /// 俯仰角0°~45°（垂直与地图时为0
  final double angle;

  /// 偏航角 0~360° (正北方为0)
  final double yawAngle;

  CameraPosition(
    this.latLng,
    this.level,
    this.angle,
    this.yawAngle,
  );

  Map<String, dynamic> toJson() => {
        'latLng': latLng.toJson(),
        'level': level,
        'angle': angle,
        'yawAngle': yawAngle,
      };
  CameraPosition copyWith({
    LatLng? latLngParams,
    double? levelParams,
    double? angleParams,
    double? yawAngleParams,
  }) {
    return CameraPosition(latLngParams ?? latLng, levelParams ?? level, angleParams ?? angle, yawAngleParams ?? yawAngle);
  }

  factory CameraPosition.fromJson(Map<dynamic, dynamic> json) =>
      CameraPosition(json['latLng'], json['level'], json['angle'], json['yawAngle']);
}
