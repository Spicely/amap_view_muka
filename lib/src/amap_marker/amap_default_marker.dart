part of amap_view_muka;

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 默认的Marker
//// Date: 2021年05月06日 11:16:43 Thursday
//////////////////////////////////////////////////////////////////////////

class AmapDefaultMarker implements AmapMarker {
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
  final AmapMarkerOnTap? onTap;

  /// marker移动开始事件
  final AmapMarkerOnDragStart? onDragStart;

  /// marker点击事件
  final AmapMarkerOnDragMove? onDragMove;

  /// marker点击事件
  final AmapMarkerOnDragEnd? onDragEnd;

  /// marker自定义图标
  final AmapMarkerIcon? icon;

  /// marker自定义infoWindow
  final AmapMarkerInfoWindow? infoWindow;

  /// 显示infoWindow
  final bool showInfoWindow;

  AmapDefaultMarker({
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

  factory AmapDefaultMarker.fromJson(Map<String, dynamic> json) => AmapDefaultMarker(
        id: json['id'] as String,
        position: LatLng.fromJson(json['position'] as Map<String, dynamic>),
        title: json['title'],
        snippet: json['snippet'] as String?,
        anchor: json['anchor'] as String?,
        visible: json['visible'] as bool,
        draggable: json['draggable'] as bool,
        alpha: json['alpha'] as double,
        icon: json['icon'] ?? _getAmapMarkerIcon(json['icon']),
        infoWindow: json['infoWindow'] ?? _getAmapMarkerInfoWindow(json['infoWindow']),
      );
}

AmapMarkerIcon _getAmapMarkerIcon(Map<dynamic, dynamic> json) {
  switch (json['type']) {
    case 'marker#asset':
      return AmapMarkerAssetIcon.fromJson(json);
    default:
      return AmapMarkerWebIcon.fromJson(json);
  }
}

AmapMarkerInfoWindow _getAmapMarkerInfoWindow(Map<dynamic, dynamic> json) {
  switch (json['type']) {
    // case 'marker#asset':
    //   return AmapMarkerAssetIcon.fromJson(json);
    default:
      return AmapMarkerCardInfoWindow.fromJson(json);
  }
}
