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

  AmapMarkerIcon? icon;

  /// 在地图上标记位置的经纬度值。必填参数
  LatLng position;

  /// 点标记的标题
  String? title;

  /// 点标记的内容
  String? snippet;

  /// 点标记是否可拖拽
  bool draggable;

  /// 点标记是否可见
  bool visible;

  /// 点标记的锚点
  String? anchor;

  /// 点的透明度
  double alpha;

  /// marker点击事件
  AmapMarkerOnTap? onTap;

  /// marker移动开始事件
  AmapMarkerOnDragStart? onDragStart;

  /// marker点击事件
  AmapMarkerOnDragMove? onDragMove;

  /// marker点击事件
  AmapMarkerOnDragEnd? onDragEnd;

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
