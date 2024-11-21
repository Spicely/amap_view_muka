part of '../../amap_view_muka.dart';

enum AMapNaviType {
  /// 导航地图
  navi,

  /// 夜景地图
  night,

  /// 白昼地图（即普通地图）
  normal,

  /// 卫星图
  satellite,

  /// 公交地图
  bus,
}

enum MapStyle {
  auto,
  day,
  night,
  custom,
}

enum AMapViewLogoPosition {
  /// 左边
  LOGO_POSITION_BOTTOM_LEFT,

  /// 底部
  LOGO_MARGIN_BOTTOM,

  /// 右边
  LOGO_MARGIN_RIGHT,

  /// 地图底部居中
  LOGO_POSITION_BOTTOM_CENTER,

  /// 地图右下角
  LOGO_POSITION_BOTTOM_RIGHT,
}

enum AMapViewLanguage {
  /// 中文
  CHINESE,

  /// 英文
  ENGLISH,
}

enum AMapLocationStyle {
  /// 只定位一次 地图不会移动
  LOCATION_TYPE_SHOW,

  ///定位一次，且将视角移动到地图中心点
  LOCATION_TYPE_LOCATE,

  /// 连续定位、且将视角移动到地图中心点，定位蓝点跟随设备移动。（1秒1次定位）
  LOCATION_TYPE_FOLLOW,

  /// 连续定位、且将视角移动到地图中心点，地图依照设备方向旋转，定位点会跟随设备移动。（1秒1次定位）
  LOCATION_TYPE_MAP_ROTATE,

  /// 连续定位、且将视角移动到地图中心点，定位点依照设备方向旋转，并且会跟随设备移动。（1秒1次定位）默认执行此种模式
  LOCATION_TYPE_LOCATION_ROTATE,

  /// 连续定位、蓝点不会移动到地图中心点，定位点依照设备方向旋转，并且蓝点会跟随设备移动
  LOCATION_TYPE_LOCATION_ROTATE_NO_CENTER,

  /// 连续定位、蓝点不会移动到地图中心点，并且蓝点会跟随设备移动。
  LOCATION_TYPE_FOLLOW_NO_CENTER,

  /// 连续定位、蓝点不会移动到地图中心点，地图依照设备方向旋转，并且蓝点会跟随设备移动
  LOCATION_TYPE_MAP_ROTATE_NO_CENTER,
}
