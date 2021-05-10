part of amap_view_muka;

typedef void AmapMarkerOnTap();

typedef void AmapMarkerOnDragStart(LatLng latLng);

typedef void AmapMarkerOnDragMove(LatLng latLng);

typedef void AmapMarkerOnDragEnd(LatLng latLng);

abstract class AmapMarker {
  /// 作为唯一索引
  ///
  /// [必填参数]
  final String id;

  /// 在地图上标记位置的经纬度值
  ///
  /// [必填参数]
  final LatLng position;

  final AmapMarkerIcon? icon;

  /// 点标记是否可拖拽
  final bool draggable;

  /// 点标记是否可见
  final bool visible;

  /// 点标记的锚点
  final String? anchor;

  /// 点标记的锚点
  final double alpha;

  /// marker点击事件
  final AmapMarkerOnTap? onTap;

  /// marker移动开始事件
  final AmapMarkerOnDragStart? onDragStart;

  /// marker点击事件
  final AmapMarkerOnDragMove? onDragMove;

  /// marker点击事件
  final AmapMarkerOnDragEnd? onDragEnd;

  AmapMarker({
    required this.id,
    required this.position,
    this.icon,
    this.anchor,
    this.draggable = false,
    this.visible = true,
    this.alpha = 1.0,
    this.onTap,
    this.onDragStart,
    this.onDragMove,
    this.onDragEnd,
  });

  Map<String, dynamic> toJson() => {};

  String get type => '';
}
