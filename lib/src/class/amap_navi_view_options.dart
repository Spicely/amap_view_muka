// ignore_for_file: constant_identifier_names

part of '../../amap_view_muka.dart';

class AMapNaviViewOptions {
  static const int HUD_NORMAL_SHOW = 1;
  static const int HUD_MIRROR_SHOW = 2;

  /// 是否自动画路，默认为True，此时当算路成功后会立即自动画路
  final bool isAutoDrawRoute;

  /// 是否显示路口放大图(路口模型图)
  final bool isModelCrossDisplayShow;

  /// 是否显示路口放大图(实景图)
  final bool isRealCrossDisplayShow;

  /// 是否显示道路信息view
  final bool isLaneInfoShow;

  /// 返回指南针图标是否显示。
  final bool isCompassEnabled;

  final bool isTrafficBarEnabled;

  /// 是否显示实时交通图层开关按钮（只适用于驾车导航，需要联网）
  final bool isTrafficLayerEnabled;

  /// 是否显示路线全览按钮
  final bool isRouteListButtonShow;
  final bool isNaviArrowVisible;

  /// 设置菜单按钮是否显示。
  final bool isSettingMenuEnabled;

  /// 地图上是否显示交通路况（彩虹线）
  ///
  /// 拥堵-红色，畅通-绿色，缓慢-黄色，未知-蓝色。
  final bool isTrafficLine;

  /// 设置导航界面UI是否显示。 注意：该接口会同时隐藏模型放大图和实景放大图，隐藏后可以通过AMapModeCrossOverlay绘制放大图
  final bool isLayoutVisible;

  /// 是否开启了动态比例尺 (锁车态下自动进行地图缩放变化)
  final bool isAutoChangeZoom;

  final bool isSensorEnable;

  final bool isAutoLockCar;

  final bool isAutoDisplayOverview;

  final bool isAfterRouteAutoGray;

  final bool isDrawBackUpOverlay;

  final bool isSecondActionVisible;

  final MapStyle mapStyle;

  final String mapStylePath;

  const AMapNaviViewOptions({
    this.isAutoDrawRoute = true,
    this.isModelCrossDisplayShow = true,
    this.isRealCrossDisplayShow = true,
    this.isLaneInfoShow = true,
    this.isCompassEnabled = true,
    this.isTrafficBarEnabled = true,
    this.isTrafficLayerEnabled = true,
    this.isRouteListButtonShow = true,
    this.isNaviArrowVisible = true,
    this.isSettingMenuEnabled = true,
    this.isTrafficLine = true,
    this.isLayoutVisible = true,
    this.isAutoChangeZoom = false,
    this.isSensorEnable = true,
    this.isAutoLockCar = false,
    this.isAutoDisplayOverview = false,
    this.isAfterRouteAutoGray = false,
    this.isDrawBackUpOverlay = true,
    this.isSecondActionVisible = false,
    this.mapStyle = MapStyle.day,
    this.mapStylePath = '',
  });

  AMapNaviViewOptions copyWith({
    bool? isAutoDrawRoute,
    bool? isModelCrossDisplayShow,
    bool? isRealCrossDisplayShow,
    bool? isLaneInfoShow,
    bool? isCompassEnabled,
    bool? isTrafficBarEnabled,
    bool? isTrafficLayerEnabled,
    bool? isRouteListButtonShow,
    bool? isNaviArrowVisible,
    bool? isSettingMenuEnabled,
    bool? isTrafficLine,
    bool? isLayoutVisible,
    bool? isAutoChangeZoom,
    bool? isSensorEnable,
    bool? isAutoLockCar,
    bool? isAutoDisplayOverview,
    bool? isAfterRouteAutoGray,
    bool? isDrawBackUpOverlay,
    bool? isSecondActionVisible,
    MapStyle? mapStyle,
    String? mapStylePath,
  }) {
    return AMapNaviViewOptions(
      isAutoDrawRoute: isAutoDrawRoute ?? this.isAutoDrawRoute,
      isModelCrossDisplayShow: isModelCrossDisplayShow ?? this.isModelCrossDisplayShow,
      isRealCrossDisplayShow: isRealCrossDisplayShow ?? this.isRealCrossDisplayShow,
      isLaneInfoShow: isLaneInfoShow ?? this.isLaneInfoShow,
      isCompassEnabled: isCompassEnabled ?? this.isCompassEnabled,
      isTrafficBarEnabled: isTrafficBarEnabled ?? this.isTrafficBarEnabled,
      isTrafficLayerEnabled: isTrafficLayerEnabled ?? this.isTrafficLayerEnabled,
      isRouteListButtonShow: isRouteListButtonShow ?? this.isRouteListButtonShow,
      isNaviArrowVisible: isNaviArrowVisible ?? this.isNaviArrowVisible,
      isSettingMenuEnabled: isSettingMenuEnabled ?? this.isSettingMenuEnabled,
      isTrafficLine: isTrafficLine ?? this.isTrafficLine,
      isLayoutVisible: isLayoutVisible ?? this.isLayoutVisible,
      isAutoChangeZoom: isAutoChangeZoom ?? this.isAutoChangeZoom,
      isSensorEnable: isSensorEnable ?? this.isSensorEnable,
      isAutoLockCar: isAutoLockCar ?? this.isAutoLockCar,
      isAutoDisplayOverview: isAutoDisplayOverview ?? this.isAutoDisplayOverview,
      isAfterRouteAutoGray: isAfterRouteAutoGray ?? this.isAfterRouteAutoGray,
      isDrawBackUpOverlay: isDrawBackUpOverlay ?? this.isDrawBackUpOverlay,
      isSecondActionVisible: isSecondActionVisible ?? this.isSecondActionVisible,
      mapStyle: mapStyle ?? this.mapStyle,
      mapStylePath: mapStylePath ?? this.mapStylePath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isAutoDrawRoute': isAutoDrawRoute,
      'isModelCrossDisplayShow': isModelCrossDisplayShow,
      'isRealCrossDisplayShow': isRealCrossDisplayShow,
      'isLaneInfoShow': isLaneInfoShow,
      'isCompassEnabled': isCompassEnabled,
      'isTrafficBarEnabled': isTrafficBarEnabled,
      'isTrafficLayerEnabled': isTrafficLayerEnabled,
      'isRouteListButtonShow': isRouteListButtonShow,
      'isNaviArrowVisible': isNaviArrowVisible,
      'isSettingMenuEnabled': isSettingMenuEnabled,
      'isTrafficLine': isTrafficLine,
      'isLayoutVisible': isLayoutVisible,
      'isAutoChangeZoom': isAutoChangeZoom,
      'isSensorEnable': isSensorEnable,
      'isAutoLockCar': isAutoLockCar,
      'isAutoDisplayOverview': isAutoDisplayOverview,
      'isAfterRouteAutoGray': isAfterRouteAutoGray,
      'isDrawBackUpOverlay': isDrawBackUpOverlay,
      'isSecondActionVisible': isSecondActionVisible,
      'mapStyle': mapStyle.index,
      'mapStylePath': mapStylePath,
    };
  }
}
