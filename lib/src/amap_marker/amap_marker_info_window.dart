part of amap_view_muka;

abstract class AMapMarkerInfoWindow {
  final Color backgroundColor;

  final double height;

  final double width;

  /// marker图标类型
  String get type => '';

  AMapMarkerInfoWindow({
    this.backgroundColor = Colors.white,
    this.width = 220.0,
    this.height = 110.0,
  });

  Map<String, dynamic> toJson() => {};
}

class AMapMarkerCardInfoWindow implements AMapMarkerInfoWindow {
  final Color backgroundColor;

  final double height;

  final double width;

  AMapMarkerCardInfoWindow({
    this.backgroundColor = Colors.white,
    this.width = 220.0,
    this.height = 110.0,
  });

  Map<String, dynamic> toJson() => {
        'width': this.width * window.devicePixelRatio,
        'height': this.height * window.devicePixelRatio,
        'backgroundColor': this.backgroundColor.toString(),
      };

  factory AMapMarkerCardInfoWindow.fromJson(Map<dynamic, dynamic> json) => AMapMarkerCardInfoWindow(
        backgroundColor: json['backgroundColor'],
        width: json['width'],
        height: json['height'],
      );

  @override
  String get type => 'marker#cardInfoWindow';
}
