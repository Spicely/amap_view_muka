// ignore_for_file: constant_identifier_names

part of '../../amap_view_muka.dart';

class MyLocationStyle {
  /// 只定位
  static const int LOCATION_TYPE_SHOW = 0;

  /// 定位、且将视角移动到地图中心点
  static const int LOCATION_TYPE_LOCATE = 1;

  /// 定位、且将视角移动到地图中心点，定位点跟随设备移动
  static const int LOCATION_TYPE_FOLLOW = 2;

  /// 定位、但不会移动到地图中心点，并且会跟随设备移动
  static const int LOCATION_TYPE_MAP_ROTATE = 3;

  /// 定位、且将视角移动到地图中心点，定位点依照设备方向旋转，并且会跟随设备移动
  static const int LOCATION_TYPE_LOCATION_ROTATE = 4;

  /// 定位、但不会移动到地图中心点，定位点依照设备方向旋转，并且会跟随设备移动
  static const int LOCATION_TYPE_LOCATION_ROTATE_NO_CENTER = 5;

  /// 定位、但不会移动到地图中心点，并且会跟随设备移动
  static const int LOCATION_TYPE_FOLLOW_NO_CENTER = 6;

  /// 定位、但不会移动到地图中心点，地图依照设备方向旋转，并且会跟随设备移动
  static const int LOCATION_TYPE_MAP_ROTATE_NO_CENTER = 7;

  final int myLocationType;

  const MyLocationStyle({
    this.myLocationType = LOCATION_TYPE_LOCATION_ROTATE,
  });

  MyLocationStyle copyWith({
    int? myLocationType,
  }) {
    return MyLocationStyle(
      myLocationType: myLocationType ?? this.myLocationType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'myLocationType': myLocationType,
    };
  }
}
