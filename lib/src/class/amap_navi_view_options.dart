// ignore_for_file: constant_identifier_names

part of '../../amap_view_muka.dart';

class AMapNaviViewOptions {
  static const int HUD_NORMAL_SHOW = 1;
  static const int HUD_MIRROR_SHOW = 2;

  Image? startBitmap;
  Image? endBitmap;
  Image? wayBitmap;
  Image? monitorBitmap;
  Image? carBitmap;
  Image? fourCornersBitmap;
  Image? defaultTrafficBitmap;
  Image? pressedTrafficBitmap;
  Image? defaultOverBitmap;
  Image? pressedOverBitmap;

  int leaderLineColor = -1;
  double mapCenterX = 0.0;
  double mapCenterY = 0.0;
  int lockMapDelayed = 7000;
  String mapStylePath = '';
  Rect? landscape;
  Rect? vertical;

  int mLockZoom = 18;
  int mLockTilt = 35;
  RouteOverlayOptions mRouteOverlayOptions = RouteOverlayOptions();

  /// 是否自动画路，默认为True，此时当算路成功后会立即自动画路
  bool isAutoDrawRoute = true;

  /// 是否显示路口放大图(路口模型图)
  bool isModelCrossDisplayShow = true;

  /// 是否显示路口放大图(实景图)
  bool isRealCrossDisplayShow = true;

  /// 是否显示道路信息view
  bool isLaneInfoShow = true;

  /// 返回指南针图标是否显示。
  bool isCompassEnabled = true;

  bool isTrafficBarEnabled = true;

  /// 是否显示实时交通图层开关按钮（只适用于驾车导航，需要联网）
  bool isTrafficLayerEnabled = true;

  /// 是否显示路线全览按钮
  bool isRouteListButtonShow = true;
  bool isNaviArrowVisible = true;

  @Deprecated('Use isScreenAlwaysBright instead')
  bool isScreenAlwaysBright = true;

  @Deprecated('Use isTrafficInfoUpdateEnabled instead')
  bool isTrafficInfoUpdateEnabled = true;

  @Deprecated('Use isCameraInfoUpdateEnabled instead')
  bool isCameraInfoUpdateEnabled = true;

  /// 设置菜单按钮是否显示。
  bool isSettingMenuEnabled = false;

  /// 地图上是否显示交通路况（彩虹线）
  ///
  /// 拥堵-红色，畅通-绿色，缓慢-黄色，未知-蓝色。
  bool isTrafficLine = true;

  /// 设置导航界面UI是否显示。 注意：该接口会同时隐藏模型放大图和实景放大图，隐藏后可以通过AMapModeCrossOverlay绘制放大图
  bool isLayoutVisible = true;

  /// 是否开启了动态比例尺 (锁车态下自动进行地图缩放变化)
  bool isAutoChangeZoom = false;

  bool isSensorEnable = true;

  @Deprecated('Use isCameraBubbleShow instead')
  bool isCameraBubbleShow = true;

  bool isAutoLockCar = false;

  bool isAutoDisplayOverview = false;

  /// 通过路线是否自动置灰 可以使用RouteOverlayOptions.setPassRoute(Bitmap)改变纹理
  bool afterRouteAutoGray = false;

  bool isDrawBackUpOverlay = true;

  bool isSecondAction = false;

  @Deprecated('Use isNaviNight instead')
  bool isNaviNight = false;

  @Deprecated('Use isAutoNaviViewNightMode instead')
  bool isAutoNaviViewNightMode = false;

  MapStyle mMapStyle = MapStyle.day;

  bool mIsEyrieCrossShow = true;

  Rect? mEyrieCrossLandscape;
  Rect? mEyrieCrossVertical;

  bool mIsEagleMapShow = false;

  bool mIsShowCameraDistance = false;

  bool mIsOverSpeedPulseEffective = false;

  AMapNaviViewOptions();

  RouteOverlayOptions get routeOverlayOptions => mRouteOverlayOptions;
  set routeOverlayOptions(RouteOverlayOptions value) => mRouteOverlayOptions = value;

  void setCrossLocation(Rect? var1, Rect? var2) {
    if (var1 != null) {
      landscape = var1;
    }
    if (var2 != null) {
      vertical = var2;
    }
  }

  Rect? getLandscapeCross() {
    return landscape;
  }

  Rect? getVerticalCross() {
    return vertical;
  }

  Image? getCarBitmap() {
    return carBitmap;
  }

  setCarBitmap(Image? value) {
    carBitmap = value;
  }

  Image? getFourCornersBitmap() {
    return fourCornersBitmap;
  }

  setFourCornersBitmap(Image? value) {
    fourCornersBitmap = value;
  }

  void setCustomMapStylePath(String value) {
    mapStylePath = value;
  }

  String? getCustomMapStylePath() {
    return mapStylePath;
  }

  void setMapStyle(MapStyle value, String customPath) {
    switch (value) {
      case MapStyle.day:
        mMapStyle = MapStyle.day;

        setNaviNight(false);
        setAutoNaviViewNightMode(false);
        break;
      case MapStyle.night:
        mMapStyle = MapStyle.night;
        setNaviNight(true);
        setAutoNaviViewNightMode(false);
        break;
      case MapStyle.auto:
        mMapStyle = MapStyle.auto;
        setNaviNight(false);
        setAutoNaviViewNightMode(true);
        break;
      case MapStyle.custom:
        mMapStyle = MapStyle.custom;
        setNaviNight(false);
        setAutoNaviViewNightMode(false);
        setCustomMapStylePath(customPath);
        break;
    }
  }

  void setStartPointBitmap(Image? value) {
    startBitmap = value;
  }

  Image? getStartMarker() {
    return startBitmap;
  }

  void setEndPointBitmap(Image? value) {
    endBitmap = value;
  }

  Image? getEndMarker() {
    return endBitmap;
  }

  void setWayPointBitmap(Image? value) {
    wayBitmap = value;
  }

  Image? getWayMarker() {
    return wayBitmap;
  }

  void setMonitorCameraBitmap(Image? value) {
    monitorBitmap = value;
  }

  Image? getMonitorMarker() {
    return monitorBitmap;
  }

  int getLockMapDelayed() {
    return lockMapDelayed;
  }

  void setLockMapDelayed(int value) {
    lockMapDelayed = value;
  }

  int get zoom => mLockZoom;
  set zoom(int value) {
    if (value < 14) value = 14;
    if (value > 18) value = 18;
    mLockZoom = value;
  }

  int get tilt => mLockTilt;
  set tilt(int value) {
    if (value < 0) value = 0;
    if (value > 60) value = 60;
    mLockTilt = value;
  }

  void setAutoNaviViewNightMode(bool var1) {
    isAutoNaviViewNightMode = var1;
  }

  void setNaviNight(bool var1) {
    isNaviNight = var1;
    mapStylePath = "";
  }

  void setPointToCenter(double x, double y) {
    mapCenterX = x;
    mapCenterY = y;
  }

  void setTrafficBitmap(Image? defaultBitmap, Image? pressedBitmap) {
    defaultTrafficBitmap = defaultBitmap;
    pressedTrafficBitmap = pressedBitmap;
  }

  void setOverBitmap(Image? defaultBitmap, Image? pressedBitmap) {
    defaultOverBitmap = defaultBitmap;
    pressedOverBitmap = pressedBitmap;
  }

  void setAutoDisplayOverview(bool value) {
    isAutoDisplayOverview = value;
  }

  void setSecondActionVisible(bool value) {
    isSecondAction = value;
  }

  bool get isSecondActionVisible => isSecondAction;

  void setEyrieCrossDisplay(bool value) {
    mIsEyrieCrossShow = value;
  }

  bool get isEyrieCrossDisplay => mIsEyrieCrossShow;

  void setEyrieCrossLocation(Rect? var1, Rect? var2) {
    mEyrieCrossLandscape = var1;
    mEyrieCrossVertical = var2;
  }

  Rect? getEyrieCrossLandscape() {
    return mEyrieCrossLandscape;
  }

  Rect? getEyrieCrossVertical() {
    return mEyrieCrossVertical;
  }

  void setEagleMapVisible(bool value) {
    mIsEagleMapShow = value;
  }

  bool get isEagleMapVisible => mIsEagleMapShow;

  void setShowCameraDistance(bool value) {
    mIsShowCameraDistance = value;
  }

  bool get isShowCameraDistance => mIsShowCameraDistance;

  void setWidgetOverSpeedPulseEffective(bool value) {
    mIsOverSpeedPulseEffective = value;
  }

  bool get isWidgetOverSpeedPulseEffective => mIsOverSpeedPulseEffective;

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
      'isScreenAlwaysBright': isScreenAlwaysBright,
      'isTrafficInfoUpdateEnabled': isTrafficInfoUpdateEnabled,
      'isCameraInfoUpdateEnabled': isCameraInfoUpdateEnabled,
      'isSettingMenuEnabled': isSettingMenuEnabled,
      'isTrafficLine': isTrafficLine,
      'isLayoutVisible': isLayoutVisible,
      'isAutoChangeZoom': isAutoChangeZoom,
      'isSensorEnable': isSensorEnable,
      'isCameraBubbleShow': isCameraBubbleShow,
      'isAutoLockCar': isAutoLockCar,
      'isAutoDisplayOverview': isAutoDisplayOverview,
      'isAfterRouteAutoGray': afterRouteAutoGray,
      'isDrawBackUpOverlay': isDrawBackUpOverlay,
      'isSecondActionVisible': isSecondActionVisible,
      'isNaviNight': isNaviNight,
      'isAutoNaviViewNightMode': isAutoNaviViewNightMode,
      'mapStyle': mMapStyle.index,
      'mapStylePath': mapStylePath,
    };
  }
}
