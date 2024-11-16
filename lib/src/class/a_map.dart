part of '../../amap_view_muka.dart';

class AMap {
  final bool isMyLocationEnabled;

  final MyLocationStyle myLocationStyle;

  final UiSettings uiSettings;

  /// 3 国家地图
  ///
  /// 5 省级地图
  ///
  /// 10 市级地图
  ///
  /// 15 区级地图
  ///
  /// 18 街道地图
  final double zoom;

  const AMap({
    this.isMyLocationEnabled = false,
    this.myLocationStyle = const MyLocationStyle(),
    this.uiSettings = const UiSettings(),
    this.zoom = 18,
  });

  AMap copyWith({
    bool? isMyLocationEnabled,
    MyLocationStyle? myLocationStyle,
    UiSettings? uiSettings,
    double? zoom,
  }) {
    return AMap(
      isMyLocationEnabled: isMyLocationEnabled ?? this.isMyLocationEnabled,
      myLocationStyle: myLocationStyle ?? this.myLocationStyle,
      uiSettings: uiSettings ?? this.uiSettings,
      zoom: zoom ?? this.zoom,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isMyLocationEnabled': isMyLocationEnabled,
      'myLocationStyle': myLocationStyle.toJson(),
      'uiSettings': uiSettings.toJson(),
      'zoom': zoom,
    };
  }
}
