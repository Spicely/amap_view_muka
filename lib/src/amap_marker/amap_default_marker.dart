part of amap_view_muka;

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 默认的Marker
//// Date: 2021年05月06日 11:16:43 Thursday
//////////////////////////////////////////////////////////////////////////

class AMapDefaultMarker implements AMapMarker {
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

  /// 点的透明度
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

  AMapDefaultMarker({
    required this.id,
    required this.position,
    this.title,
    this.icon,
    this.snippet,
    this.anchor,
    this.visible = true,
    this.draggable = false,
    this.alpha = 1.0,
    this.onTap,
    this.onDragStart,
    this.onDragMove,
    this.onDragEnd,
    this.infoWindow,
    this.showInfoWindow = false,
  });

  @override
  Map<String, dynamic> toJson() => {
        'id': this.id,
        'position': this.position.toJson(),
        'type': this.type,
        'title': this.title,
        'snippet': this.snippet,
        'anchor': this.anchor,
        'visible': this.visible,
        'draggable': this.draggable,
        'alpha': this.alpha,
        'icon': this.icon?.toJson(),
        'infoWindow': this.infoWindow?.toJson(),
      };

  @override
  String get type => 'defaultMarker';

  @override
  AMapDefaultMarker copyWith({
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
      AMapDefaultMarker(
        id: this.id,
        position: position ?? this.position,
        draggable: draggable ?? this.draggable,
        visible: visible ?? this.visible,
        anchor: anchor ?? this.anchor,
        alpha: alpha ?? this.alpha,
        onTap: onTap ?? this.onTap,
        onDragStart: onDragStart ?? this.onDragStart,
        onDragMove: onDragMove ?? this.onDragMove,
        onDragEnd: onDragEnd ?? this.onDragEnd,
        icon: icon ?? this.icon,
        infoWindow: infoWindow ?? this.infoWindow,
        showInfoWindow: showInfoWindow ?? this.showInfoWindow,
      );

  factory AMapDefaultMarker.fromJson(Map<String, dynamic> json) => AMapDefaultMarker(
        id: json['id'] as String,
        position: LatLng.fromJson(json['position'] as Map<String, dynamic>),
        title: json['title'],
        snippet: json['snippet'] as String?,
        anchor: json['anchor'] as String?,
        visible: json['visible'] as bool,
        draggable: json['draggable'] as bool,
        alpha: json['alpha'] as double,
        icon: json['icon'] ?? _getAMapImage(json['icon']),
        infoWindow: json['infoWindow'] ?? _getAMapMarkerInfoWindow(json['infoWindow']),
      );
}

AMapImage _getAMapImage(Map<dynamic, dynamic> json) {
  switch (json['type']) {
    case 'marker#asset':
      return AMapViewAssetImage.fromJson(json);
    default:
      return AMapViewAssetImage.fromJson(json);
  }
}

AMapMarkerInfoWindow _getAMapMarkerInfoWindow(Map<dynamic, dynamic> json) {
  switch (json['type']) {
    // case 'marker#asset':
    //   return AMapMarkerAssetIcon.fromJson(json);
    default:
      return AMapMarkerCardInfoWindow.fromJson(json);
  }
}
