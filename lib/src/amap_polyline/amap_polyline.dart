part of amap_view_muka;

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 高德地图折线 Polyline 模型
//////////////////////////////////////////////////////////////////////////

typedef void AMapPolylineOnTap();

class AMapPolyline {
  /// 作为唯一索引 [必填参数]
  final String id;

  /// 折线顶点坐标集合 [必填参数]
  final List<LatLng> points;

  /// 线宽（像素）
  final double width;

  /// 线条颜色
  final Color color;

  /// 是否可见
  final bool visible;

  /// 是否为虚线
  final bool isDotted;

  /// 是否大地曲线
  final bool isGeodesic;

  /// 绘制层级
  final double zIndex;

  /// 拐角类型：0 - 普通斜角, 1 - 尖角, 2 - 圆角
  final int lineJoinType;

  /// 端点类型：0 - 普通平头, 1 - 方头, 2 - 圆头
  final int lineCapType;

  /// 点击回调
  final AMapPolylineOnTap? onTap;

  const AMapPolyline({
    required this.id,
    required this.points,
    this.width = 10.0,
    this.color = const Color(0xFF00E676),
    this.visible = true,
    this.isDotted = false,
    this.isGeodesic = false,
    this.zIndex = 0.0,
    this.lineJoinType = 2, // 默认圆角连接
    this.lineCapType = 2,  // 默认圆头
    this.onTap,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'points': points.map((p) => p.toJson()).toList(),
        'width': width,
        'color': [color.red, color.green, color.blue, color.alpha],
        'colorValue': color.value,
        'visible': visible,
        'isDotted': isDotted,
        'isGeodesic': isGeodesic,
        'zIndex': zIndex,
        'lineJoinType': lineJoinType,
        'lineCapType': lineCapType,
      };

  AMapPolyline copyWith({
    String? id,
    List<LatLng>? points,
    double? width,
    Color? color,
    bool? visible,
    bool? isDotted,
    bool? isGeodesic,
    double? zIndex,
    int? lineJoinType,
    int? lineCapType,
    AMapPolylineOnTap? onTap,
  }) =>
      AMapPolyline(
        id: id ?? this.id,
        points: points ?? this.points,
        width: width ?? this.width,
        color: color ?? this.color,
        visible: visible ?? this.visible,
        isDotted: isDotted ?? this.isDotted,
        isGeodesic: isGeodesic ?? this.isGeodesic,
        zIndex: zIndex ?? this.zIndex,
        lineJoinType: lineJoinType ?? this.lineJoinType,
        lineCapType: lineCapType ?? this.lineCapType,
        onTap: onTap ?? this.onTap,
      );
}
