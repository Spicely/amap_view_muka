part of amap_view_muka;

typedef void AMapMarkerOnTap();

typedef void AMapMarkerOnDragStart(LatLng latLng);

typedef void AMapMarkerOnDragMove(LatLng latLng);

typedef void AMapMarkerOnDragEnd(LatLng latLng);

abstract class AMapMarker {
  /// 作为唯一索引
  ///
  /// [必填参数]
  final String id;

  /// 在地图上标记位置的经纬度值
  ///
  /// [必填参数]
  final LatLng position;

  /// 点标记是否可拖拽
  final bool draggable;

  /// 点标记是否可见
  final bool visible;

  /// 点标记的锚点
  final String? anchor;

  /// 点标记的锚点
  final double alpha;

  /// marker点击事件
  final AMapMarkerOnTap? onTap;

  /// marker移动开始事件
  final AMapMarkerOnDragStart? onDragStart;

  /// marker点击事件
  final AMapMarkerOnDragMove? onDragMove;

  /// marker点击事件
  final AMapMarkerOnDragEnd? onDragEnd;

  /// marker自定义图标
  final AMapImage? icon;

  /// marker自定义infoWindow
  final AMapMarkerInfoWindow? infoWindow;

  /// 显示infoWindow
  final bool showInfoWindow;

  AMapMarker({
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
    this.infoWindow,
    this.showInfoWindow = false,
  });

  Map<String, dynamic> toJson() => {};

  String get type => '';

  dynamic copyWith({
    LatLng? position,

    /// 点标记是否可拖拽
    bool? draggable,

    /// 点标记是否可见
    bool? visible,

    /// 点标记的锚点
    String? anchor,

    /// 点标记的锚点
    double? alpha,

    /// marker点击事件
    AMapMarkerOnTap? onTap,

    /// marker移动开始事件
    AMapMarkerOnDragStart? onDragStart,

    /// marker点击事件
    AMapMarkerOnDragMove? onDragMove,

    /// marker点击事件
    AMapMarkerOnDragEnd? onDragEnd,

    /// marker自定义图标
    AMapImage? icon,

    /// marker自定义infoWindow
    AMapMarkerInfoWindow? infoWindow,

    /// 显示infoWindow
    bool? showInfoWindow,
  }) =>
      dynamic;
}
