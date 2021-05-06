part of amap_view_muka;

abstract class AmapMarker {
  /// 作为唯一索引
  final String id;

  /// 在地图上标记位置的经纬度值。必填参数
  final LatLng position;

  /// 点标记的标题
  final String? title;

  /// 点标记的内容
  final String? snippet;

  /// 点标记是否可拖拽
  final bool draggable;

  /// 点标记是否可见
  final bool visible;

  /// 点标记的锚点
  final String? anchor;

  /// 点标记的锚点
  final double alpha;

  AmapMarker({
    required this.id,
    required this.position,
    this.title,
    this.snippet,
    this.anchor,
    this.draggable = false,
    this.visible = true,
    this.alpha = 1.0,
  });

  Map<String, dynamic> toJson() => {};

  dynamic fromJson(Map<String, dynamic> json) => {};

  String get type => '';
}
