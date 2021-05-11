part of amap_view_muka;

abstract class AmapMarkerInfoWindow {
  final Color backgroundColor;

  final double height;

  final double width;

  /// marker图标类型
  String get type => '';

  AmapMarkerInfoWindow({
    this.backgroundColor = Colors.white,
    this.width = 220.0,
    this.height = 110.0,
  });

  Map<String, dynamic> toJson() => {};
}

class AmapMarkerCardInfoWindow implements AmapMarkerInfoWindow {
  final Color backgroundColor;

  final double height;

  final double width;

  AmapMarkerCardInfoWindow({
    this.backgroundColor = Colors.white,
    this.width = 220.0,
    this.height = 110.0,
  });

  Map<String, dynamic> toJson() => {
        'width': this.width,
        'height': this.height,
        'backgroundColor': this.backgroundColor.toString(),
      };

  factory AmapMarkerCardInfoWindow.fromJson(Map<dynamic, dynamic> json) => AmapMarkerCardInfoWindow(
        backgroundColor: json['backgroundColor'],
        width: json['width'],
        height: json['height'],
      );

  @override
  String get type => 'marker#cardInfoWindow';
}
