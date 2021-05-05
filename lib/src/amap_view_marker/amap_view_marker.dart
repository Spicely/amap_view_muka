part of amap_view_muka;
// import 'package:json_annotation/json_annotation.dart';

// part 'amap_view_marker.g.dart';

// @JsonSerializable()
class AmapViewMarker {
  /// 作为唯一索引
  final String id;

  /// 在地图上标记位置的经纬度值。必填参数
  final LatLng position;

  AmapViewMarker({
    required this.id,
    required this.position,
  });

  factory AmapViewMarker.fromJson(Map<String, dynamic> json) => _$AmapViewMarkerFromJson(json);

  Map<String, dynamic> toJson() => _$AmapViewMarkerToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmapViewMarker _$AmapViewMarkerFromJson(Map<String, dynamic> json) {
  return AmapViewMarker(
    id: json['id'] as String,
    position: LatLng.fromJson(json['position'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AmapViewMarkerToJson(AmapViewMarker instance) => <String, dynamic>{
      'id': instance.id,
      'position': instance.position.toJson(),
    };
