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

  AmapDefaultMarker({
    required this.id,
    required this.position,
    this.title,
    this.snippet,
    this.anchor,
    this.visible = true,
    this.draggable = false,
    this.alpha = 1.0,
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
      };

  @override
  fromJson(Map<String, dynamic> json) => AmapDefaultMarker(
        id: json['id'] as String,
        position: LatLng.fromJson(json['position'] as Map<String, dynamic>),
        title: json['title'],
        snippet: json['snippet'] as String?,
        anchor: json['anchor'] as String?,
        visible: json['visible'] as bool,
        draggable: json['draggable'] as bool,
        alpha: json['alpha'] as double,
      );

  @override
  String get type => 'defaultMarker';
}
