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
  LatLng position;

  /// 点标记的标题
  String? title;

  AmapMarkerIcon? icon;

  /// 点标记的内容
  String? snippet;

  /// 点标记是否可拖拽
  bool draggable;

  /// 点标记是否可见
  bool visible;

  /// 点标记的锚点
  String? anchor;

  /// 点标记的锚点
  double alpha;

  /// marker点击事件
  AmapMarkerOnTap? onTap;

  /// marker移动开始事件
  AmapMarkerOnDragStart? onDragStart;

  /// marker点击事件
  AmapMarkerOnDragMove? onDragMove;

  /// marker点击事件
  final AmapMarkerOnDragEnd? onDragEnd;

  AmapMarker({
    required this.id,
    required this.position,
    this.title,
    this.icon,
    this.snippet,
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
